#!/bin/bash

data_in_path=$1
insert_command=$2

num_vars=$(cat $data_in_path | head -n 1 | grep , -o | wc -l)
num_vars=$(($num_vars + 1))

cat $data_in_path | tail -n +2 > tmp.csv

while IFS= read -r line; 
do
    line_data=""
    for ((i=1;i<=$num_vars;i++))
    do
        line_part=$(echo $line | cut -d, -f"${i}")
        line_data="${line_data},\"${line_part}\""
    done
    line_data=$(echo $line_data | sed 's/,//')
    line_data="${insert_command} (${line_data});"
    mysql -uroot -D "reddit" -e "${line_data}" >> log
done < "tmp.csv"

rm tmp.csv