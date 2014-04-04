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
    for obj in $(find $EXECDIR -name "*$1.o")
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

function output() {
    mkdir -p res
    pattern="Time(Sec)"
    args="$@"
    for i in $(ls $1.c)
    do
	benchmark=$(echo $i | sed 's/\.c//')
	./parseimpl.sh < exec/$benchmark/run.log > res/$benchmark.out
    done
    set -- "$args"
}

function csv() {
    mkdir -p csv
    for out in res/*$1.out
    do
	line=$(< $out grep -e "^N\(_N\)*,")
	def_time=$(echo "$line" | cut -d, -f2)
	def_checksum=$(echo "$line" | cut -d, -f3)
	
	outfile=$(echo "$out" | sed "s/res/csv/;s/out$/csv/")
	echo "Writing $out -> $outfile"
	
	(for line in $(cat $out)
        do
	    bench=$(echo "$line" | cut -d, -f1)
	    time=$(echo "$line" | cut -d, -f2)
	    checksum=$(echo "$line" | cut -d, -f3)
	    
	    speedup=$(echo "$def_time / $time" | bc -l)
	    
	    if [[ "$def_checksum" = "$checksum" ]]
	    then
		echo "$bench,$speedup,1"
	    else
		echo "$bench,$speedup,0"
	    fi
	done) | sort -k3 -t, -s -r > $outfile
    done
}

function show_help {
    echo "Options:"
    echo " -a -- do everything"
    echo " -g -- generate"
    echo " -c -- compile"
    echo " -r -- run"
    echo " -o -- generate output files"
    echo " -v -- csv"
    echo ""
    echo "final (optional) argument is a wildcard for matching"
    echo ""
}

GEN=0
COM=0
RUN=0
OUT=0
CSV=0
HELP=0
args=$(getopt "agcrov" "$@")
eval set -- "$args"
while [ $# -ge 1 ]; do
    case "$1" in
	--)
	    shift
	    break
	    ;;
	-a)
	    GEN=1
	    COM=1
	    RUN=1
	    OUT=1
	    CSV=1
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
	-o)
	    OUT=1
	    ;;
	-v)
	    CSV=1
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

if [[ $OUT -ne 0 ]]
then
    output $1
fi

if [[ $CSV -ne 0 ]]
then
    csv $1
fi

if [[ $GEN -eq 0 && $COM -eq 0 && $RUN -eq 0 && $OUT -eq 0  && $CSV -eq 0 || $HELP -ne 0 ]]
then
    show_help
fi

