# ---------------------------------------------
# BUILD SECTION
# ---------------------------------------------
CC := gcc
DFLAGS := -DDEBUG -g
CFLAGS := -Wall -Wextra -Werror -O3
LIBS := -lpthread -lrt

DIR_TARGET := target
DIR_OBJ := $(DIR_TARGET)/obj
DIR_EXE := $(DIR_TARGET)/exe
SRC_DIR := src/main
LIB_DIR := src/lib

SOURCES = $(wildcard $(SRC_DIR)/*.c)

OBJECTS = $(DIR_OBJ)
OBJECTS += $(DIR_OBJ)/tas.o $(DIR_OBJ)/ttas.o $(DIR_OBJ)/bttas.o $(DIR_OBJ)/sem.o

EXECUTABLES = $(DIR_EXE)
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_EXE)/%_standard,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_EXE)/%_tas,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_EXE)/%_ttas,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_EXE)/%_bttas,$(SOURCES))

all: $(DIR_TARGET) $(OBJECTS) $(EXECUTABLES)
	@echo "\e[31m======= Build finished! =======\e[0m"

# Debug build (Allows c code wrapped in DEBUG to be compiled)
debug: CFLAGS += $(DFLAGS)
debug: all

$(DIR_TARGET): 
	mkdir -p $(DIR_TARGET)

$(DIR_OBJ):
	mkdir -p $(DIR_OBJ)

$(DIR_EXE):
	mkdir -p $(DIR_EXE)

# Compile lib/lock.c with different flags for different lock implementations objects
$(DIR_OBJ)/tas.o: $(LIB_DIR)/lock.c $(LIB_DIR)/lock.h
	$(CC) -DTAS $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_OBJ)/ttas.o: $(LIB_DIR)/lock.c $(LIB_DIR)/lock.h $(DIR_OBJ)
	$(CC) -DTTAS $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_OBJ)/bttas.o: $(LIB_DIR)/lock.c $(LIB_DIR)/lock.h $(DIR_OBJ)
	$(CC) -DBTTAS $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_OBJ)/sem.o: $(LIB_DIR)/sem.c $(LIB_DIR)/sem.h $(DIR_OBJ)
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

# Compile all other targets
$(DIR_EXE)/%_standard: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

$(DIR_EXE)/%_tas: $(SRC_DIR)/%.c $(DIR_OBJ)/tas.o $(DIR_OBJ)/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_EXE)/%_ttas: $(SRC_DIR)/%.c $(DIR_OBJ)/ttas.o $(DIR_OBJ)/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_EXE)/%_bttas: $(SRC_DIR)/%.c $(DIR_OBJ)/bttas.o $(DIR_OBJ)/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

# ---------------------------------------------
# RUN SECTION
# ---------------------------------------------
studsrv: clean zip
	unzip $(DIR_TARGET)/proj1.zip -d $(DIR_TARGET)/proj1
	cd $(DIR_TARGET)/proj1 && make -j -s && (time -p ./experiments.sh)

DIR_TESTS := src/test
DIR_PLOTS := src/plot
DIR_DATA := data
DIR_GRAPHS := plots

# ---------------------------------------------
# UTILITY SECTION
# ---------------------------------------------
clean:
	rm -rf $(DIR_TARGET)

zip: $(DIR_TARGET)
	zip -r $(DIR_TARGET)/proj1.zip $(SRC_DIR) $(LIB_DIR) $(DIR_TESTS) Makefile experiments.sh

.PHONY: all tmp debug stdusrv clean zip
