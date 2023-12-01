#!/bin/bash
# ---------------------------------------------
# CHECK PARAMETERS
# ---------------------------------------------
if [ "$#" -eq 4 ]; then
    echo "Usage: $0 '<application.o>,<list of threads>,<csv file>'"
    return 1
fi

# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
DIR_TARGET=$1
CSV_FILE=$3

NB_THREAD_STRING="${2//[\(\)\'\']/}"
IFS=',' read -r -a NB_THREADS <<< "$NB_THREAD_STRING"



NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))
INDEX=0

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
echo "index,thread,time,run_index" > "$CSV_FILE"

for i in "${!NB_THREADS[@]}"; do

    THREAD="${NB_THREADS[$i]}"

    for k in $(seq 1 $NB_TESTS); do

        echo "[Run $k/$NB_TESTS of test $((i + 1))]($((INDEX + 1))/$TOTAL_TESTS)"

        ELAPSED_TIME=$( TIMEFORMAT='%R'; { time $DIR_TARGET $THREAD $THREAD ;} 2>&1)
        echo "$ELAPSED_TIME"

        echo "$INDEX,$THREAD,$ELAPSED_TIME,$((k - 1))" >> "$CSV_FILE"

        ((INDEX++))
    done
done