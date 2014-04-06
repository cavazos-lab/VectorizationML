
file=$(mktemp)
cat <<EOF > $file
gesummv 2
trisolv 2
trmm 3
gemm 3
seidel-2d 4
floyd-warshall 3
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

# for i in $(cat $file)
# do
#     ./runme.sh -g $i
# done

for i in $(cat $file)
do
    ./runme.sh -c $i
done

for i in $(cat $file)
do
    ./runme.sh -rovi $i
done

rm $file

# long runs :c
./runme.sh -gcrovi correlation 2 2 2 3 
./runme.sh -gcrovi adi 3 1 2 2 2 
