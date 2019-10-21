#!/usr/bin/env python

# Sample tokens from WikiExtractor output

import sys
import os
import random

from berttokenizer import basic_tokenize


def argparser():
    from argparse import ArgumentParser
    ap = ArgumentParser()
    ap.add_argument('ratio', type=float)
    ap.add_argument('text', nargs='+')
    return ap


def skip_line(line):
    if line.isspace() or not line:
        return True
    elif line.startswith('<doc') or line.startswith('</doc'):
        return True
    else:
        return False


def sample_wiki_text(fn, options):
    tokens = []
    with open(fn) as f:
        for ln, l in enumerate(f, start=1):
            l = l.rstrip()
            if skip_line(l):
                continue
            tokens.extend(basic_tokenize(l))
    return random.sample(tokens, int(len(tokens)*options.ratio))


def main(argv):
    args = argparser().parse_args(argv[1:])
    for fn in args.text:
        print(' '.join(sample_wiki_text(fn, args)))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
