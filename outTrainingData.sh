#!/bin/bash - 





awk 'NR%4==1||NR%4==3{print}' $1 >>increaseNumber
awk 'NR%4==1||NR%4==0{print}' $1 >>orderNumber
