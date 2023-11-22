#!/bin/bash
# ---------------------------------------------
# TEST PARAMETERS
# ---------------------------------------------
NB_THREADS=(2 4 8 16 32 64)
NB_TESTS=(5)
TOTAL_TESTS=$((${#NB_THREADS[@]} * $NB_TESTS))

# ---------------------------------------------
# RUN TESTS
# ---------------------------------------------
CSV_FILE="measurements.csv"
echo -n "nb_threads," > "$CSV_FILE"
for test_num in $(seq 1 $NB_TESTS); do
  echo -n "test$test_num," >> "$CSV_FILE"
done
echo "" >> "$CSV_FILE"

for j in "${NB_THREADS[@]}"; do
  echo "Test with $j threads."
  echo -n "$j," >> "$CSV_FILE"

  for i in $(seq 1 $NB_TESTS); do

    NB_RAN_TESTS=($j - 1 * $NB_TESTS + $i)
    

    TIME_LOG=$(mktemp)
    /usr/bin/time -f "%e" -o "$TIME_LOG" make -s -j$j
    ELAPSED_TIME=$(cat "$TIME_LOG")

    kill $!
    echo "Time elapsed = $ELAPSED_TIME s." 

    echo -n "$ELAPSED_TIME," >> "$CSV_FILE"

    # Cleaning
    rm -f "$TIME_LOG"
    make -s clean
  done
  echo "" >> "$CSV_FILE"
done
