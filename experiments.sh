#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------

# make

# check if target directory exists
if [ ! -d "target" ]; then
    echo -e "\e[31mError: target directory not found. Please compile the project first.\e[0m"
    exit 1
fi

# check if target directory is empty
if [ ! "$(ls -A target)" ]; then
    echo -e "\e[31mError: target directory is empty. Please compile the project first.\e[0m"
    exit 1
fi

echo -e "\n\e[32m==========================\nSetup Environment\n==========================\e[0m"
PROJECT_DIR=$(pwd)
DIR_TARGET=$PROJECT_DIR'/target'
DIR_TESTS=$PROJECT_DIR'/src/test'
DIR_DATA=$PROJECT_DIR'/data'
mkdir -p $DIR_DATA

EXPERIMENT=1

# ---------------------------------------------
# RUN TESTS READERS/WRITERS
# ---------------------------------------------
if [ $EXPERIMENT -eq 1 ]; then
    echo -e "\n\e[32m==========================\nReaders/writers tests\n==========================\e[0m"
    bash $DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $DIR_DATA/res_readers-writers.csv
    cat $DIR_DATA/res_readers-writers.csv
fi


# ---------------------------------------------
# RUN TESTS PRODUCERS/CONSUMERS
# ---------------------------------------------
if [ $EXPERIMENT -eq 2 ]; then
    echo -e "\n\e[32m==========================\nProducers/consumers tests\n==========================\e[0m"
    bash $DIR_TESTS/perf_producers-consumers.sh $DIR_TARGET $DIR_DATA/res_producers-consumers.csv
    cat $DIR_DATA/res_producers-consumers.csv
fi

# ---------------------------------------------
# RUN TESTS PHILOSOPHERS
# ---------------------------------------------
if [ $EXPERIMENT -eq 3 ]; then
    echo -e "\n\e[32m==========================\nPhilosophers tests\n==========================\e[0m"
    bash $DIR_TESTS/perf_philosophers.sh $DIR_TARGET $DIR_DATA/res_philosophers.csv
    cat $DIR_DATA/res_philosophers.csv
fi
