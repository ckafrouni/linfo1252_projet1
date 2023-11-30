#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
PROJECT_DIR="$(pwd)"
DIR_TARGET="$PROJECT_DIR/target"
DIR_TESTS="$PROJECT_DIR/src/test"

CSV="$PROJECT_DIR/tmp.csv"

# ---------------------------------------------
# EXPERIMENTS
# ---------------------------------------------
EXPERIMENTS_NAMES=(
    "Readers/writers tests"               # 1 - done
    "Producers/consumers tests"           # 2
    "Philosophers tests"                  # 3
    "Test-and-set tests"                  # 4
    "Test-and-test-and-set tests"         # 5
    "Backoff-test-and-test-and-set tests" # 6
)

EXPERIMENTS_CMDS=(
    "$DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_producers-consumers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_philosophers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_test-and-set.sh $DIR_TARGET $CSV"
)

# ---------------------------------------------
# RUN EXPERIMENTS
# ---------------------------------------------
# CHANGE THIS TO RUN A DIFFERENT EXPERIMENT
EXPERIMENT=2

echo -e "\e[32m==========================\n#$EXPERIMENT ${EXPERIMENTS_NAMES[$EXPERIMENT]}\n==========================\e[0m"
bash ${EXPERIMENTS_CMDS[$EXPERIMENT]}
echo -e "\e[32m==========================\e[0m\n"

cat $CSV
