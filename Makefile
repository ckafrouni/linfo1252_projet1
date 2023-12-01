# ---------------------------------------------
# BUILD SECTION
# ---------------------------------------------
CC := gcc
DFLAGS := -DDEBUG -g
CFLAGS := -Wall -Wextra -Werror -O2
LIBS := -lpthread -lrt
DIR_TARGET := target
SRC_DIR := src/main
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(DIR_TARGET)/obj/test_and_set.o $(DIR_TARGET)/obj/test_and_test_and_set.o $(DIR_TARGET)/obj/backoff_test_and_test_and_set.o
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%,$(SOURCES))
EXECUTABLES := $(filter-out $(DIR_TARGET)/lock,$(EXECUTABLES))
EXECUTABLES += $(DIR_TARGET)/lock_test_and_set $(DIR_TARGET)/lock_test_and_test_and_set $(DIR_TARGET)/lock_backoff_test_and_test_and_set

all: $(DIR_TARGET) $(OBJECTS) $(EXECUTABLES)
	@echo "Build finished"

# Debug build (Allows c code wrapped in DEBUG to be compiled)
debug: CFLAGS += $(DFLAGS)
debug: all

$(DIR_TARGET):
	mkdir $(DIR_TARGET)
	mkdir $(DIR_TARGET)/obj

# Compile lib/lock.c with different flags for different lock implementations
$(DIR_TARGET)/obj/test_and_set.o: $(SRC_DIR)/lib/lock.c
	$(CC) -DTEST_AND_SET $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/obj/test_and_test_and_set.o: $(SRC_DIR)/lib/lock.c
	$(CC) -DTEST_AND_TEST_AND_SET $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/obj/backoff_test_and_test_and_set.o: $(SRC_DIR)/lib/lock.c
	$(CC) -DBACKOFF_TEST_AND_TEST_AND_SET $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/lock_test_and_set: $(DIR_TARGET)/obj/test_and_set.o $(SRC_DIR)/lock.c
	$(CC) -DTEST_AND_SET $(CFLAGS) $(DIR_TARGET)/obj/test_and_set.o $(SRC_DIR)/lock.c -o $@ $(LIBS)

$(DIR_TARGET)/lock_test_and_test_and_set: $(DIR_TARGET)/obj/test_and_test_and_set.o $(SRC_DIR)/lock.c
	$(CC) -DTEST_AND_TEST_AND_SET $(CFLAGS) $(DIR_TARGET)/obj/test_and_test_and_set.o $(SRC_DIR)/lock.c -o $@ $(LIBS)

$(DIR_TARGET)/lock_backoff_test_and_test_and_set: $(DIR_TARGET)/obj/backoff_test_and_test_and_set.o $(SRC_DIR)/lock.c
	$(CC) -DBACKOFF_TEST_AND_TEST_AND_SET $(CFLAGS) $(DIR_TARGET)/obj/backoff_test_and_test_and_set.o $(SRC_DIR)/lock.c -o $@ $(LIBS)

# Compile all other files
$(DIR_TARGET)/%: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

# Targets for building individual executables
build_philosophers: $(DIR_TARGET) $(DIR_TARGET)/philosophers
build_producers-consumers: $(DIR_TARGET) $(DIR_TARGET)/producers_consumers
build_readers-writers: $(DIR_TARGET) $(DIR_TARGET)/readers_writers
build_test-and-set: $(DIR_TARGET) $(DIR_TARGET)/testing_test_and_set

# ---------------------------------------------
# RUN SECTION
# ---------------------------------------------
studsrv: clean zip
	unzip $(DIR_TARGET)/proj1.zip -d $(DIR_TARGET)/proj1
	cd $(DIR_TARGET)/proj1 && make && ./experiments.sh

DIR_TESTS := src/test
DIR_PLOTS := src/plot
DIR_DATA := data
DIR_GRAPHS := plots

test: test_setup test_philosophers test_producers_consumers test_readers_writers

test_setup:
	@python3 -m pip install matplotlib
	@python3 -m pip install pandas
	@python3 -m pip install seaborn

test_philosophers: $(DIR_TARGET) $(DIR_TARGET)/philosophers test_setup
	bash $(DIR_TESTS)/perf_philosophers.sh $(DIR_TARGET) $(DIR_DATA)
	python3 $(DIR_PLOTS)/plot_philosophers.py $(DIR_DATA) $(DIR_GRAPHS)

test_producers_consumers: $(DIR_TARGET) $(DIR_TARGET)/producers_consumers test_setup
	bash $(DIR_TESTS)/perf_producers-consumers.sh $(DIR_TARGET) $(DIR_DATA)
	python3 $(DIR_PLOTS)/plot_producers-consumers.py $(DIR_DATA) $(DIR_GRAPHS)

test_readers_writers: $(DIR_TARGET) $(DIR_TARGET)/readers_writers test_setup
	bash $(DIR_TESTS)/perf_readers-writers.sh $(DIR_TARGET) $(DIR_DATA)
	python3 $(DIR_PLOTS)/plot_readers-writers.py $(DIR_DATA) $(DIR_GRAPHS)

# ---------------------------------------------
# UTILITY SECTION
# ---------------------------------------------
clean:
	rm -rf $(DIR_TARGET)

zip: $(DIR_TARGET)
	zip -r $(DIR_TARGET)/proj1.zip $(SRC_DIR) $(DIR_TESTS) Makefile experiments.sh

.PHONY: all debug clean zip stdusrv \
test test_setup test_philosophers test_producers_consumers test_readers_writers \
build_philosophers build_producers-consumers build_readers-writers build_test-and-set
