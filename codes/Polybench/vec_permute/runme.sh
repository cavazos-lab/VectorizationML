#!/usr/bin/env bash

OLDPATH=$PATH
PATH=$PATH:$PWD/../../../scripts/autovec/bin
export PATH

GENDIR=gen
EXECDIR=exec
CSVDIR=csv
LOGDIR=logs
OUTDIR=res
IMGDIR=img
TIMEDIR=timing

COMP=icc
COMPFLAGS="-std=c99 -O3 -xHOST -vec-report6 -Iinc -DPOLYBENCH_TIME -DPOLYBENCH_CYCLE_ACCURATE_TIMER"

function generate {
    patt=$1
    shift
    for src in $patt*.c
    do
	dir=$GENDIR/$(basename $src .c)
	mkdir -p $dir
	cp $src $dir
	pushd $dir > /dev/null
	echo "[c] $src variants"
	vec_permute $src $@
	rm $src
	popd > /dev/null
    done
}

function compile {
    mkdir -p $EXECDIR
    ($COMP $COMPFLAGS common/polybench.c -c -o $EXECDIR/polybench.o 2>&1) > /dev/null
    for file in $(find $GENDIR -name "*$1*.c")
    do
	obj=$(echo $file | sed "s/$GENDIR/$EXECDIR/;s/c$/o/;s/\.c_/_/")
	log=$(echo $obj | sed "s/$EXECDIR/$LOGDIR/;s/o$/log/")
	dir=$(dirname $obj)
	logdir=$(dirname $log)
	mkdir -p $dir
	mkdir -p $logdir
	echo "$file -> $obj (logging to $log)"
	($COMP $COMPFLAGS -c $file -o $obj 2>&1) > $log
    done
}

function link {
    for obj in $(find $EXECDIR -name "*$1*.o")
    do
	bin=$(echo $obj | sed 's/o$/exe/')
	echo "$obj -> $bin"
	$COMP $COMPFLAGS $obj $EXECDIR/polybench.o -o $bin
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
	    bench=$(basename $exe .exe)
	    bench=$(echo $bench | sed 's/^[^_]\{1,\}_//')
	    #echo -n "$bench," > $tmpfile
	    echo "$bench,$(./$exe 2> /dev/null)" > $tmpfile
	    cat $tmpfile >> $outfile
	    rm $tmpfile
	done
    done
}

function output {
    mkdir -p $OUTDIR
    args="$@"
    pattern="Time(Sec)"
    for i in $TIMEDIR/$1*.log
    do
	benchmark=$(basename $i .log)
	echo "[c] $OUTDIR/$benchmark.out"
	sort -n -k2 -t, $TIMEDIR/$benchmark.log > $OUTDIR/$benchmark.out
    done
    set -- "$args"
}

function csv {
    mkdir -p $CSVDIR
    for out in $OUTDIR/$1*.out
    do
	line=$(< $out grep -e '^N\(_N\)\{1,\},')
	def_time=$(echo "$line" | cut -d, -f2)
	
	outfile=$(echo "$out" | sed "s/$OUTDIR/$CSVDIR/;s/out$/csv/")
	echo "$out -> $outfile"
	(
	    for line in $(cat $out)
            do
		time=$(echo "$line" | cut -d, -f2)
		time=$(echo $time | bc -l)
		if [[ -z "$time" || "$time" = "0" ]]
		then
		    speedup=0
		else
		    speedup=$(echo "$def_time / $time" | bc -l)
		fi
		echo $line | sed "s/$time/$speedup,1/"
	    done
	) | sort -n -k3 -t, -s -r > $outfile
    done
}

function img {
    mkdir -p $IMGDIR
    for file in $CSVDIR/$1*.csv
    do
	title=$(basename $file .csv)
	count=$(< $file wc -l)
	#size=$(echo "($count)/8 + 2*l($count)" | bc -l)
	wsize=$(echo "$count/40 + 0.5" | bc -l)
	hsize=1
	out=$IMGDIR/$title.eps
        echo "$file -> $out ($wsize x $hsize)"
	gnuplot -e "filename='$file';graphTitle='$title';graphOutput='$out';graphWidth='$wsize';graphHeight='$hsize'" generate.gnuplot
    done
}

function summary {
    file=summary.csv
    form="1"
    count=0
    (
	for f in $CSVDIR/$1*.csv
	do
	    echo "$(echo $f | sed 's/csv\///;s/.csv$//'),$(head -n 1 $f | cut -d, -f2-3)"
	done
    ) > $file
    count=$(< $file wc -l)

    #tmp=$(mktemp)
    #sort -n -s -r -t, -k2 $file > $tmp
    #mv $tmp $file
    
    form=$(cut -d, -f2 $file | paste -sd '+')
    echo "A-MEAN,$(echo "($form)/$count" | bc -l),0" >> $file

    form=$(echo "$form" | sed 's/+/*/g')
    echo "G-MEAN,$(echo "e(l($form)/$count)" | bc -l),0" >> $file

    form=$(echo "$form" | sed 's/*/+/g;s/\([0-9]\{1,\}\(\.[0-9]*\)\)/1\/(\1\)/g')
    echo "H-MEAN,$(echo "$count/($form)" | bc -l),0" >> $file

    out=summary.eps
    title="Summary"
    size=$(echo "$(< $file wc -l)/20" | bc)
    gnuplot -e "filename='$file';graphTitle='$title';graphOutput='$out';graphWidth='$size';graphHeight='1'" generate.gnuplot
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
    generate $@
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
