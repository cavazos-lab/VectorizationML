reset

set terminal postscript eps size graphWidth,6

set output graphOutput

set title graphTitle

fontsize = 8
set xtics rotate by -90
set xlabel "Benchmarks" font "Helvetica"
set ylabel "Speedup Over Default" font "Helvetica"
set logscale y

set datafile separator ","
set style line 1 lt 1 lc rgb "blue"
set style line 2 lt 1 lc rgb "red"
set style fill solid

plot filename u (column(0)):2:(0.75):($3>0?2:1):xtic(1) w boxes lc variable notitle, 1 title ""
