#!/usr/bin/env bash
echo "Generating"
for i in *.c
do
  dir=gen/$(basename $i .c)
  mkdir -p $dir
  cp $i $dir
  cd $dir
  echo "> $i"
  auto_vec $i
  rm $i
  cd ../..
done

echo "Compiling"
icc -std=c99 -O3 -xHOST common/dummy.c -c -o gen/dummy.o
for i in $(find ./gen -name "*.c")
do
  o=$(echo $i | sed 's/gen/exe/;s/c$/o/;s/\.c_/_/')
  log=$(echo $o | sed 's/o$/log/')
  dir=$(dirname $o)
  mkdir -p $dir
  echo "icc -std=c99 -O3 -xHOST -Icommon/ -c $i -o $o -vecreport6"
  icc -std=c99 -O3 -xHOST -Icommon/ -c $i -o $o -vec-report6 > $log
done

for o in $(find ./exe -name "*.o")
do
  echo "Linking $o"
  icc -std=c99 -O3 -xHOST $o common/dummy.o -o $(echo $o | sed 's/.o$/exe/')
  rm $o
done

echo "Running"
for o in $(find ./exe -name "*.exe")
do
  dir=$(dirname $o)
  outfile=$dir/run.log
  $o >> outfile
done
