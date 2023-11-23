#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
PROJECT_DIR=$(dirname "${BASH_SOURCE[0]}")
DIR_MAIN=$PROJECT_DIR'/src/main'
DIR_TARGET=$PROJECT_DIR'/src/main/target'
DIR_TESTS=$PROJECT_DIR'/src/test'
DIR_PLOTS=$PROJECT_DIR'/src/plot'
DIR_DATA=$PROJECT_DIR'/data'
DIR_GRAPHS=$PROJECT_DIR'/plots'
# python3 -m pip install --user matplotlib
# python3 -m pip install --user pandas
# python3 -m pip install --user seaborn

# ---------------------------------------------
# RUN TESTS PHILOSOPHERS
# ---------------------------------------------
cd $DIR_MAIN && make -s philosophers &
sleep 2s
bash $DIR_TESTS/perf_philosophers.sh $DIR_TARGET $DIR_DATA
python3 $DIR_PLOTS/plot_philosophers.py $DIR_DATA $DIR_GRAPHS

# ---------------------------------------------
# RUN TESTS READERS/WRITERS
# ---------------------------------------------

# ---------------------------------------------
# RUN TESTS PRODUCERS/CONSUMERS
# ---------------------------------------------

# ---------------------------------------------
# CLEAR TEMPORARY FILES
# ---------------------------------------------
cd $DIR_MAIN && make -s clean & > /dev/null 2>&1