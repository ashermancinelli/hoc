#!/usr/bin/env python3
"""Purpose-built, conservative LaTeX-to-Typst converter for this manuscript.

This is intentionally not a general TeX parser. It recognizes the constructs used
by ../hoc, preserves unknown commands visibly, and keeps inactive source as Typst
comments so that no research notes disappear during the migration.
"""

from __future__ import annotations

import json
import os
import re
import unicodedata
from pathlib import Path

SOURCE = Path(__file__).resolve().parents[2] / "hoc"
TARGET = Path(__file__).resolve().parents[1]


def tstr(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def balanced(text: str, pos: int, left: str = "{", right: str = "}") -> tuple[str, int]:
    if pos >= len(text) or text[pos] != left:
        return "", pos
    depth = 1
    i = pos + 1
    start = i
    while i < len(text):
        if text[i] == "\\":
            i += 2
            continue
        if text[i] == left:
            depth += 1
        elif text[i] == right:
            depth -= 1
            if depth == 0:
                return text[start:i], i + 1
        i += 1
    return text[start:], len(text)


def strip_outer_space(value: str) -> str:
    return value.strip(" \t\r\n")


def math_convert(value: str) -> str:
    value = value.strip()

    def matrix_repl(match: re.Match[str]) -> str:
        body = match.group("body")
        rows = re.split(r"\\\\", body)
        converted_rows = []
        for row in rows:
            cells = [math_convert(cell) for cell in row.split("&")]
            if any(cells):
                converted_rows.append(", ".join(cells))
        return "mat(" + "; ".join(converted_rows) + ")"

    matrix_pattern = re.compile(
        r"\\begin\{(?P<env>array|bmatrix)\}(?:\{[^}]*\})?(?P<body>.*?)\\end\{(?P=env)\}",
        re.S,
    )
    while matrix_pattern.search(value):
        value = matrix_pattern.sub(matrix_repl, value)
    value = re.sub(r"\\(?:left|right)\b", "", value)
    simple = {
        r"\\lambda": "lambda", r"\\Delta": "Delta", r"\\flat": "flat",
        r"\\approx": "approx", r"\\equiv": "equiv", r"\\sim": "tilde.op",
        r"\\times": "times", r"\\sum": "sum", r"\\dots": "dots.h",
        r"\\ldots": "dots.h", r"\\cdots": "dots.h.c", r"\\vdots": "dots.v", r"\\ddots": "dots.down",
        r"\\langle": "⟨", r"\\rangle": "⟩", r"\\quad": "quad",
        r"\\big": "",
        r"\\midrule": "", r"\\toprule": "", r"\\bottomrule": "",
    }
    for old, new in simple.items():
        value = re.sub(old + r"(?![A-Za-z])", new, value)

    def command_two(name: str, replacement):
        nonlocal value
        while True:
            m = re.search(r"\\" + name + r"\s*\{", value)
            if not m:
                break
            a, end_a = balanced(value, m.end() - 1)
            j = end_a
            while j < len(value) and value[j].isspace():
                j += 1
            if j >= len(value) or value[j] != "{":
                break
            b, end_b = balanced(value, j)
            value = value[:m.start()] + replacement(math_convert(a), math_convert(b)) + value[end_b:]

    command_two("frac", lambda a, b: f"({a}) / ({b})")

    for name, func in (("texttt", lambda x: f'op({tstr(x)})'),
                       ("text", lambda x: f'upright({tstr(x)})'),
                       ("textit", lambda x: tstr(x)),
                       ("overline", lambda x: f'overline({math_convert(x)})'),
                       ("overbar", lambda x: f'overline({math_convert(x)})')):
        while True:
            m = re.search(r"\\" + name + r"\s*\{", value)
            if not m:
                break
            arg, end = balanced(value, m.end() - 1)
            value = value[:m.start()] + func(arg) + value[end:]

    value = re.sub(r"_\{([^{}]*)\}", lambda m: "_(" + math_convert(m.group(1)) + ")", value)
    value = re.sub(r"\^\{([^{}]*)\}", lambda m: "^(" + math_convert(m.group(1)) + ")", value)
    value = value.replace(r"\\", r" \ ")
    value = value.replace(r"\,", " ").replace(r"\;", " ")
    value = value.replace("{", "(").replace("}", ")")
    value = re.sub(r"\\([A-Za-z]+)", lambda m: m.group(1), value)
    value = re.sub(r"\b(cosine|eval|lbound)\b", lambda m: tstr(m.group(1)), value)
    value = re.sub(r"\bFx\b", "F x", value)
    return value.strip()


class Converter:
    def __init__(self, source: Path):
        self.source = source
        self.text = source.read_text()
        self.pos = 0

    def read_group(self, optional: bool = False) -> str | None:
        while self.pos < len(self.text) and self.text[self.pos].isspace() and self.text[self.pos] != "\n":
            self.pos += 1
        left, right = ("[", "]") if optional else ("{", "}")
        if self.pos >= len(self.text) or self.text[self.pos] != left:
            return None
        value, self.pos = balanced(self.text, self.pos, left, right)
        return value

    def extract_environment(self, env: str) -> str:
        start = self.pos
        pattern = re.compile(r"\\(begin|end)\{" + re.escape(env) + r"\}")
        depth = 1
        for m in pattern.finditer(self.text, start):
            depth += 1 if m.group(1) == "begin" else -1
            if depth == 0:
                self.pos = m.end()
                return self.text[start:m.start()]
        self.pos = len(self.text)
        return self.text[start:]

    @staticmethod
    def literal(text: str) -> str:
        text = text.replace("``", "“").replace("''", "”")
        text = text.replace("#", r"\#").replace("@", r"\@")
        return text

    def convert_fragment(self, value: str) -> str:
        sub = Converter.__new__(Converter)
        sub.source = self.source
        sub.text = value
        sub.pos = 0
        return sub.parse()

    def project_path(self, value: str, suffix: str | None = None) -> str:
        path = Path(value)
        if suffix is not None:
            path = path.with_suffix(suffix)
        source_parent = self.source.relative_to(SOURCE).parent
        return Path(os.path.relpath(path, source_parent)).as_posix()

    def command_arg(self, wrapper: str) -> str:
        arg = self.read_group()
        return wrapper.format(self.convert_fragment(arg or ""))

    def convert_items(self, body: str, ordered: bool) -> str:
        parts = re.split(r"(?<!\\)\\item\b", body)
        items = [self.convert_fragment(p).strip() for p in parts[1:] if p.strip()]
        fn = "enum" if ordered else "list"
        return f"#{fn}(\n" + "\n".join(f"  [{x}]," for x in items) + "\n)\n"

    def convert_tabular(self, body: str, spec: str) -> str:
        # Keep horizontal rules as rows; they remain visible without trying to
        # reproduce TeX's exact booktabs geometry.
        body = re.sub(r"\\(?:toprule|midrule|bottomrule|hline)\b", r"\\\\", body)
        rows = re.split(r"(?<!\\)\\\\(?:\[[^\]]*\])?", body)
        parsed: list[list[str]] = []
        for row in rows:
            row = row.strip()
            if not row:
                continue
            cells = [self.convert_fragment(x.strip()).strip() for x in re.split(r"(?<!\\)&", row)]
            if any(cells):
                parsed.append(cells)
        cols = max([len(r) for r in parsed] + [max(1, len(re.findall(r"[lcrX]", spec)))])
        out = [f"#table(columns: {cols}, inset: 5pt, stroke: 0.4pt,"]
        for row in parsed:
            row += [""] * (cols - len(row))
            out.extend(f"  [{cell}]," for cell in row)
        out.append(")\n")
        return "\n".join(out)

    def convert_figure(self, body: str, kind: str = "image") -> str:
        caption = None
        label = None

        def take_command(src: str, name: str) -> tuple[str | None, str]:
            m = re.search(r"\\" + name + r"\s*\{", src)
            if not m:
                return None, src
            arg, end = balanced(src, m.end() - 1)
            return arg, src[:m.start()] + src[end:]

        caption, body = take_command(body, "caption")
        label, body = take_command(body, "label")
        body = re.sub(r"\\centering\b", "", body)
        converted = self.convert_fragment(body).strip()
        args = [f"[{converted}]", f"kind: {kind}"]
        if caption is not None:
            args.append(f"caption: [{self.convert_fragment(caption).strip()}]")
        out = "#figure(\n  " + ",\n  ".join(args) + "\n)"
        if label:
            out += f" <{label}>"
        return out + "\n"

    def convert_environment(self, env: str, opt: str | None) -> str:
        if env in {"minted", "lstlisting"}:
            lang = self.read_group() if env == "minted" else None
            body = self.extract_environment(env)
            if env == "lstlisting" and opt:
                m = re.search(r"language\s*=\s*([^,\]]+)", opt, re.I)
                lang = m.group(1).strip().lower() if m else None
            # Convert the manuscript's Minted escape regions back to their
            # annotated text. Typst's raw blocks do not support inline markup.
            body = re.sub(r"\|\\textbfit\{([^{}]*)\}\|", r"\1", body)
            body = body.replace(r"$\dots$", "…")
            return f"#code-block({tstr(body.strip(chr(10)))}, lang: {tstr((lang or 'text').lower())})\n"

        body = self.extract_environment(env)
        if env == "quotation":
            return f"#quote(block: true)[\n{self.convert_fragment(body).strip()}\n]\n"
        if env == "center":
            return f"#align(center)[\n{self.convert_fragment(body).strip()}\n]\n"
        if env in {"itemize", "enumerate"}:
            return self.convert_items(body, env == "enumerate")
        if env == "figure":
            return self.convert_figure(body)
        if env == "table":
            return self.convert_figure(body, "table")
        if env in {"tabular", "tabularx"}:
            # tabularx has a width argument before the column specification.
            temp = Converter.__new__(Converter)
            temp.source, temp.text, temp.pos = self.source, body, 0
            spec = opt or ""
            return self.convert_tabular(body, spec)
        if env in {"align", "array", "bmatrix"}:
            # These few environments are retained as centered mathematical
            # source when a one-to-one native Typst layout is not appropriate.
            return f"#align(center, code-block({tstr(body.strip())}, lang: \"latex-math\"))\n"
        if env in {"luacode", "luacode*"}:
            return f"#deferred(\"Generated Lua content\", {tstr(body.strip())})\n"
        if env == "document":
            return self.convert_fragment(body)
        return f"#block[\n{self.convert_fragment(body).strip()}\n]\n"

    def parse_command(self) -> str:
        assert self.text[self.pos] == "\\"
        self.pos += 1
        if self.pos >= len(self.text):
            return r"\\"
        if not self.text[self.pos].isalpha():
            ch = self.text[self.pos]
            self.pos += 1
            if ch in {'"', "'", "`", "~", "^"}:
                arg = self.read_group()
                if arg is None and self.pos < len(self.text):
                    arg = self.text[self.pos]
                    self.pos += 1
                marks = {'"': "\u0308", "'": "\u0301", "`": "\u0300", "~": "\u0303", "^": "\u0302"}
                return unicodedata.normalize("NFC", (arg or "") + marks[ch])
            if ch == "[":
                end = self.text.find(r"\]", self.pos)
                if end < 0:
                    end = len(self.text)
                value = self.text[self.pos:end]
                self.pos = min(len(self.text), end + 2)
                return f"\n$ {math_convert(value)} $\n"
            return {"&": "&", "%": "%", "#": r"\#", "_": r"\_", "$": r"\$",
                    "{": "{", "}": "}", "\\": r"\\"}.get(ch, ch)
        start = self.pos
        while self.pos < len(self.text) and (self.text[self.pos].isalpha() or self.text[self.pos] == "@"):
            self.pos += 1
        name = self.text[start:self.pos]
        if self.pos < len(self.text) and self.text[self.pos] == "*":
            name += "*"
            self.pos += 1

        if name == "begin":
            env = self.read_group() or ""
            if env == "tabular":
                opt = self.read_group()
            elif env == "tabularx":
                self.read_group()  # width; Typst tables use the available width
                opt = self.read_group()
            else:
                opt = self.read_group(optional=True)
            return self.convert_environment(env, opt)
        if name == "end":
            self.read_group()
            return ""
        if name in {"input", "include"}:
            arg = self.read_group() or ""
            return f'#include {tstr(self.project_path(arg, ".typ"))}\n'
        if name in {"chapter", "section", "subsection", "subsubsection", "paragraph"}:
            arg = self.read_group() or ""
            level = {"chapter": 1, "section": 2, "subsection": 3, "subsubsection": 4, "paragraph": 5}[name]
            return f"\n{'=' * level} {self.convert_fragment(arg).strip()}\n"
        if name == "chapterstar":
            return "\n= " + self.convert_fragment(self.read_group() or "").strip() + "\n"
        if name == "label":
            return f" <{self.read_group() or ''}>"
        if name in {"ref", "cref", "Cref"}:
            key = self.read_group() or ""
            return f"#xref(<{key}>, capital: {'true' if name == 'Cref' else 'false'})"
        if name == "pageref":
            return f"#ref(<{self.read_group() or ''}>, form: \"page\")"

        citation_forms = {
            "cite": "normal", "citep": "normal", "parencite": "normal",
            "textcite": "prose", "citeauthor": "author", "citeyear": "year",
        }
        if name in citation_forms:
            opt = self.read_group(optional=True)
            key = self.read_group() or ""
            supplement = f", supplement: [{self.convert_fragment(opt)}]" if opt else ""
            return f"#cite(<{key}>, form: {tstr(citation_forms[name])}{supplement})"
        if name == "citetitle":
            opt = self.read_group(optional=True)
            key = self.read_group() or ""
            return f"#cite-title(<{key}>)"
        if name == "citedate":
            self.read_group(optional=True)
            return f"#cite(<{self.read_group() or ''}>, form: \"year\")"
        if name == "longcite":
            key = self.read_group() or ""
            return f"#cite-title(<{key}>), #cite(<{key}>, form: \"prose\")"
        if name == "quotesection":
            key = self.read_group() or ""
            return f"\n== #cite-title(<{key}>)\n#cite(<{key}>, form: \"prose\")\n"

        glossary_forms = {
            "gls": "gls", "Gls": "gls-cap", "GLS": "gls-upper",
            "acrshort": "acr-short", "arcshort": "acr-short",
            "acrlong": "acr-long", "acrfull": "acr-full",
        }
        if name in glossary_forms:
            return f"#{glossary_forms[name]}({tstr(self.read_group() or '')})"

        one_arg = {
            "textit": "#emph[{}]", "emph": "#emph[{}]", "textbf": "#strong[{}]",
            "textbfit": "#strong[#emph[{}]]", "underline": "#underline[{}]",
            "sffamily": "{}", "normalfont": "{}",
            "textsuperscript": "#super[{}]", "noindent": "{}", "todo": "#todo[{}]", "url": "#link({0})[{0}]",
        }
        if name in one_arg:
            arg = self.read_group() or ""
            converted = self.convert_fragment(arg)
            if name == "url":
                return f"#link({tstr(arg)})[{self.literal(arg)}]"
            return one_arg[name].format(converted)
        if name == "texttt":
            arg = self.read_group() or ""
            arg = arg.replace(r"\_", "_").replace(r"\%", "%").replace(r"\&", "&")
            return f"#mono-text({tstr(arg)})"
        if name == "href":
            url = self.read_group() or ""
            label = self.read_group() or url
            return f"#link({tstr(url)})[{self.convert_fragment(label)}]"
        if name == "footnote":
            return f"#footnote[{self.convert_fragment(self.read_group() or '')}]"
        if name == "includegraphics":
            opt = self.read_group(optional=True) or ""
            path = self.read_group() or ""
            width = None
            m = re.search(r"width\s*=\s*([.0-9]+)\\(?:textwidth|linewidth|columnwidth)", opt)
            if m:
                width = f", width: {float(m.group(1)) * 100:g}%"
            m = re.search(r"height\s*=\s*([.0-9]+)\\textheight", opt)
            if m:
                width = f", height: {float(m.group(1)) * 100:g}%"
            return f"#image({tstr(self.project_path(path))}{width or ''})"
        if name in {"inputminted", "lstinputlisting"}:
            opt = self.read_group(optional=True) or ""
            lang = "text"
            if name == "inputminted":
                lang = self.read_group() or "text"
            else:
                m = re.search(r"language\s*=\s*([^,]+)", opt, re.I)
                if m:
                    lang = m.group(1).strip().lower()
            path = self.read_group() or ""
            return f"#code-file({tstr(path)}, lang: {tstr(lang.lower())})\n"

        fixed = {
            "FTN": "#mono[FORTRAN]", "FTNI": "#mono[FORTRAN I]",
            "FTNII": "#mono[FORTRAN II]", "FTNIII": "#mono[FORTRAN III]",
            "ftn": "#mono[Fortran]", "tex": "TeX", "metafont": "#mono[METAFONT]",
            "lam": "λ", "lamc": "λ-calculus", "lambdacalc": "λ-calculus",
            "lambdacalci": "λ-calculi", "Lambdacalc": "λ-Calculus",
            "lambdanot": "λ-notation", "textlambda": "λ", "textalpha": "α",
            "textphi": "φ", "dots": "…", "ldots": "…", "bigskip": "\n\n",
            "quad": "  ", "vspace": "", "hspace": "", "centering": "",
            "noindent": "", "today": "#datetime.today().display()",
        }
        if name in fixed:
            # Consume ignored spacing arguments where present.
            if name in {"vspace", "hspace"}:
                self.read_group()
            return fixed[name]
        if name in {"iftrue", "fi"}:
            return ""
        if name == "iffalse":
            end = self.text.find(r"\fi", self.pos)
            if end < 0:
                end = len(self.text)
            body = self.text[self.pos:end]
            self.pos = min(len(self.text), end + 3)
            return "\n/* Inactive LaTeX source retained for later editing:\n" + body.replace("*/", "* /") + "\n*/\n"
        if name in {"documentclass", "usepackage", "newcommand", "LetLtxMacro", "newtoggle",
                    "togglefalse", "setcounter", "addbibresource", "titleformat", "titlespacing",
                    "title", "author", "date", "setminted", "lstset", "setacronymstyle",
                    "makeglossaries", "newglossaryentry", "newacronym", "printglossary",
                    "printbibliography", "maketitle", "tableofcontents", "nocite", "directlua",
                    "iftoggle", "fontfamily", "raggedbottom", "glsaddall", "addcontentsline"}:
            # These files are hand-authored in Typst; if encountered in a chapter,
            # retain a visible marker rather than attempting macro expansion.
            return f"/* untranslated setup command: \\{name} */"

        # A handful of math commands can occur outside $...$ in the original.
        if name in {"Delta", "lambda", "flat", "sim", "approx", "equiv", "times"}:
            converted_math = math_convert("\\" + name)
            return f"${converted_math}$"

        # Conservative fallback: keep the command name and convert one argument,
        # making unsupported constructs obvious without breaking compilation.
        arg = self.read_group()
        if arg is not None:
            return f"#unsupported({tstr(name)})[{self.convert_fragment(arg)}]"
        return self.literal("\\" + name)

    def parse(self) -> str:
        out: list[str] = []
        plain: list[str] = []

        def flush() -> None:
            if plain:
                out.append(self.literal("".join(plain)))
                plain.clear()

        while self.pos < len(self.text):
            ch = self.text[self.pos]
            if ch == "%":
                flush()
                end = self.text.find("\n", self.pos)
                if end < 0:
                    end = len(self.text)
                out.append("//" + self.text[self.pos + 1:end] + "\n")
                self.pos = min(len(self.text), end + 1)
            elif ch == "\\":
                flush()
                out.append(self.parse_command())
            elif ch == "$":
                flush()
                end = self.pos + 1
                while end < len(self.text) and self.text[end] != "$":
                    end += 2 if self.text[end] == "\\" else 1
                value = self.text[self.pos + 1:end]
                out.append(f"${math_convert(value)}$")
                self.pos = min(len(self.text), end + 1)
            else:
                plain.append(ch)
                self.pos += 1
        flush()
        result = "".join(out)
        result = re.sub(r"\{([^\x00-\x7f])\}", r"\1", result)
        result = re.sub(r"[ \t]+\n", "\n", result)
        result = re.sub(r"\n{4,}", "\n\n\n", result)
        return result


def convert_chapters() -> None:
    for src in sorted((SOURCE / "chapters").rglob("*.tex")):
        rel = src.relative_to(SOURCE).with_suffix(".typ")
        dest = TARGET / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        root_rel = Path(os.path.relpath(TARGET, dest.parent)).as_posix()
        prefix = (
            f'#import "{root_rel}/macros.typ": *\n'
            f'#import "{root_rel}/glossaries.typ": *\n\n'
        )
        converted = Converter(src).parse()
        if rel.as_posix() == "chapters/dawn/dawn-timeline.typ":
            converted = converted.replace("<tab:early-compiler-timeline>", "<fig:dawn-timeline>")
        if rel.as_posix() == "chapters/codesign/mlir.typ":
            marker = "\n\nThe figure given in #xref(<fig:flang-mlir-lowering>"
            diagram = '''
#figure(
  code-file("chapters/codesign/flang.dot", lang: "dot"),
  kind: image,
  caption: [MLIR Lowering in Flang],
) <fig:flang-mlir-lowering>
'''
            converted = converted.replace(marker, diagram + marker)
        dest.write_text(prefix + converted)


def parse_glossary_entries() -> tuple[list[tuple[str, str, str]], list[tuple[str, str, str, str]]]:
    text = (SOURCE / "glossaries.tex").read_text()
    terms: list[tuple[str, str, str]] = []
    acronyms: list[tuple[str, str, str, str]] = []
    i = 0
    while i < len(text):
        term = text.find(r"\newglossaryentry", i)
        acronym = text.find(r"\newacronym", i)
        choices = [(p, k) for p, k in ((term, "term"), (acronym, "acronym")) if p >= 0]
        if not choices:
            break
        pos, kind = min(choices)
        if kind == "term":
            pos += len(r"\newglossaryentry")
            while pos < len(text) and text[pos].isspace(): pos += 1
            key, pos = balanced(text, pos)
            while pos < len(text) and text[pos].isspace(): pos += 1
            fields, pos = balanced(text, pos)
            name_m = re.search(r"\bname\s*=\s*\{", fields)
            desc_m = re.search(r"\bdescription\s*=\s*\{", fields)
            name = balanced(fields, name_m.end() - 1)[0] if name_m else key
            desc = balanced(fields, desc_m.end() - 1)[0] if desc_m else ""
            terms.append((key, name, desc))
        else:
            pos += len(r"\newacronym")
            while pos < len(text) and text[pos].isspace(): pos += 1
            desc = ""
            if pos < len(text) and text[pos] == "[":
                opts, pos = balanced(text, pos, "[", "]")
                dm = re.search(r"description\s*=\s*\{", opts)
                if dm:
                    desc = balanced(opts, dm.end() - 1)[0]
            while pos < len(text) and text[pos].isspace(): pos += 1
            key, pos = balanced(text, pos)
            while pos < len(text) and text[pos].isspace(): pos += 1
            short, pos = balanced(text, pos)
            while pos < len(text) and text[pos].isspace(): pos += 1
            long, pos = balanced(text, pos)
            acronyms.append((key, short, long, desc))
        i = pos
    return terms, acronyms


def generate_glossaries() -> None:
    terms, acronyms = parse_glossary_entries()
    conv = Converter(SOURCE / "glossaries.tex")
    term_names = {key: name for key, name, _ in terms}
    acronym_values = {key: (short, long) for key, short, long, _ in acronyms}

    def render(value: str) -> str:
        out = conv.convert_fragment(value).strip()
        for key, name in term_names.items():
            out = out.replace(f'#gls({tstr(key)})', conv.convert_fragment(name).strip())
            out = out.replace(f'#gls-cap({tstr(key)})', conv.convert_fragment(name).strip())
        for key, (short, long) in acronym_values.items():
            short_out = conv.convert_fragment(short).strip()
            long_out = conv.convert_fragment(long).strip()
            out = out.replace(f'#gls({tstr(key)})', short_out)
            out = out.replace(f'#acr-short({tstr(key)})', short_out)
            out = out.replace(f'#acr-long({tstr(key)})', long_out)
            out = out.replace(f'#acr-full({tstr(key)})', f'{long_out} ({short_out})')
        return out

    lines = ["// Generated from hoc/glossaries.tex by tools/convert.py.", '#import "macros.typ": mono, mono-text, todo, unsupported', "#let glossary-entries = ("]
    for key, name, desc in terms:
        lines.append(f"  {tstr(key)}: (name: [{render(name)}], description: [{render(desc)}]),")
    lines.append(")\n")
    lines.append("#let acronym-entries = (")
    for key, short, long, desc in acronyms:
        lines.append(f"  {tstr(key)}: (short: [{render(short)}], long: [{render(long)}], description: [{render(desc)}]),")
    lines.append(")\n")
    lines.append('''#let gls(key) = if key in glossary-entries { glossary-entries.at(key).name } else { acronym-entries.at(key).short }
#let gls-cap(key) = gls(key)
#let gls-upper(key) = upper(gls(key))
#let acr-short(key) = acronym-entries.at(key).short
#let acr-long(key) = acronym-entries.at(key).long
#let acr-full(key) = [#acr-long(key) (#acr-short(key))]

#let print-glossaries() = {
  pagebreak()
  heading(level: 1, outlined: true)[Acronyms]
  for (key, entry) in acronym-entries {
    terms.item(entry.short, [#entry.long. #entry.description])
  }
  pagebreak()
  heading(level: 1, outlined: true)[Glossary]
  for (key, entry) in glossary-entries {
    terms.item(entry.name, entry.description)
  }
}
''')
    (TARGET / "glossaries.typ").write_text("\n".join(lines))


def normalize_bibliography() -> None:
    """Make the existing BibLaTeX data acceptable to Typst's strict parser."""
    text = (SOURCE / "refs.bib").read_text()
    for command in ("texttt", "textit", "emph", "url"):
        pattern = re.compile(r"\\" + command + r"\s*\{")
        while True:
            match = pattern.search(text)
            if not match:
                break
            arg, end = balanced(text, match.end() - 1)
            text = text[:match.start()] + arg + text[end:]
    text = text.replace(r"\textbar", "|").replace(r"\textcopyright", "©")
    text = re.sub(r"\{\\(?:em|tt)\s+([^{}]*)\}", r"{\1}", text)
    text = re.sub(r"(month\s*=\s*)march\b", r"\1mar", text)
    text = re.sub(
        r"note\s*=\s*\{Accessed: 2025-11-08\},\s*\n\s*year\s*=\s*\{n\.d\.\}",
        "note         = {No date. Accessed: 2025-11-08}",
        text,
    )
    (TARGET / "refs.bib").write_text(text)


if __name__ == "__main__":
    convert_chapters()
    generate_glossaries()
    normalize_bibliography()
