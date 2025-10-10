#!/usr/bin/env python3
import os
import re
import sys
import argparse
import sh
from pathlib import Path
import glob
import logging
# logging.basicConfig(level=logging.DEBUG)

perl = sh.Command('perl')

root = Path(__file__).parent.parent.resolve()
print(root)
def collect(pattern):
    return set(glob.glob((root / '**' / pattern).as_posix(), recursive=True))
files = collect('*.tex') | collect('*.bib')

print(f'Found {len(files)} files to process.')
script = perl.bake("-pe", "s/–/-/g; s/‘‘/\\\"/g; s/’’/\\\"/g; s/‘/'/g; s/’/'/g; s/“/\"/g; s/”/\"/g; s/…/.../g; s/¬\\s+//; ", '-i')
for f in files:
    print(script, f)
    script(f)
