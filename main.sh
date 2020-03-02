#!/bin/bash

m_start=$SECONDS

rm log > log
rm *.csv >> log
rm *.bak >> log

cp data/Reddit_shorter_COMP30770.csv data.csv


echo "STARTING DATA CLEANING!"
gather_s=$SECONDS
./gather_data.sh
gather_e=$SECONDS
echo ""
echo "Data Gathering and cleaning took: $((gather_e - gather_s)) seconds."


echo ""
echo ""
echo "STARTING DATA STORAGE"
storing_s=$SECONDS
./data_storage.sh
storing_e=$SECONDS
echo ""
echo "Data storing took: $((storing_e-storing_s)) seconds."

rm tmp.csv >> log
rm data.csv >> log

m_end=$SECONDS
echo "Project took: $((m_end-m_start)) seconds."
