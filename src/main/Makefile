CC = gcc
CFLAGS = -g -Wall -Wextra
TARGET_DIR = target
SOURCES = $(wildcard *.c)
EXECUTABLES = $(SOURCES:%.c=$(TARGET_DIR)/%)

all: $(TARGET_DIR) $(EXECUTABLES)

$(TARGET_DIR):
	mkdir -p $(TARGET_DIR)

$(TARGET_DIR)/%: %.c
	-$(CC) $(CFLAGS) $< -o $@

philosophers: $(TARGET_DIR)
	-$(CC) $(CFLAGS) philosophers.c -o ./$(TARGET_DIR)/philosophers.o

# Commands
test:
	@echo "Tests are not implemented yet"

clean:
	rm -rf $(TARGET_DIR)

# Temporary commands
time_phil: all
	time ./$(TARGET_DIR)/philosophers 8

.PHONY: all clean test run_philosophers