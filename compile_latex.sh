#!/bin/sh
source=$1
infile=${source%.tex}
latex $infile
bibtex $infile
latex $infile
latex $infile
dvipdf $infile
