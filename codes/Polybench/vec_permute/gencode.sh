./runme.sh -g gesummv 2
./runme.sh -g trisolv 2
./runme.sh -g trmm 3
./runme.sh -g gemm 3
./runme.sh -g seidel-2d 3
./runme.sh -g floyd-warshall 3
./runme.sh -g bicg 1 2
./runme.sh -g jacobi-1d-imper 2 1
./runme.sh -g fdtd-apml 3 1
./runme.sh -g lu-bench 2 2
./runme.sh -g mvt 2 2
./runme.sh -g doitgen 4 1
./runme.sh -g syr2k 2 3
./runme.sh -g syrk 2 3
./runme.sh -g 2mm 3 3
./runme.sh -g dynprog 3 3
./runme.sh -g atax 1 2 1
./runme.sh -g cholesky 1 1 2
./runme.sh -g durbin 2 1 1
./runme.sh -g jacobi-2d-imper 1 2 2
./runme.sh -g gramschmidt 2 2 1 
./runme.sh -g gemver 2 2 2 
./runme.sh -g covariance 2 2 3
./runme.sh -g fdtd-2d 3 2 2
./runme.sh -g 3mm 3 3 3
./runme.sh -g ludcmp 5 2 2 
./runme.sh -g reg_detect 4 3 2

list="gesummv trisolv trmm gemm seidel-2d floyd-warshall bicg jacobi-1d-imper fdtd-apml lu-bench mvt doitgen syr2k syrk 2mm dynprog atax cholesky durbin jacobi-2d-imper gramschmidt gemver covariance fdtd-2d 3mm ludcmp reg_detect"

for i in "$list"
do
    ./runme.sh -c $i
done

for i in "$list"
do
    ./runme.sh -rovi $i
done

./runme.sh -gcrovi correlation 2 2 2 3 
./runme.sh -gcrovi adi 3 1 2 2 2 
