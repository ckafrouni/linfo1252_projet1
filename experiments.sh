#!/usr/bin/bash
# ---------------------------------------------
# SET TEST ENVIRONMENT
# ---------------------------------------------
PROJECT_DIR="$(pwd)"
DIR_EXE="$PROJECT_DIR/target/exe"
DIR_TESTS="$PROJECT_DIR/src/test"

CSV="$PROJECT_DIR/tmp.csv"

# ---------------------------------------------
# EXPERIMENTS
# ---------------------------------------------
EXPERIMENTS=(3 2 1)
# We can do : 0 1 3 4 5 7 8 10 11 12 13 15
if [ ! -z "${LOCAL}" ]; then
    # EXPERIMENTS=(4 5 6 7 8 9 10 11 12 13 14 15 0 1 2 3)
    EXPERIMENTS=(1 2 3)
fi

EXPERIMENTS_NAMES=(
    "Philosophers           standard" # 0  - x - ✔️
    "Philosophers           tas"      # 1  - x -
    "Philosophers           ttas"     # 2
    "Philosophers           bttas"    # 3  - x - ✔️
    "Producers/consumers    standard" # 4  - x - ✔️
    "Producers/consumers    tas"      # 5  - x - ✔️
    "Producers/consumers    ttas"     # 6
    "Producers/consumers    bttas"    # 7  - x - ✔️
    "Readers/writers        standard" # 8  - x - ✔️
    "Readers/writers        tas"      # 9  - x - ✔️
    "Readers/writers        ttas"     # 10
    "Readers/writers        bttas"    # 11 - x - ✔️
    "Lock/unlock            standard" # 12 - x - ✔️
    "Lock/unlock            tas"      # 13 - x - ✔️
    "Lock/unlock            ttas"     # 14
    "Lock/unlock            bttas"    # 15 - x - ✔️
)

EXPERIMENTS_CMDS=(
    "$DIR_TESTS/perf.sh $DIR_EXE/philosophers_standard '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/philosophers_tas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/philosophers_ttas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/philosophers_bttas '(2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/producers-consumers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/producers-consumers_tas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/producers-consumers_ttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/producers-consumers_bttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/readers-writers_standard '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/readers-writers_tas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/readers-writers_ttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/readers-writers_bttas '(1,2,4,8,16,32)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/lock-unlock_standard '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/lock-unlock_tas '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/lock-unlock_ttas '(1,2,4,8,16,32,64)' $CSV"
    "$DIR_TESTS/perf.sh $DIR_EXE/lock-unlock_bttas '(1,2,4,8,16,32,64)' $CSV"
)

# ---------------------------------------------
# RUN EXPERIMENTS
# ---------------------------------------------
if [ ! -z "${LOCAL}" ]; then
    lscpu >"./data/local/lscpu.txt"
fi

for i in "${EXPERIMENTS[@]}"; do
    echo -e "\n\e[32m#$i ${EXPERIMENTS_NAMES[$i]}\e[0m"
    if [ -z "${DEBUG}" ]; then
        bash ${EXPERIMENTS_CMDS[$i]} >/dev/null 2>&1
    else
        bash ${EXPERIMENTS_CMDS[$i]}
    fi
    echo -e "\e[33;1m${EXPERIMENTS_NAMES[$i]}\e[0;34m"
    if [ ! -z "${LOCAL}" ]; then
        cat $CSV >"./data/local/${i}.csv"
    else
        cat $CSV
    fi
    echo -e "\e[0m"
done
