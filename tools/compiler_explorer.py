#!/usr/bin/env python3

import argparse
import json
import os
import sys
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


DEFAULT_BASE_URL = "https://godbolt.org"
USER_AGENT = "hoc-typst/compiler-explorer"


def request_json(url, *, payload=None, timeout=60):
    data = None
    headers = {
        "Accept": "application/json",
        "User-Agent": USER_AGENT,
    }
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"

    request = urllib.request.Request(url, data=data, headers=headers)
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace").strip()
        message = f"Compiler Explorer returned HTTP {error.code} for {url}"
        if detail:
            message += f":\n{detail}"
        raise RuntimeError(message) from error
    except urllib.error.URLError as error:
        raise RuntimeError(f"could not reach Compiler Explorer at {url}: {error.reason}") from error


def atomic_write(path, contents):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=path.parent,
            prefix=f".{path.name}.",
            delete=False,
        ) as output:
            temporary = Path(output.name)
            output.write(contents)
        os.replace(temporary, path)
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()


def json_text(value):
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def compiler_diagnostics(result):
    lines = []
    pending = [result]
    while pending:
        current = pending.pop(0)
        if not isinstance(current, dict):
            continue
        for channel in ("stdout", "stderr"):
            entries = current.get(channel, [])
            if isinstance(entries, str):
                entries = [entries]
            for entry in entries:
                text = entry.get("text", "") if isinstance(entry, dict) else str(entry)
                if text and text not in lines:
                    lines.append(text)
        pending.extend(
            current.get(key)
            for key in ("buildResult", "execResult")
            if current.get(key) is not None
        )
    return "\n".join(lines)


def assembly_text(result):
    assembly = result.get("asm")
    if not isinstance(assembly, list):
        raise RuntimeError("Compiler Explorer response did not contain an assembly listing")
    lines = []
    for entry in assembly:
        text = entry.get("text", "") if isinstance(entry, dict) else str(entry)
        lines.append(text)
    return "\n".join(lines) + "\n"


def output_text(entries):
    if isinstance(entries, str):
        return entries
    if not isinstance(entries, list):
        raise RuntimeError("Compiler Explorer response did not contain the requested output")
    lines = []
    for entry in entries:
        text = entry.get("text", "") if isinstance(entry, dict) else str(entry)
        lines.append(text)
    return "\n".join(lines) + ("\n" if lines else "")


def library_spec(value):
    library, separator, version = value.partition(":")
    if not separator or not library or not version:
        raise argparse.ArgumentTypeError("library must have the form ID:VERSION")
    return {"id": library, "version": version}


def fetch_compilers(args):
    language = urllib.parse.quote(args.language, safe="")
    url = f"{args.base_url}/api/compilers/{language}"
    compilers = request_json(url, timeout=args.timeout)
    if not isinstance(compilers, list):
        raise RuntimeError("Compiler Explorer returned an invalid compiler list")
    atomic_write(args.output, json_text(compilers))


def remote_filename(path, base_dir):
    path = path.resolve()
    try:
        return path.relative_to(base_dir).as_posix()
    except ValueError as error:
        raise RuntimeError(f"additional file {path} is outside base directory {base_dir}") from error


