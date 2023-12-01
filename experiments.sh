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
    "Philosophers        standard"                      # 0  - done
    "Philosophers        test-and-set"                  # 1  - done
    "Philosophers        test-and-test-and-set"         # 2  - done
    "Philosophers        backoff-test-and-test-and-set" # 3  -  X
    "Producers/consumers standard"                      # 4  - done
    "Producers/consumers test-and-set"                  # 5  - done
    "Producers/consumers test-and-test-and-set"         # 6  - done
    "Producers/consumers backoff-test-and-test-and-set" # 7  -  X
    "Readers/writers     standard"                      # 8  - done
    "Readers/writers     test-and-set"                  # 9  - done
    "Readers/writers     test-and-test-and-set"         # 10 - done
    "Readers/writers     backoff-test-and-test-and-set" # 11 -  X
    "Lock                test-and-set"                  # 12 - done
    "Lock                test-and-test-and-set"         # 13 - done
    "Lock                backoff-test-and-test-and-set" # 14 -  X
)

EXPERIMENTS_CMDS=(
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_standard '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_test-and-set '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_test-and-test-and-set '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_backoff-test-and-test-and-set '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_test-and-test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_backoff-test-and-test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_test-and-test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_backoff-test-and-test-and-set '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_test-and-set '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_test-and-test-and-set '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_backoff-test-and-test-and-set '(1,2,4,8,16,32,64)' $CSV"
)

# ---------------------------------------------
# RUN EXPERIMENTS
# ---------------------------------------------
# CHANGE THIS TO RUN A DIFFERENT EXPERIMENT
EXPERIMENT=(4 5 6 7 8 9 10 11 12 13 14)

for i in "${!EXPERIMENT[@]}"; do
    echo -e "\e[32m========================== #$i ${EXPERIMENTS_NAMES[$i]} ==========================\e[0m"
    bash ${EXPERIMENTS_CMDS[$i]} > /dev/null 2>&1
    cat $CSV
    echo -e "\e[32m========================== ${EXPERIMENTS_NAMES[$i]} ==========================\e[0m\n"
done




