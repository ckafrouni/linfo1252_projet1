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
	@echo "Build finished"

$(DIR_TARGET):
	mkdir $(DIR_TARGET)

$(DIR_TARGET)/%: $(SRC_DIR)/%.c
	-$(CC) $(CFLAGS) $< -o $@

zip: $(DIR_TARGET)
	zip -r $(DIR_TARGET)/proj1.zip $(SRC_DIR) $(DIR_TESTS) Makefile experiments.sh

# ---------------------------------------------
# RUN SECTION
# ---------------------------------------------
studsrv: clean zip
	unzip $(DIR_TARGET)/proj1.zip -d $(DIR_TARGET)/proj1
	cd $(DIR_TARGET)/proj1 && make && ./experiments.sh

# ---------------------------------------------
# RUN TEST SECTION
# ---------------------------------------------
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
# CLEAN SECTION
# ---------------------------------------------
clean:
	rm -rf $(DIR_TARGET)