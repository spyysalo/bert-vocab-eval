#!/usr/bin/env python3

import sys
import os
import re

SCRIPTDIR = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(SCRIPTDIR, '../bert'))
import tokenization    # BERT tokenization

from collections import Counter


def argparser():
    from argparse import ArgumentParser
    ap = ArgumentParser()
    ap.add_argument('vocab', help='BERT vocabulary')
    ap.add_argument('-f', '--frequencies', default=False, action='store_true')
    ap.add_argument('-e', '--echo', default=False, action='store_true')
    ap.add_argument('-l', '--lowercase', default=False, action='store_true')
    ap.add_argument('text', nargs='+')
    return ap


def main(argv):
    args = argparser().parse_args(argv[1:])
    basic_tokenizer = tokenization.BasicTokenizer(do_lower_case=args.lowercase)
    full_tokenizer = tokenization.FullTokenizer(args.vocab,
                                                do_lower_case=args.lowercase)
    count = Counter()
    freqs = { v: 0 for v in full_tokenizer.vocab }
    for fn in args.text:
        with open(fn) as f:
            for ln, l in enumerate(f, start=1):
                l = l.rstrip('\n')
                if not l or l.isspace():
                    continue
                basic_tokens = basic_tokenizer.tokenize(l)
                wordpieces = full_tokenizer.tokenize(l)
                if args.echo:
                    print('INPUT:', l)
                    print('BASIC:', ' '.join(basic_tokens))
                    print('FULL :', ' '.join(wordpieces))
                if args.frequencies:
                    for w in wordpieces:
                        freqs[w] += 1
                count['whitespace-tokens'] += len(l.split())
                count['basic-tokens'] += len(basic_tokens)
                count['wordpieces'] += len(wordpieces)
                count['unknown'] += len([w for w in wordpieces if w == '[UNK]'])
                count['lines'] += 1
    if args.frequencies:
        for k, v in sorted(freqs.items(), key=lambda v: -v[1]):
            print('{}\t{}'.format(v, k))
    for k, v in count.items():
        print('{}\t{}'.format(k, v))
    print('worpieces/basic-tokens\t{}'.format(
        count['wordpieces']/count['basic-tokens']))
    print('unknown/basic-tokens\t{}'.format(
        count['unknown']/count['basic-tokens']))
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
