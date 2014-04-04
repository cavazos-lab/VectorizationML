#!/usr/bin/env bash

GENDIR=gen
LOGDIR=log
EXECDIR=exec

echo "Generating"
for src in *.c
do
  dir=$GENDIR/$(basename $src .c)
  mkdir -p $dir
  cp $src $dir
  cd $dir
  echo "> $src"
  auto_vec $src
  rm $src
  cd ../..
done

echo "Compiling"
icc -std=c99 -O3 -xHOST common/dummy.c -c -o $GENDIR/dummy.o
for file in $(find $GENDIR -name "*.c")
do
  obj=$(echo $file | sed "s/$GENDIR/$EXECDIR/;s/c$/o/;s/\.c_/_/")
  log=$(echo $obj | sed "s/o$/log/")
  dir=$(dirname $obj)
  mkdir -p $dir
  echo "icc -std=c99 -O3 -xHOST -Icommon/ -c $file -o $obj -vecreport6"
  (icc -std=c99 -O3 -xHOST -Icommon/ -c $file -o $obj -vec-report6 2>&1) > $log
done

for obj in $(find exec -name "*.o")
do
  echo "Linking $obj"
  bin=$(echo $obj | sed 's/o$/exe/')
  icc -std=c99 -O3 -xHOST $obj common/dummy.o -o $bin
done

echo "Running"
for exe in $(find exec -executable -not -type d)
do
  dir=$(dirname $exe)
  outfile=$dir/run.log
  echo "$exe"
  ./$exe >> $outfile
done
