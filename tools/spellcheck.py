#!/usr/bin/env -S uv run --script --python 3.13 --with sh --with pyenchant --no-project
import enchant
import sh
from pathlib import Path
import glob
import re

ROOT = Path(__file__).parent.parent.resolve()

WORDS = ROOT / 'words.txt'
LANG = "en_US"
d = enchant.DictWithPWL(LANG, str(WORDS))
WORD_RE = re.compile(r"[A-Za-zÀ-ÖØ-öø-ÿ][A-Za-zÀ-ÖØ-öø-ÿ']+")

corrections = 0
for f in glob.glob((ROOT / '**' / '*.tex').as_posix(), recursive=True):
    f = Path(f)
    print(f"Checking {f}")
    with open(f) as fp:
        for n, line in enumerate(fp, 1):
            for word in WORD_RE.findall(line):
                if not d.check(word):
                    path = f.relative_to(ROOT)
                    print(f"{path}:{n}: {word} ? {d.suggest(word)}")
                    corrections += 1

print(f"Found {corrections} possible corrections.")
