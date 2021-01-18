#!/bin/sh

LIBS="stupidedi/lib/*.c"
INCS="-I."

case "$1" in
  test-huffman)           X=test-huffman ;;
  test-ringbuf-queue*)    X=test-ringbuf-queue ;;
  test-ringbuf-resize*)   X=test-ringbuf-resize ;;
  test-rrr-access*)       X=test-rrr-access ;;
  test-rrr-select*)       X=test-rrr-select ;;
  test-rrr-rank*)         X=test-rrr-rank   ;;
  test-rrr-builder*)      X=test-rrr-builder;;
  test-rrr-print*)        X=test-rrr-print  ;;
  test-wavelet-access*)   X=test-wavelet-access ;;
  test-wavelet-select*)   X=test-wavelet-select ;;
  test-wavelet-rank*)     X=test-wavelet-rank ;;
  test-wavelet-print*)    X=test-wavelet-print ;;
  *) echo "what."; exit 1 ;;
esac
shift

ME=$(dirname $0)

rm   -rf ${ME}/tmp
mkdir -p ${ME}/tmp/stupidedi/{bindings,include,lib,test}
cp    -R ${ME}/../{bindings,include,lib} ${ME}/tmp/stupidedi
cp       ${ME}/${X}.c ${ME}/tmp

export PATH_SEPARATOR=:
export VPATH="stupidedi:stupidedi/lib"

cd ${ME}/tmp
gcc -g -o $X $INCS $X.c $LIBS

case "$1" in
  lldb)   shift; lldb $X $@   ;;
  exec)   shift; ./$X $@      ;;
  "")     exit                ;;
  *)      echo "huh."         ;;
esac
