#!/bin/bash

# Download Wikipedia dumps, extract texts

# https://stackoverflow.com/a/246128
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -euo pipefail

DATADIR="$SCRIPTDIR/../data"

mkdir -p "$DATADIR"

WIKIEXDIR="$SCRIPTDIR/../wikiextractor"

# Clone WikiExtractor
if [ -e "$WIKIEXDIR" ]; then
    echo "$WIKIEXDIR exists, skipping clone ..." >&2
else
    git clone 'https://github.com/attardi/wikiextractor.git'
    
    mv "wikiextractor" "$WIKIEXDIR"
fi

BASE_URL="https://dumps.wikimedia.org"
	   
for url in "$BASE_URL/fiwiki/latest/fiwiki-latest-pages-articles.xml.bz2" \
	   "$BASE_URL/dewiki/latest/dewiki-latest-pages-articles.xml.bz2" \
           "$BASE_URL/enwiki/latest/enwiki-latest-pages-articles.xml.bz2"; do
    lang=$(echo "$url" | perl -pe 's/.*\/(..)wiki-.*/$1/')
    o="$DATADIR/${lang}-wiki"
    b=$(basename "$url" .zip)
    if [ -e "$DATADIR/$b" ]; then
	echo "$b exists, skipping ..." >&2
    else
	echo "Downloading $lang Wikipedia dump ..." >&2
	wget "$url" -O "$DATADIR/$b"
    fi
    if [ -e "$o" ]; then
	echo $o" exists, skipping ..." >&2
    else
	echo "Extracting $lang Wikipedia texts ..." >&2
	python3 "$WIKIEXDIR/WikiExtractor.py" -o "$o" "$DATADIR/$b"
    fi
    if [ -e "${o}-sample.txt" ]; then
	echo "${o}-sample.txt exists, skipping ..." >&2
    else
	echo "Sampling $lang Wikipedia texts ..." >&2
	find "$o" -name 'wiki_*' \
	    | xargs python3 "$SCRIPTDIR/samplewiki.py" 0.01 \
	    > "${o}-sample.txt"
    fi
done
