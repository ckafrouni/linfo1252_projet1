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

# Commands
test:
	@echo "Tests are not implemented yet"

clean:
	rm -rf $(TARGET_DIR)

# Temporary commands
run_philosophers: all
	time ./$(TARGET_DIR)/philosophers 3

.PHONY: all clean test run_philosophers