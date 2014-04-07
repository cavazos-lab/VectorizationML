# short runs
while read line
do
    ./runme.sh -gcrovi $line
done <<EOF
gesummv 2
trisolv 2
trmm 3
gemm 3
symm 3
floyd-warshall 3
seidel-2d 4
bicg 1 2
jacobi-1d-imper 2 1
fdtd-apml 3 1
lu-bench 2 2
mvt 2 2
doitgen 4 1
syr2k 2 3
syrk 2 3
2mm 3 3
dynprog 3 3
EOF

# medium runs
while read line
do
     ./runme.sh -gcrovi $line
done <<EOF
atax 1 2 1
cholesky 1 1 2
durbin 2 1 1
jacobi-2d-imper 1 2 2
gramschmidt 2 2 1
gemver 2 2 2
covariance 2 2 3
fdtd-2d 3 2 2
3mm 3 3 3
ludcmp 5 2 2
reg_detect 4 3 2
EOF

# long runs
while read line
do
     ./runme.sh -gcrovi $line
done <<EOF
correlation 2 2 2 3
adi 3 2 2 2  
EOF

