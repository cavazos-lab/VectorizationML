reset
# set term unknown

# set title graphTitle

# fontsize = 12
# set xtics rotate by -90
# set xlabel "Benchmarks" font "Helvetica"
# set ylabel "Speedup (%)" font "Helvetica"

# set datafile separator ","
# set style line 1 lt 1 lc rgb "blue"
# set style line 2 lt 1 lc rgb "red"
# set style fill solid

# plot filename u (column(0)):2:(0.75):($3>0?2:1):xtic(1) w boxes lc variable notitle

# xspan = GPVAL_DATA_X_MAX - GPVAL_DATA_X_MIN
# yspan = GPVAL_DATA_Y_MAX - GPVAL_DATA_Y_MIN

# ar = 4/xspan

# ydim = 4
# xdim = 4/ar
# set xrange [GPVAL_DATA_X_MIN:GPVAL_DATA_X_MAX]
# set yrange [GPVAL_DATA_Y_MIN:GPVAL_DATA_Y_MAX]

# set size ratio ar
# set size xdim,ydim



set term post eps

set output graphOutput


set title graphTitle

fontsize = 12
set xtics rotate by -90
set xlabel "Benchmarks" font "Helvetica"
set ylabel "Speedup (%)" font "Helvetica"

set datafile separator ","
set style line 1 lt 1 lc rgb "blue"
set style line 2 lt 1 lc rgb "red"
set style fill solid

plot filename u (column(0)):2:(0.75):($3>0?2:1):xtic(1) w boxes lc variable notitle
