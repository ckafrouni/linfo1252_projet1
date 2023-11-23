#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
DIR_MAIN=$1
DIR_DATA=$2
NB_THREADS=(2 4 8 16 32 64)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="$DIR_DATA/res_philosophers.csv"
echo -n "index,thread,time,run_index" >> "$CSV_FILE"

for i in "${NB_THREADS[@]}"; do
    for k in $(seq 1 $NB_TESTS); do
        # Time start
        # run philosophers
        # Time stop
        
        sleep 2s

        #insert results

    done
done

