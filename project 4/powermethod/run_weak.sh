#!/bin/bash

fname="weak"
lscpu | grep "Model name" | tee weak$fname.data
echo -e "size\tp\ttime" | tee -a weak$fname.data

niters=100
n=(9600 19200 27152 33252 38400 54304 76800)
p=(1 4 8 12 16 32 64)
len=${#p[*]}

i=0
while [ $i -le $len ]
do
    mpirun -np ${p[$i]} ./powermethod ${n[$i]} $niters | tee -a weak$fname.data
    ((i+=1))
done
