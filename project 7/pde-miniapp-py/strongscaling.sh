#!/bin/bash

fname="s_1node"
lscpu | grep "Model name" | tee $fname.data
echo -e "size\tnp\tNewton\tCG\ttime" | tee -a $fname.data

n=1024
while [ $n -le 1024 ]
do
  p=1
  while [ $p -le 32 ]
  do
    mpirun -np $p python3 main.py $n 100 0.005 | tee -a $fname.data
    ((p+=1))
  done
  ((n*=2))
done