#!/usr/bin/env bash

GENDIR=gen
EXECDIR=exec

COMP=icc
COMPFLAGS=-"std=c99 -O3 -xHOST -vec-report6 -Icommon/"

function generate {
    for src in $(ls $1.c)
    do
	dir=$GENDIR/$(basename $src .c)
	mkdir -p $dir
	cp $src $dir
	pushd $dir > /dev/null
	echo "Generating $src"
	auto_vec $src
	rm $src
	popd
    done
}

function compile() {
    $COMP $COMPFLAGS common/dummy.c -c -o $GENDIR/dummy.o
    for file in $(find $GENDIR -name "*$1.c")
    do
	obj=$(echo $file | sed "s/$GENDIR/$EXECDIR/;s/c$/o/;s/\.c_/_/")
	log=$(echo $obj | sed "s/o$/log/")
	dir=$(dirname $obj)
	mkdir -p $dir
	echo "Compiling $file"
	($COMP $COMPFLAGS -c $file -o $obj 2>&1) > $log
    done
}

function link() {
    for obj in $(find EXECDIR -name "*$1.o")
    do
	echo "Linking $obj"
	bin=$(echo $obj | sed 's/o$/exe/')
	$COMP $COMPFLAGS $obj common/dummy.o -o $bin
    done
}

function run() {
    for exe in $(find exec -executable -not -type d -name "*$1*exe")
    do
	dir=$(dirname $exe)
	tmpfile=$(mktemp)
	outfile=$dir/run.log
	echo "Running $exe"
	echo "$exe" > $tmpfile
	./$exe >> $tmpfile
	cat $tmpfile >> $outfile
	rm $tmpfile
    done
}

function show_help {
    echo "Options:"
    echo " -g -- generate"
    echo " -c -- compile"
    echo " -r -- run"
    echo ""
    echo "final (optional) argument is a wildcard for matching"
    echo ""
}

GEN=0
COM=0
RUN=0
HELP=0
args=$(getopt "gcr" "$@")
eval set -- "$args"
while [ $# -ge 1 ]; do
    case "$1" in
	--)
	    shift
	    break
	    ;;
	-g)
	    GEN=1
	    ;;
	-c)
	    COM=1
	    ;;
	-r)
	    RUN=1
	    ;;
	-h)
	    HELP=1
	    ;;
    esac
    shift
done

if [[ -z "$1" ]]
then
    eval set -- "*"
fi

if [[ $GEN -ne 0 ]]
then
    generate $1
fi

if [[ $COM -ne 0 ]]
then
    compile $1
    link $1
fi

if [[ $RUN -ne 0 ]]
then
    run $1
fi

if [[ $GEN -eq 0 && $COM -eq 0 && $RUN -eq 0 || $HELP -ne 0 ]]
then
    show_help
fi

