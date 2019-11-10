#!/bin/bash

# Download vocabularies

# https://stackoverflow.com/a/246128
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -euo pipefail

DATADIR="$SCRIPTDIR/../data"

mkdir -p "$DATADIR"

GOOGLE_BASE_URL="https://storage.googleapis.com/bert_models"
UTU_BASE_URL="http://dl.turkunlp.org/finbert"

for url in "$GOOGLE_BASE_URL/2018_10_18/cased_L-12_H-768_A-12.zip" \
	   "$GOOGLE_BASE_URL/2018_10_18/uncased_L-12_H-768_A-12.zip" \
	   "$GOOGLE_BASE_URL/2018_11_23/multi_cased_L-12_H-768_A-12.zip" \
	   "$GOOGLE_BASE_URL/2018_11_03/multilingual_L-12_H-768_A-12.zip" \
	   "$UTU_BASE_URL/bert-base-finnish-cased.zip" \
	   "$UTU_BASE_URL/bert-base-finnish-uncased.zip"; do
    b=$(basename "$url" .zip)
    if [ -e "$DATADIR/$b/vocab.txt" ]; then
	echo "$b/vocab.txt exists, skipping ..." >&2
    else
	wget "$url" -O "$DATADIR/$b.zip"
	unzip "$DATADIR/$b.zip" -d "$DATADIR"
	rm "$DATADIR/$b.zip"
	find "$DATADIR/$b" -type f | egrep -v 'vocab.txt$' | xargs rm
    fi
done

GOOGLE_LICENSE="https://raw.githubusercontent.com/google-research/bert/master/LICENSE"

for b in "cased_L-12_H-768_A-12" "uncased_L-12_H-768_A-12" \
         "multi_cased_L-12_H-768_A-12" "multilingual_L-12_H-768_A-12"; do
    wget "$GOOGLE_LICENSE" -O "$DATADIR/$b/LICENSE"
done
