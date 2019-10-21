#!/bin/bash

# https://stackoverflow.com/a/246128
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -euo pipefail

DATADIR="$SCRIPTDIR/../data"

for vocab in "$DATADIR"/*/vocab.txt; do
    d=$(basename $(dirname $vocab))
    if [[ $d == *uncased* ]]; then
	params="--lowercase"
    elif [[ $d == *multilingual* ]]; then
	params="--lowercase"	
    else
	params=""
    fi
    for text in "$DATADIR"/*-wiki-sample.txt; do
	b=$(basename $text .txt)
	python3 "$SCRIPTDIR/evalvocab.py" $params "$vocab" "$text" 2>/dev/null \
	    | perl -pe 's/^/'"$d"'\t'"$b"'\t/'
    done
done
