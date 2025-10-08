#!/usr/bin/env python3
import os
import re
import sys
import argparse
from pathlib import Path

parser = argparse.ArgumentParser(
    description='Find+replace',
)
parser.add_argument('dir_or_file', type=str)
parser.add_argument('pattern', type=str)
parser.add_argument('replace_with', default='', type=str)
parser.add_argument('--extension', default='tex', type=str)
parser.add_argument('--inplace', '-i', action='store_true')

files = set()
args = parser.parse_args()
p = Path(args.dir_or_file)
if p.is_file():
    files.add(p)
elif p.is_dir():
    for root, dirs, fs in os.walk(p):
        for f in fs:
            if f.endswith('.' + args.extension):
                files.add(Path(root) / f)

print(f'Found {len(files)} files to process.')

pattern = re.compile(args.pattern)
for file in files:
    with open(file, 'r') as f:
        contents = f.read()
    new_contents = pattern.sub(args.replace_with, contents)
    f = open(file, 'w') if args.inplace else sys.stdout
    f.write(new_contents)
