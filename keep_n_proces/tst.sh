#!/bin/bash
#num=$[RANDOM%100+1]
now=`ls |wc -l`

for ((i=$now;i<=4;i++))
do 
num=$[RANDOM%100+1]
   # touch file$num;sleep 2
    touch file$num
done
