#!/bin/bash

sed -n 1,10001p googleplaystore.csv > googleplaystore.100000.csv

for i in {1..9}
do
   sed -n 2,10001p googleplaystore.csv >> googleplaystore.100000.csv
done

