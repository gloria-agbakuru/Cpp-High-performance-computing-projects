#!/bin/bash

fname="strong"
lscpu | grep "Model name" | tee strong$fname.ps
echo -e "size\tp\ttime" | tee -a strong$fname.ps

n=9600
niters=1000

for p in 1 4 8 12 16 32 64
do
    mpirun -np $p ./powermethod $n $niters | tee -a strong$fname.ps
done


