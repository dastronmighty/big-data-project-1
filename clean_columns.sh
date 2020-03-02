#!/bin/bash

num_items=$(cat $1 | head -n 1 | grep -o , | wc -w)
num_items=$((num_items + 4))
echo "Searching all $num_items columns for redundancy"

cols=()
pstr="[=======================================================================]"
max=$((num_items - 1))

command="-f"
for ((i = 1; i < $num_items; i++))
do
    num_vals=$(cat $1 | cut -d, -f$i | sort -u | wc -w)
    x=$(($num_vals+0))
    if [ $x -lt 3 ]
    then
        cols+=("$i")
    fi
    bit="$i-$i,"
    command="${command}${bit}"
    pd=$(( $i * 73 / $max ))
    printf "\r%3d.%1d%% %.${pd}s" $(( $i * 100 / $max )) $(( ($i * 1000 / $max) % 10 )) $pstr
done
command="${command}$num_items-$num_items"
echo ""
for col in "${cols[@]}"; do
    sed_reg="s/$col-$col,//"
    command=$(echo "$command" | sed $sed_reg)
    echo "col $col has been removed"
done
 
command="cut -d, ${command} $1"

$command > $2

echo "Done Pruning redundant columns!"

