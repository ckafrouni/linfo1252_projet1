#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
DIR_TARGET=$1
DIR_DATA=$2
NB_THREADS=(2 4 8 16 32 64)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * 2 * $NB_TESTS))
INDEX=0

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="$DIR_DATA/res_readers-writers.csv"
echo "index,thread,time,run_index" > "$CSV_FILE"

for i in "${!NB_THREADS[@]}"; do
    THREAD="${NB_THREADS[$i]}"

        for k in $(seq 1 $NB_TESTS); do
            echo "[Test $((i + j + 1)) run $k/$NB_TESTS]($((INDEX + 1))/$TOTAL_TESTS)"

            ELAPSED_TIME=$( TIMEFORMAT='%R'; { time $DIR_TARGET/producers_consumers $THREAD $THREAD ;} 2>&1)
            echo "$ELAPSED_TIME"

            echo "$INDEX,$THREAD,$ELAPSED_TIME,$((k - 1))" >> "$CSV_FILE"

            ((INDEX++))
        done
    done
done
