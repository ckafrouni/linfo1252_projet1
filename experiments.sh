#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nSetup Environment\n==========================\e[0m"
PROJECT_DIR=$(pwd)

DIR_TARGET=$PROJECT_DIR'/target'
DIR_TESTS=$PROJECT_DIR'/src/test'
DIR_DATA=$PROJECT_DIR'/data'

mkdir -p $DIR_DATA

# ---------------------------------------------
# RUN TESTS READERS/WRITERS
# ---------------------------------------------
echo -e "\n\e[32m==========================\nReaders/writers tests\n==========================\e[0m"
bash $DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $DIR_DATA/res_readers-writers.csv
cat $DIR_DATA/res_readers-writers.csv