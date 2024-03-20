#!/usr/bin/python
# -*- coding: utf-8 -*-

#  create lexicon
#  
#
#  Created by Eleanor Chodroff
# python3 ../scripts/get_phones.py ucla_lexicon_final.txt phones_ucla.txt

import sys, codecs, re

file = sys.argv[1]
outfile = sys.argv[2]

new_dict = codecs.open(outfile, 'w', "utf-8")

phons = []

f = codecs.open(file, 'r', "utf-8")
for line in f:
    col = line.split('\t')
    segs = col[1]
    segs = re.sub('\n', '', segs)
    elements = segs.split(' ')
    
    phons.extend(elements)
    uniquePhons = set(phons)
    uniquePhons = list(uniquePhons)
    uniquePhons = sorted(uniquePhons)

uniquePhons = ' '.join(uniquePhons)
new_dict.write(uniquePhons)
    
