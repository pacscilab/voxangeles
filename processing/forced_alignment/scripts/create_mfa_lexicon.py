#!/usr/bin/python
# -*- coding: utf-8 -*-

#  create lexicon 
#  
#
#  Created by Eleanor Chodroff
# python3 create_mfa_lexicon.py ucla_lexicon ucla_lexicon_tmp.txt

# to get language-specific lexicons
# for lang in [a-z]*/; do python3 ../scripts/create_mfa_lexicon.py "$lang"text.txt "${lang/\//}"_lexicon.txt; done
# python3 ../scripts/create_mfa_lexicon.py abk/final.txt abk_lexicon.txt

import sys, codecs, re

file = sys.argv[1]
outfile = sys.argv[2]

new_dict = codecs.open(outfile, 'w', "utf-8")

f = codecs.open(file, 'r', "utf-8")
for line in f:
    col = line.split(' ')
    elements = len(col)
    segs = col[1:elements]
    identifier = ' '.join(segs)
    identifier = re.sub('\n', '', identifier)
    identifier = identifier.replace(' ', '')
    phon = ' '.join(segs)
    phon = re.sub('\n', '', phon)
    new_dict.write(identifier + '\t' + phon + '\n')
