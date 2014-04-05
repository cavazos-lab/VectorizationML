#!/usr/bin/env bash

OLDPATH=$PATH
PATH=$PATH:/Users/wkillian/Research/Repositories/VectorizationML/scripts/autovec/bin
export PATH

GENDIR=gen
EXECDIR=exec
CSVDIR=csv
LOGDIR=logs
OUTDIR=res
IMGDIR=img
TIMEDIR=timing

COMP=icc
COMPFLAGS=-"std=c99 -O3 -xHOST -vec-report6 -Icommon/"

function generate {
    for src in $1*.c
    do
	dir=$GENDIR/$(basename $src .c)
	mkdir -p $dir
	cp $src $dir
	pushd $dir > /dev/null
	echo "[c] $src variants"
	auto_vec $src
	rm $src
	popd > /dev/null
    done
}

function compile {
    $COMP $COMPFLAGS common/dummy.c -c -o $EXECDIR/dummy.o
    for file in $(find $GENDIR -name "*$1*.c")
    do
	obj=$(echo $file | sed "s/$GENDIR/$EXECDIR/;s/c$/o/;s/\.c_/_/")
	log=$(echo $obj | sed "s/$EXECDIR/$LOGDIR/;s/o$/log/")
	dir=$(dirname $obj)
	logdir=$(dirname $log)
	mkdir -p $dir
	mkdir -p $logdir
	echo "$file -> $obj"
	($COMP $COMPFLAGS -c $file -o $obj 2>&1) > $log
    done
}

function link {
    for obj in $(find $EXECDIR -name "*$1*.o")
    do
	echo "$obj -> $exe"
	bin=$(echo $obj | sed 's/o$/exe/')
	$COMP $COMPFLAGS $obj $EXECDIR/dummy.o -o $bin
    done
}

function run {
    mkdir -p $TIMEDIR
    for dir in $(find exec -executable -type d -name "*$1*")
    do
	outfile=$TIMEDIR/$(basename $dir).log
	rm -f $outfile
	for exe in $(find $dir -executable -not -type d)
	do
	    tmpfile=$(mktemp)
	    echo "./$exe"
	    echo "$exe" > $tmpfile
	    ./$exe >> $tmpfile
	    cat $tmpfile >> $outfile
	    rm $tmpfile
	done
    done
}

function output {
    mkdir -p $OUTDIR
    for i in $1*.c
    do
	benchmark=$(echo $i | sed 's/\.c//')
	echo "[c] $OUTDIR/$benchmark.out"
	./parseimpl.sh < $TIMEDIR/$benchmark.log > $OUTDIR/$benchmark.out
    done
}

function csv {
    mkdir -p $CSVDIR
    for out in $OUTDIR/*$1*.out
    do
	line=$(< $out grep -e "^N\(_N\)*,")
	def_time=$(echo "$line" | cut -d, -f2)
	def_checksum=$(echo "$line" | cut -d, -f3)
	
	outfile=$(echo "$out" | sed "s/$OUTDIR/$CSVDIR/;s/out$/csv/")
	echo "$out -> $outfile"
	
	(for line in $(cat $out)
        do
	    bench=$(echo "$line" | cut -d, -f1)
	    time=$(echo "$line" | cut -d, -f2)
	    checksum=$(echo "$line" | cut -d, -f3)
	    
	    if [[ -z "$time" || "$time" = "0" ]]
	    then
		speedup=0
	    else
		speedup=$(echo "$def_time / $time" | bc -l)
	    fi
	    
	    if [[ "$def_checksum" = "$checksum" ]]
	    then
		echo "$bench,$speedup,1"
	    else
		echo "$bench,$speedup,0"
	    fi
	done) | sort -k3 -t, -s -r > $outfile
    done
}

function img {
    mkdir -p $IMGDIR
    for file in $CSVDIR/$1*.csv
    do
	echo "$file"
	title=$(basename $file .csv)
	size=$(echo "$(< $file wc -l)/5 + 1" | bc)
	out=$IMGDIR/$title.eps
        echo "$file -> $out"
	gnuplot -e "filename='$file';graphTitle='$title';graphOutput='$out';graphWidth='$size'" generate.gnuplot
    done
}

function summary {
    file=summary.csv
    (for f in $CSVDIR/$1*.csv
    do
	echo "$(echo $f | sed 's/csv\///;s/.csv$//'),$(head -n 1 $f | cut -d, -f2-3)"
    done) > $file
    out=summary.eps
    title="Summary"
    size=$(echo "$(< $file wc -l)/10 + 1" | bc)
    gnuplot -e "filename='$file';graphTitle='$title';graphOutput='$out';graphWidth='$size'" generate.gnuplot
    GS_OPTIONS=-dAutoRotatePages=/None epstopdf $out
    echo "Generated $file, $out, and summary.pdf"
}

function pdf {
    for f in $IMGDIR/$1*.eps
    do
	echo "Parsing $f -> PDF"
	GS_OPTIONS=-dAutoRotatePages=/None epstopdf $f
    done
    pdfs=$(ls $IMGDIR/*.pdf)
    echo -n "Merging Files ..."
    gs -dAutoRotatePages=/None -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=speedups.pdf $pdfs
    echo " Done!"
    echo "Generated 'speedups.pdf'"
    rm -f $pdfs
}

function show_help {
    echo "Options:"
    echo " -a -- do everything"
    echo " -g -- generate"
    echo " -c -- compile"
    echo " -r -- run"
    echo " -o -- generate output files"
    echo " -v -- csv"
    echo " -i -- image (speedup graph)"
    echo " -p -- generate pdf"
    echo " -s -- generate summary speedup csv and graph"
    echo ""
    echo "final (optional) argument is a wildcard for matching"
    echo ""
}

GEN=0
COM=0
RUN=0
OUT=0
CSV=0
IMG=0
PDF=0
SUM=0
HELP=0
args=$(getopt "agcrovisp" "$@")
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
	    IMG=1
	    SUM=1
	    PDF=1
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
	-i)
	    IMG=1
	    ;;
	-s)
	    SUM=1
	    ;;
	-p)
	    PDF=1
	    ;;
	-h)
	    HELP=1
	    ;;
    esac
    shift
done

if [[ $GEN -ne 0 ]]; then
    generate $1
fi

if [[ $COM -ne 0 ]]; then
    compile $1
    link $1
fi

if [[ $RUN -ne 0 ]]; then
    run $1
fi

if [[ $OUT -ne 0 ]]; then
    output $1
fi

if [[ $CSV -ne 0 ]]; then
    csv $1
fi

if [[ $IMG -ne 0 ]]; then
    img $1
fi

if [[ $PDF -ne 0 ]]; then
    pdf $1
fi

if [[ $SUM -ne 0 ]]; then
    summary $1
fi

if [[ $GEN -eq 0 && $PDF -eq 0 && $IMG -eq 0 && $COM -eq 0 && $RUN -eq 0 && $OUT -eq 0  && $CSV -eq 0  && $SUM -eq 0 || $HELP -ne 0 ]]; then
    show_help
fi


PATH=$OLDPATH
export PATH
