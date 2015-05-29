#!/bin/bash -

awk -F"\t" '{print $4}' numberOut |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' > pure_order.txt
./superTraining.pl pure_order.txt
