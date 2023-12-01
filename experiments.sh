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
    "Readers/writers tests"               # 0 - done
    "Producers/consumers tests"           # 1 - done
    "Philosophers tests"                  # 2 - done
    "Test-and-set tests"                  # 3 - done
    "Test-and-test-and-set tests"         # 4 - done
    "Backoff-test-and-test-and-set tests" # 5 - done (This is actually backoff-test-and-set not backoff-test-and-test-and-set)
)

EXPERIMENTS_CMDS=(
    "$DIR_TESTS/perf_readers-writers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_producers-consumers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_philosophers.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_test-and-set.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_test_and_test_and_set.sh $DIR_TARGET $CSV"
    "$DIR_TESTS/perf_backoff_test_and_test_and_set.sh $DIR_TARGET $CSV"
)

# ---------------------------------------------
# RUN EXPERIMENTS
# ---------------------------------------------
# CHANGE THIS TO RUN A DIFFERENT EXPERIMENT
EXPERIMENT=(0 1 3 4 5)

for i in "${!EXPERIMENT[@]}"; do
    echo -e "\e[32m========================== #$i ${EXPERIMENTS_NAMES[$i]} ==========================\e[0m"
    bash ${EXPERIMENTS_CMDS[$i]} > /dev/null 2>&1
    cat $CSV
    echo -e "\e[32m========================== ${EXPERIMENTS_NAMES[$i]} ==========================\e[0m\n"
done




