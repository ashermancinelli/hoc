#!/usr/bin/env python

import sys
import bibtexparser
import argparse
import datetime

TEMPLATE = """
\\documentclass{{article}}
\\usepackage[utf8]{{inputenc}}
\\usepackage{{chronology}}
\\usepackage{{libertinus}}

\\begin{{document}}

\\begin{{chronology}}[5]{{{start_date}}}{{{end_date}}}{{\\textwidth-5em}}[300ex]
{events}
\\end{{chronology}}

\\end{{document}}
"""

def main():
    argparser = argparse.ArgumentParser(description="Process a BibTeX file and output a timeline of entries.")
    argparser.add_argument("input", help="Input BibTeX file")
    argparser.add_argument(
        "--reversed", "-r", action="store_true", help="Reverse the timeline order"
    )
    parser = bibtexparser.bparser.BibTexParser(common_strings=True)
    writer = bibtexparser.bwriter.BibTexWriter()

    args = argparser.parse_args()
    with open(args.input, 'r') as bibtex_file:
        bib = parser.parse_file(bibtex_file)

    entries: list[dict] = bib.entries
    year = str(datetime.datetime.now().year)

    entries = sorted(entries, key=lambda x: int(x.get("year", year)))
    if args.reversed:
        entries = list(reversed(entries))

    for e in entries:
        if 'year' not in e:
            print(e)
            return 1

    events = "\n".join(
        f"\\eventpoint{{{entry['year']}}}{{{entry.get('title', 'No Title').replace('_', '\\_')}}}"
        for entry in entries if 'year' in entry
    )
    first, last = entries[0], entries[-1]
    if args.reversed:
        first, last = last, first
    sys.stdout.write(
        TEMPLATE.format(
            start_date=first['year'],
            end_date=last['year'],
            events=events,
        )
    )

    return 0

if __name__ == "__main__":
    sys.exit(main())
