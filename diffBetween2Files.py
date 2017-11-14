#!/usr/bin/python

import sys
from itertools import izip

threshold = float(sys.argv[1])
fileA_name = sys.argv[2]
fileB_name = sys.argv[3]

fileA = open(fileA_name)
fileB = open(fileB_name)


i = 0
for lineA, lineB in izip(fileA, fileB):
    i = i + 1

    lineA_split = lineA.split( )
    lineB_split = lineB.split( )

	

    diff0 = (float(lineA_split[0]) - float(lineB_split[0])) / float(lineA_split[0])
    diff1 = (float(lineA_split[1]) - float(lineB_split[1])) / float(lineA_split[1])
    
    if diff0 > threshold or diff1 > threshold:
        print ('Files[{0},{1}], Threshold[{2:8f}], Line[{3:2d}] --> col[0]={4:8f} col[1]={5:8f}'.format(fileA_name, fileB_name, threshold, i, diff0, diff1))