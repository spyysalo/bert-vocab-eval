# BERT vocabulary evaluation

Tools for generating statistics for BERT vocabularies applied to
samples of text.

## Quickstart

Download BERT vocabularies

```
./scripts/getvocabs.sh
```

Download and sample Wikipedias (takes time, generates over 40G of data)

```
./scripts/getwikis.sh
```

Run evaluation

```
./scripts/runevals.sh
```
