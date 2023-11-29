#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
DIR_TARGET=$1
DIR_DATA=$2
NB_THREADS=(1 2 4 8 16 32)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))
INDEX=0

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="$DIR_DATA/res_producers-consumers.csv"
echo "index,thread,time,run_index" > "$CSV_FILE"

for i in "${!NB_THREADS[@]}"; do
    THREAD="${NB_THREADS[$i]}"

    for k in $(seq 1 $NB_TESTS); do
        echo "[Run $k/$NB_TESTS of test $((i + 1))]($((INDEX + 1))/$TOTAL_TESTS)"

        ELAPSED_TIME=$( TIMEFORMAT='%R'; { time $DIR_TARGET/producers_consumers $THREAD $THREAD ;} 2>&1)
        echo "$ELAPSED_TIME"

        echo "$INDEX,$THREAD,$ELAPSED_TIME,$((k - 1))" >> "$CSV_FILE"

        ((INDEX++))
    done
done
