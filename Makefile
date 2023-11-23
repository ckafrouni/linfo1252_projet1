# ---------------------------------------------
# BUILD SECTION
# ---------------------------------------------
CC := gcc
CFLAGS := -g -Wall -Wextra
DIR_TARGET := target
SRC_DIR := src/main
SOURCES = $(wildcard $(SRC_DIR)/*.c)
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%,$(SOURCES))

.PHONY: all clean test

all: $(DIR_TARGET) $(EXECUTABLES)

$(DIR_TARGET):
	mkdir -p $(DIR_TARGET)

$(DIR_TARGET)/%: $(SRC_DIR)/%.c
	-$(CC) $(CFLAGS) $< -o $@

build: $(DIR_TARGET) build_philosophers build_producers_consumers build_readers_writers

build_philosophers: $(DIR_TARGET) $(DIR_TARGET)/philosophers

build_producers_consumers: $(DIR_TARGET) $(DIR_TARGET)/producers_consumers

build_readers_writers: $(DIR_TARGET) $(DIR_TARGET)/readers_writers

# ---------------------------------------------
# RUN SECTION
# ---------------------------------------------
run: build test clean

# ---------------------------------------------
# RUN TEST SECTION
# ---------------------------------------------
DIR_TESTS := src/test
DIR_PLOTS := src/plot
DIR_DATA := data
DIR_GRAPHS := plots

test: test_setup test_philosophers test_producers_consumers test_readers_writers

test_setup:
	@python3 -m pip install --user matplotlib
	@python3 -m pip install --user pandas
	@python3 -m pip install --user seaborn

test_philosophers:
	bash $(DIR_TESTS)/perf_philosophers.sh $(DIR_TARGET) $(DIR_DATA)
	python3 $(DIR_PLOTS)/plot_philosophers.py $(DIR_DATA) $(DIR_GRAPHS)

test_producers_consumers: $(DIR_TARGET) $(DIR_TARGET)/producers_consumers
	@echo "Producers/Consumers tests are not implemented yet"

test_readers_writers: $(DIR_TARGET) $(DIR_TARGET)/readers_writers
	@echo "Readers/Writers tests are not implemented yet"

# ---------------------------------------------
# CLEAN SECTION
# ---------------------------------------------
clean:
	rm -rf $(DIR_TARGET)