def compile_source(args):
    source = args.source.resolve()
    base_dir = (args.base_dir or source.parent).resolve()
    files = [
        {
            "filename": remote_filename(path, base_dir),
            "contents": path.read_text(encoding="utf-8"),
        }
        for path in args.files
    ]

    execute = args.format == "stdout"
    payload = {
        "source": source.read_text(encoding="utf-8"),
        "options": {
            "userArguments": args.arguments,
            "compilerOptions": {
                "skipAsm": False,
                "executorRequest": execute,
                "overrides": [],
            },
            "filters": {
                "binary": False,
                "binaryObject": False,
                "commentOnly": args.comment_only,
                "demangle": args.demangle,
                "directives": args.directives,
                "execute": execute,
                "intel": args.intel,
                "labels": True,
                "libraryCode": False,
                "trim": args.trim,
                "debugCalls": False,
            },
            "tools": [],
            "libraries": args.library,
            "executeParameters": {
                "args": args.execute_argument,
                "stdin": args.stdin,
                "runtimeTools": [],
            },
        },
        "files": files,
    }
    if args.language is not None:
        payload["lang"] = args.language

    compiler = urllib.parse.quote(args.compiler, safe="")
    url = f"{args.base_url}/api/compiler/{compiler}/compile"
    result = request_json(url, payload=payload, timeout=args.timeout)
    if not isinstance(result, dict):
        raise RuntimeError("Compiler Explorer returned an invalid compilation result")
    if result.get("code") != 0:
        diagnostics = compiler_diagnostics(result)
        message = f"Compiler Explorer compilation failed with exit code {result.get('code')}"
        if diagnostics:
            message += f":\n{diagnostics}"
        raise RuntimeError(message)

    if args.format == "json":
        contents = json_text(result)
    elif args.format == "asm":
        contents = assembly_text(result)
    else:
        execution = result.get("execResult")
        if execution is None and result.get("didExecute"):
            execution = result
        if not isinstance(execution, dict):
            raise RuntimeError("Compiler Explorer response did not contain an execution result")
        if execution.get("code") != 0:
            diagnostics = output_text(execution.get("stderr", []))
            message = f"Compiler Explorer execution failed with exit code {execution.get('code')}"
            if diagnostics:
                message += f":\n{diagnostics.rstrip()}"
            raise RuntimeError(message)
        contents = output_text(execution.get("stdout", []))
    atomic_write(args.output, contents)


def parser():
    result = argparse.ArgumentParser(
        description="Fetch compiler metadata and compile files with Compiler Explorer."
    )
    result.add_argument("--base-url", default=DEFAULT_BASE_URL)
    result.add_argument("--timeout", type=float, default=60)
    subparsers = result.add_subparsers(dest="command", required=True)

    compilers = subparsers.add_parser("compilers", help="fetch compilers for a language")
    compilers.add_argument("language", help="Compiler Explorer language ID, such as c++")
    compilers.add_argument("output", type=Path)
    compilers.set_defaults(function=fetch_compilers)

    compile_parser = subparsers.add_parser("compile", help="compile a source file")
    compile_parser.add_argument("compiler", help="compiler ID from the compilers command")
    compile_parser.add_argument("source", type=Path, help="primary source file")
    compile_parser.add_argument("output", type=Path)
    compile_parser.add_argument("files", type=Path, nargs="*", help="additional source files")
    compile_parser.add_argument(
        "--base-dir",
        type=Path,
        help="base directory for additional filenames (defaults to the source directory)",
    )
    compile_parser.add_argument("--language", help="optional Compiler Explorer language ID")
    compile_parser.add_argument("--arguments", default="", help="compiler command-line arguments")
    compile_parser.add_argument(
        "--library",
        action="append",
        default=[],
        type=library_spec,
        metavar="ID:VERSION",
        help="enable a Compiler Explorer library (repeatable)",
    )
    compile_parser.add_argument(
        "--format",
        choices=("json", "asm", "stdout"),
        default="json",
        help="stdout requests execution and writes only program stdout",
    )
    compile_parser.add_argument(
        "--execute-argument",
        action="append",
        default=[],
        help="program argument for stdout execution (repeatable)",
    )
    compile_parser.add_argument("--stdin", default="", help="standard input for stdout execution")
    compile_parser.add_argument("--comment-only", action=argparse.BooleanOptionalAction, default=True)
    compile_parser.add_argument("--demangle", action=argparse.BooleanOptionalAction, default=True)
    compile_parser.add_argument("--directives", action=argparse.BooleanOptionalAction, default=True)
    compile_parser.add_argument("--intel", action=argparse.BooleanOptionalAction, default=False)
    compile_parser.add_argument("--trim", action=argparse.BooleanOptionalAction, default=False)
    compile_parser.set_defaults(function=compile_source)
    return result


def main():
    args = parser().parse_args()
    args.base_url = args.base_url.rstrip("/")
    try:
        args.function(args)
    except (OSError, RuntimeError, ValueError, json.JSONDecodeError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
