#!/bin/bash

#./execWithCompiler.sh WORK_DIR F77_COMPILER FC_COMPILER CXX_COMPILER

cd $1
./bootstrap

export F77=$2
export FC=$3
export CXX=$4
./configure "F77=$2" "FC=$3" "CXX=$4"

make check

make clean
make distclean

cd ../..

