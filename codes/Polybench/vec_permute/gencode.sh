#./runme.sh -g trmm
#./runme.sh -g floyd-warshall
#./runme.sh -g durbin
#./runme.sh -g atax
#./runme.sh -g bicg
#./runme.sh -g gemm
#./runme.sh -g gesummv
#./runme.sh -g jacobi-1d-imper
#./runme.sh -g lu
#./runme.sh -g seidel-2d
#./runme.sh -g trisolv
#./runme.sh -g fdtd-apml 3 1
#./runme.sh -g mvt 2 2
#./runme.sh -g syr2k 2 3
#./runme.sh -g syrk 2 3
#./runme.sh -g 2mm 3 3
#./runme.sh -g dynprog 3 3
#./runme.sh -g doitgen 4 1
#./runme.sh -g cholesky 1 1 2
#./runme.sh -g jacobi-2d-imper 1 2 2
#./runme.sh -g covariance 2 2 3

./runme.sh -rovi trmm 
./runme.sh -rovi floyd-warshall 
./runme.sh -rovi durbin
./runme.sh -rovi atax
./runme.sh -crovi bicg
./runme.sh -crovi gemm 
./runme.sh -crovi gesummv 
./runme.sh -crovi jacobi-1d-imper 
./runme.sh -crovi lu
./runme.sh -crovi seidel-2d
./runme.sh -crovi trisolv
./runme.sh -crovi fdtd-apml 
./runme.sh -crovi mvt 
./runme.sh -crovi syr2k 
./runme.sh -crovi syrk
./runme.sh -crovi 2mm
./runme.sh -crovi dynprog
./runme.sh -crovi doitgen 
./runme.sh -crovi cholesky 
./runme.sh -crovi jacobi-2d-imper 
./runme.sh -crovi covariance

./runme.sh -gcrovi 3mm 3 3 3
./runme.sh -gcrovi gemver 2 2 2 2 
./runme.sh -gcrovi gramschmidt 2 1 2 1 
./runme.sh -gcrovi ludcmp 3 2 2 2 
./runme.sh -gcrovi correlation 2 2 2 3 
./runme.sh -gcrovi fdtd-2d 1 1 2 2 2
./runme.sh -gcrovi reg_detect 1 3 3 1 2
./runme.sh -gcrovi adi 1 2 1 2 2 1 2 
