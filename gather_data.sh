#!/bin/bash


#ad in ID column
sed -i '' -E 's/,/id,/' data.csv >> log

echo "Removing commas"
awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", ";", $i) } 1' data.csv > new_data.csv
rm data.csv
mv new_data.csv data.csv

# remove first column
echo "Removing First Row"
cut -d, -f2- data.csv > new_data.csv
rm data.csv
mv new_data.csv data.csv

# clean columns with no values
echo "Cleaning columns"
./clean_columns.sh data.csv new_data.csv
rm data.csv
mv new_data.csv data.csv

cat data.csv | head -n 1 > head_data.csv
cat data.csv | tail -n +2 > just_data.csv
rm data.csv

echo "converting created_utc"
utc_loc=$(cat head_data.csv | head -n 1 | sed 's/created_utc/@@@/' | sed 's/@@@.*/ /g' | grep -o , | wc -l)
utc_loc=$(( $utc_loc + 1 ))
gawk_comm='BEGIN {OFS=FS} {$'$utc_loc'=strftime("%a",$'$utc_loc')} 1'
gawk -F, "${gawk_comm}" just_data.csv > new_data.csv
rm just_data.csv
mv new_data.csv just_data.csv


echo "converting retrieved_on"
ret_loc=$(cat head_data.csv | head -n 1 | sed 's/retrieved_on/@@@/' | sed 's/@@@.*/ /g' | grep -o , | wc -l)
ret_loc=$(( $ret_loc + 1 ))
gawk_comm='BEGIN {OFS=FS} {$'$ret_loc'=strftime("%a",$'$ret_loc')} 1'
gawk -F, "${gawk_comm}" just_data.csv > new_data.csv
rm just_data.csv
mv new_data.csv just_data.csv

title_loc=$(cat head_data.csv | head -n 1 | sed 's/title/@@@/' | sed 's/@@@.*/ /g' | grep -o , | wc -l)
title_loc=$(( $title_loc + 1 ))

echo "Removing punctuation: "
while IFS= read -r line; 
do
    new_line=$(echo $line | cut -d, -f$title_loc)
    new_line=$(echo "$new_line" | tr '[:upper:]' '[:lower:]')
    new_line=$(echo "$new_line" | tr -d '[:punct:]' )
    echo "${new_line}" >> titles.txt
done < "just_data.csv"
printf "\bDone"
echo ""

while IFS= read -r line
do
    echo "Removing Stop Words: ${line}"
    sed_comm="s/ ${line} / /g"
    sed -i.bak "${sed_comm}" titles.txt
done < "dicts/stop_words.txt"
echo ""
echo "Done"

while IFS= read -r line;
do
    a=($line)
    sed_comm="s/ ${a[0]} / ${a[1]} /g"
    echo "Stemming words: ${a[0]}"
    sed -E -i.bak "$sed_comm" titles.txt
done < "dicts/stem_words.txt"
echo  "Done"
echo ""

cat head_data.csv > new_data.csv
printf "finishing up: "
i=1
j=1
sp="/-\|"
echo -n ' '

while IFS= read -r line; 
do
    bef=$(echo $line | cut -d, -f1-$(($title_loc - 1)))
    aft=$(echo $line | cut -d, -f$(($title_loc + 1))- )
    new_title=$(cat titles.txt | tail -n "+${j}" | head -n 1)
    echo "${bef},"${new_title}",${aft}" >> new_data.csv
    j=$(($j+1))
    printf "\b${sp:i++%${#sp}:1}"
done < "just_data.csv"
echo ""
echo "Done"


rm head_data.csv >> log
rm just_data.csv >> log
rm titles.txt >> log
rm *.bak >> log
rm *.txt >> log

mv new_data.csv data.csv

