#!/bin/sh

LIBS="lib/rrr.c lib/bit_vector.c"

case "$1" in
    a) X=test-access ;;
    s) X=test-select ;;
    r) X=test-rank   ;;
    b) X=test-builder;;
    p) X=test-print  ;;
    *) echo "what."; exit 1 ;;
esac

rm -rf tmp
mkdir tmp
cp -R lib test/$X.c tmp
cd tmp
gcc -g -Ilib $X.c $LIBS -o $X

case "$2" in
    lldb) lldb $X ;;
    exec) ./$X ;;
    "") exit ;;
    *) echo "huh." ;;
esac
