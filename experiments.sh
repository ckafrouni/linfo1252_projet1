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
# EXPERIMENTS=(10 11)
EXPERIMENTS=(12 13 14)

EXPERIMENTS_NAMES=(
    "Philosophers        standard" # 0  - done
    "Philosophers        tas"      # 1  - done
    "Philosophers        ttas"     # 2  - done
    "Philosophers        bttas"    # 3  -  X
    "Producers/consumers standard" # 4  - done
    "Producers/consumers tas"      # 5  - done
    "Producers/consumers ttas"     # 6  - done
    "Producers/consumers bttas"    # 7  -  X
    "Readers/writers     standard" # 8  - done
    "Readers/writers     tas"      # 9  - done
    "Readers/writers     ttas"     # 10 - done
    "Readers/writers     bttas"    # 11 -  X
    "Lock                tas"      # 12 - done
    "Lock                ttas"     # 13 - done
    "Lock                bttas"    # 14 -  X
)

EXPERIMENTS_CMDS=(
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_standard '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_tas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_ttas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/philosophers_bttas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_tas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_ttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/producers-consumers_bttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_tas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_ttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/readers-writers_bttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_tas '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_ttas '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_TARGET/lock_bttas '(1,2,4,8,16,32,64)' $CSV"
)

# ---------------------------------------------
# RUN EXPERIMENTS
# ---------------------------------------------

for i in "${EXPERIMENTS[@]}"; do
    echo -e "\n\e[32m#$i ${EXPERIMENTS_NAMES[$i]}\e[0m"
    if [ -z "${DEBUG}" ]; then
        bash ${EXPERIMENTS_CMDS[$i]} >/dev/null 2>&1
    else
        bash ${EXPERIMENTS_CMDS[$i]}
    fi
    echo -e "\e[33;1m${EXPERIMENTS_NAMES[$i]}\e[0;34m"
    cat $CSV
    echo -e "\e[0m"
done
