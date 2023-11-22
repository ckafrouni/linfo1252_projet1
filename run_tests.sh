#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
DIR_TESTS='./src/test'
DIR_PLOTS='./src/plot'
DIR_DATA='./data'
# python3 -m pip install --user matplotlib
# python3 -m pip install --user pandas
# python3 -m pip install --user seaborn

# ---------------------------------------------
# RUN TESTS PHILOSOPHERS
# ---------------------------------------------
bash $DIR_TESTS/perf_philosophers.sh $DIR_DATA
python3 $DIR_PLOTS/plot_philosophers.py

# ---------------------------------------------
# RUN TESTS READERS/WRITERS
# ---------------------------------------------

# ---------------------------------------------
# RUN TESTS PRODUCERS/CONSUMERS
# ---------------------------------------------

# ---------------------------------------------
# CLEAR TEMPORARY FILES
# ---------------------------------------------
cd src && make clean > /dev/null 2>&1