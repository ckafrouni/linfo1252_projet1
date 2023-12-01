#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
echo -e "\n\e[32m==========================\nSetup Environment\n==========================\e[0m"
PROJECT_DIR=$(dirname "${BASH_SOURCE[0]}")
DIR_MAIN=$PROJECT_DIR'/src/main'
DIR_TARGET=$PROJECT_DIR'/target'
DIR_TESTS=$PROJECT_DIR'/src/test'
DIR_PLOTS=$PROJECT_DIR'/src/plot'
DIR_DATA=$PROJECT_DIR'/data/local'
DIR_GRAPHS=$PROJECT_DIR'/plots/local'

echo "Installing library (1/3)"
python3 -m pip install --user matplotlib > /dev/null 2>&1
echo "Installing library (2/3)"
python3 -m pip install --user pandas > /dev/null 2>&1
echo "Installing library (3/3)"
python3 -m pip install --user seaborn > /dev/null 2>&1

# ---------------------------------------------
# RUN TESTS FOR PHILOSOPHERS
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nPhilosophers tests\n==========================\e[0m"
# make -s build_philosophers &
# sleep 2s
# bash $DIR_TESTS/perf_philosophers.sh $DIR_TARGET $DIR_DATA/res_philosophers_local.csv

# ---------------------------------------------
# RUN TESTS FOR PRODUCERS/CONSUMERS
# ---------------------------------------------
echo -e "\n\e[32m==========================\nProducers/consumers tests\n==========================\e[0m"
make -s build_producers-consumers &
sleep 2s
bash $DIR_TESTS/perf.sh $DIR_TARGET/default_lib/producers-consumers $DIR_DATA/res_producers-consumers_standard.csv

# ---------------------------------------------
# RUN TESTS FOR READERS/WRITERS
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nReaders/writers tests\n==========================\e[0m"
# make -s build_readers-writers &
# sleep 2s
# bash $DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $DIR_DATA/res_readers-writers_local.csv

# ---------------------------------------------
# RUN TESTS FOR TEST AND SET
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nTests&set tests\n==========================\e[0m"
# make -s build_test-and-set &
# sleep 2s
# bash $DIR_TESTS/perf_test-and-set.sh $DIR_TARGET $DIR_DATA/res_test-and-set_local.csv

# ---------------------------------------------
# CREATE PLOTS ON RESULTS
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nPlot results\n==========================\e[0m"
# echo "Plotting..."
# python3 $DIR_PLOTS/plot_tests_results.py $DIR_DATA $DIR_GRAPHS local
# echo "Done"

# ---------------------------------------------
# CLEAR TEMPORARY FILES
# ---------------------------------------------
echo -e "\n\e[32m==========================\nCleaning\n==========================\e[0m"
echo "Cleaning..."
make -s clean & > /dev/null 2>&1
echo "Done"
