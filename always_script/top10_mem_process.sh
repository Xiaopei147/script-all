#!/bin/bash
date=`date +%m-%d-%H:%M`
echo $date
ps -eo pid,ppid,%mem,%cpu,comm --sort=-%mem | head -15
echo "---------------------------------------------"

