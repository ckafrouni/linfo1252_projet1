#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
NB_THREADS=(2 4 8 16 32 64)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))
DIR_DATA=$1

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="$DIR_DATA/res_philosophers.csv"
echo -n "index,thread,build,time,run_index" >> "$CSV_FILE"
