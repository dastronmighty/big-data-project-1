#!/bin/bash

echo "splitting data using ${1}"

data_len=$(cat $1 | cut -d, -f1 | wc -l)
data_len=$(( $data_len ))
data_array=( $(cat $1 | cut -d, -f1 ) )
data_idx_arr=()

for ((i=0;i<$data_len;i++))
do 
    loc=$(cat $3 | head -n 1 | sed 's/'${data_array[$i]}'/@@@/' | sed 's/@@@.*/ /g' | grep -o , | wc -l)
    loc=$(( $loc + 1))
    data_idx_arr+=($loc)
done

touch $2

data_header_array=( $(cat $1 | cut -d, -f2 ) )
header=""
for ((i=0;i<$data_len;i++))
do
    header="${header},${data_header_array[$i]}"
done
header=$(echo $header | sed 's/,//')
echo $header >> $2

cat $3 | tail -n +2 > tmp.csv

while IFS= read -r line; 
do
    line_data=""
    for ((i=0;i<$data_len;i++))
    do 
        part=$(echo $line | cut -d, -f"${data_idx_arr[i]}" )
        if [[ $part == "" ]]
        then
            part="None"
        fi
        part=$(echo $part | sed 's/"//g')
        line_data="${line_data},${part}"
    done
    line_data=$(echo $line_data | sed 's/,//')
    echo $line_data >> $2
done < "tmp.csv"

rm tmp.csv

echo "finished splitting data using ${1}"