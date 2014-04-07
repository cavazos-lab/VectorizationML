reset

set terminal postscript eps linewidth 0.25 rounded size graphWidth,graphHeight "Helvetica,2.5"

set output graphOutput

set title graphTitle


set xtics rotate by -90
set xlabel "Benchmarks"
set ylabel "Speedup Over Default"
set logscale y

set datafile separator ","
set style line 1 lt 1 lc rgb "blue"
set style line 2 lt 1 lc rgb "red"
set style fill solid

plot filename u (column(0)):2:(0.75):($3>0?2:1):xtic(1) w boxes lc variable notitle, 1 title ""
