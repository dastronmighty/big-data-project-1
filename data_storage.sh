#!/bin/bash

rm ./data/author_data.csv >> log
rm ./data/post_data.csv >> log
rm ./data/sub_data.csv >> log

./split_data.sh "./data/author_data.txt" "./data/author_data.csv" "data.csv"
./split_data.sh "./data/post_data.txt" "./data/post_data.csv" "data.csv"
./split_data.sh "./data/sub_data.txt" "./data/sub_data.csv" "data.csv"

cat ./data/author_data.csv | uniq > ./data/tmp.csv
rm ./data/author_data.csv
mv ./data/tmp.csv ./data/author_data.csv

cat ./data/post_data.csv | uniq > ./data/tmp.csv
rm ./data/post_data.csv
mv ./data/tmp.csv ./data/post_data.csv

cat ./data/sub_data.csv | uniq > ./data/tmp.csv
rm ./data/sub_data.csv
mv ./data/tmp.csv ./data/sub_data.csv

./csvs_to_sql.sh
rm ./data/author_data.csv
rm ./data/post_data.csv
rm ./data/sub_data.csv

echo "check and kill mongo"
mongo_running=$(ps -ax | grep mongo | cut -d" " -f2 | head -n 1)
kill -9 $mongo_running >> log

mongod --dbpath=/Users/user/data/db --fork --syslog

mongo reddit --eval "db.data.drop()"
mongoimport -d reddit -c data --type csv --file data.csv --headerline

echo "stopping mongo"
mongo_running=$(ps -ax | grep mongo | cut -d" " -f1 | head -n 1)
kill  $mongo_running


