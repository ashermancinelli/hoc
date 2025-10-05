#!/usr/bin/env python

import sys
import bibtexparser
import argparse
import datetime
import math

TEMPLATE = """
\\documentclass{{article}}
\\usepackage[utf8]{{inputenc}}
\\usepackage{{chronology}}
\\usepackage{{libertinus}}

\\sffamily
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
    argparser.add_argument('--years', type=str, help='Comma-separated bounds of years to include (--years=1990,2000)')
    parser = bibtexparser.bparser.BibTexParser(common_strings=True)
    writer = bibtexparser.bwriter.BibTexWriter()

    args = argparser.parse_args()
    with open(args.input, 'r') as bibtex_file:
        bib = parser.parse_file(bibtex_file)

    entries: list[dict] = bib.entries
    years = int(args.years[0]), int(args.years[1]) if args.years else -1, 4000
    year = str(datetime.datetime.now().year)

    entries = sorted(entries, key=lambda x: int(x.get("year", year)))
    if args.reversed:
        entries = list(reversed(entries))

    for e in entries:
        if 'year' not in e:
            print(e)
            return 1

    print('% Using entries from {} to {}'.format(min(years), max(years)))
    events = []
    for entry in entries:
        if 'year' in entry and min(years) <= int(entry['year']) <= max(years):
            title = entry.get('title', 'No Title')
            if 'author' in entry:
                title += ', ' + entry['author'].split(' and ')[0]
            events.append("\\eventpoint{{{year}}}{{{title}}}".format(
                year=entry['year'],
                title=title
            ))
    first, last = entries[0], entries[-1]
    if args.reversed:
        first, last = last, first
    sys.stdout.write(
        TEMPLATE.format(
            start_date=first['year'],
            end_date=last['year'],
            events='\n'.join(events),
        )
    )

    return 0

if __name__ == "__main__":
    sys.exit(main())
