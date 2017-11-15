#!/usr/bin/python

import sys
from itertools import izip

threshold = float(sys.argv[1])
fileA_name = sys.argv[2]
fileB_name = sys.argv[3]

fileA = open(fileA_name)
fileB = open(fileB_name)

row_diff = 0

i = 0
for lineA, lineB in izip(fileA, fileB):
    i = i + 1

    lineA_split = lineA.split( )
    lineB_split = lineB.split( )

	

    diff0 = (float(lineA_split[0]) - float(lineB_split[0])) / float(lineA_split[0])
    diff1 = (float(lineA_split[1]) - float(lineB_split[1])) / float(lineA_split[1])
    
    if diff0 > threshold or diff1 > threshold:
        row_diff = row_diff + 1
        print ('Row[{0}] --> Files[{1},{2}], Threshold[{3:8f}], Line[{4:2d}] --> col[0]={5:8f} col[1]={6:8f}'.format(row_diff, fileA_name, fileB_name, threshold, i, diff0, diff1))