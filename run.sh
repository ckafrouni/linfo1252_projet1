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
DIR_DATA=$PROJECT_DIR'/data'
DIR_GRAPHS=$PROJECT_DIR'/plots'

echo "Installing library (1/3)"
python3 -m pip install --user matplotlib > /dev/null 2>&1
echo "Installing library (2/3)"
python3 -m pip install --user pandas > /dev/null 2>&1
echo "Installing library (3/3)"
python3 -m pip install --user seaborn > /dev/null 2>&1

# ---------------------------------------------
# RUN TESTS PHILOSOPHERS
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nPhilosophers tests\n==========================\e[0m"
# make -s build_philosophers &
# sleep 2s
# bash $DIR_TESTS/perf_philosophers.sh $DIR_TARGET $DIR_DATA

# ---------------------------------------------
# RUN TESTS PRODUCERS/CONSUMERS
# ---------------------------------------------
echo -e "\n\e[32m==========================\nProducers/consumers tests\n==========================\e[0m"
make -s build_producers_consumers &
sleep 2s
bash $DIR_TESTS/perf_producers-consumers.sh $DIR_TARGET $DIR_DATA

# ---------------------------------------------
# RUN TESTS READERS/WRITERS
# ---------------------------------------------
# echo -e "\n\e[32m==========================\nReaders/writers tests\n==========================\e[0m"
# make -s build_readers_writers &
# sleep 2s
# bash $DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $DIR_DATA

# ---------------------------------------------
# CREATE PLOTS ON RESULTS
# ---------------------------------------------
echo -e "\n\e[32m==========================\nPlot results\n==========================\e[0m"
echo "Plotting..."
python3 $DIR_PLOTS/plot_tests_results.py $DIR_DATA $DIR_GRAPHS
echo "Done"

# ---------------------------------------------
# CLEAR TEMPORARY FILES
# ---------------------------------------------
make -s clean & > /dev/null 2>&1