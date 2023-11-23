CC := gcc
CFLAGS := -g -Wall -Wextra
DIR_TARGET := target
SRC_DIR := src/main
SOURCES = $(wildcard $(SRC_DIR)/*.c)
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%,$(SOURCES))

.PHONY: all clean test

# Section compilation

all: $(DIR_TARGET) $(EXECUTABLES)

$(DIR_TARGET):
	mkdir -p $(DIR_TARGET)

$(DIR_TARGET)/%: $(SRC_DIR)/%.c
	-$(CC) $(CFLAGS) $< -o $@


# Section tests

DIR_TESTS := src/test
DIR_PLOTS := src/plot
DIR_DATA := data
DIR_GRAPHS := plots

test:
	@echo "Tests are not implemented yet"
	# Je ne sais pas s'il faut lancer toute la chaine de commande ici, ou uniquement les script de performance...

test_philosophers: $(DIR_TARGET) $(DIR_TARGET)/philosophers
	bash $(DIR_TESTS)/perf_philosophers.sh $(DIR_TARGET) $(DIR_DATA)
	python3 $(DIR_PLOTS)/plot_philosophers.py $(DIR_DATA) $(DIR_GRAPHS)

test_producers_consumers: $(DIR_TARGET) $(DIR_TARGET)/producers_consumers
	@echo "Producers/Consumers tests are not implemented yet"

test_readers_writers: $(DIR_TARGET) $(DIR_TARGET)/readers_writers
	@echo "Readers/Writers tests are not implemented yet"

clean:
	rm -rf $(DIR_TARGET)