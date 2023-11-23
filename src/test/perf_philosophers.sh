#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
DIR_TARGET=$1
DIR_DATA=$2
NB_THREADS=(2 4 8 16 32 64)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))
INDEX=0

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="$DIR_DATA/res_philosophers.csv"
echo "index,thread,time,run_index" > "$CSV_FILE"

for i in "${NB_THREADS[@]}"; do
    for k in $(seq 1 $NB_TESTS); do
        echo "Run $((k + 1))/${#NB_TESTS[@]} for test ${NB_THREADS[$i]} ($((INDEX + 1)) / $TOTAL_TESTS)"
        
        ELAPSED_TIME=$(TIMEFORMAT='%R'; time ($DIR_TARGET/philosophers.o $i) | grep real | awk '{print $2}')
        
        echo "$INDEX,$i,$ELAPSED_TIME,$k" >> "$CSV_FILE"
        (($INDEX++))
    done
done

