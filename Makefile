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
SOURCES := $(filter-out $(SRC_DIR)/lock.c,$(SOURCES))
OBJECTS = $(DIR_TARGET)/obj/tas.o $(DIR_TARGET)/obj/ttas.o \
$(DIR_TARGET)/obj/bttas.o $(DIR_TARGET)/obj/sem.o
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%_standard,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%_tas,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%_ttas,$(SOURCES))
EXECUTABLES += $(patsubst $(SRC_DIR)/%.c,$(DIR_TARGET)/%_bttas,$(SOURCES))
EXECUTABLES += $(DIR_TARGET)/lock_tas \
$(DIR_TARGET)/lock_ttas \
$(DIR_TARGET)/lock_bttas

all: tmp $(DIR_TARGET) $(OBJECTS) $(EXECUTABLES)
	@echo "\e[31m======= Build finished! =======\e[0m"
tmp:
	@echo "\e[32mSOURCES:\e[0m\n$(SOURCES)"
	@echo "\e[32mOBJECTS:\e[0m\n$(OBJECTS)"
	@echo "\e[32mEXECUTABLES:\e[0m\n$(EXECUTABLES)"
	@echo "\e[32mCFLAGS: \e[0m$(CFLAGS)"
	@echo "\e[32mLIBS: \e[0m$(LIBS)"
	@echo "\e[31m====== Build starting... \e[31m======\e[0m"

# Debug build (Allows c code wrapped in DEBUG to be compiled)
debug: CFLAGS += $(DFLAGS)
debug: all

$(DIR_TARGET):
	mkdir -p $(DIR_TARGET)
	mkdir -p $(DIR_TARGET)/obj

# Compile lib/lock.c with different flags for different lock implementations objects
$(DIR_TARGET)/obj/tas.o: $(SRC_DIR)/lib/lock.c $(SRC_DIR)/lib/lock.h
	$(CC) -DTAS $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/obj/ttas.o: $(SRC_DIR)/lib/lock.c $(SRC_DIR)/lib/lock.h
	$(CC) -DTTAS $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/obj/bttas.o: $(SRC_DIR)/lib/lock.c $(SRC_DIR)/lib/lock.h
	$(CC) -DBTTAS $(CFLAGS) -c $< -o $@ $(LIBS)

# Compile executables of the lock performance test with different flags for different lock implementations
$(DIR_TARGET)/obj/sem.o: $(SRC_DIR)/lib/sem.c $(SRC_DIR)/lib/sem.h
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

$(DIR_TARGET)/lock_tas: $(DIR_TARGET)/obj/tas.o $(SRC_DIR)/lock.c
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_TARGET)/lock_ttas: $(DIR_TARGET)/obj/ttas.o $(SRC_DIR)/lock.c
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_TARGET)/lock_bttas: $(DIR_TARGET)/obj/bttas.o $(SRC_DIR)/lock.c
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

# Compile all other targets
$(DIR_TARGET)/%_standard: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

$(DIR_TARGET)/%_tas: $(SRC_DIR)/%.c $(DIR_TARGET)/obj/tas.o $(DIR_TARGET)/obj/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_TARGET)/%_ttas: $(SRC_DIR)/%.c $(DIR_TARGET)/obj/ttas.o $(DIR_TARGET)/obj/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

$(DIR_TARGET)/%_bttas: $(SRC_DIR)/%.c $(DIR_TARGET)/obj/bttas.o $(DIR_TARGET)/obj/sem.o
	$(CC) -DCUSTOM_MUTEX_AND_SEMAPHORE $(CFLAGS) $^ -o $@ $(LIBS)

# ---------------------------------------------
# RUN SECTION
# ---------------------------------------------
studsrv: clean zip
	unzip $(DIR_TARGET)/proj1.zip -d $(DIR_TARGET)/proj1
	cd $(DIR_TARGET)/proj1 && make -j -s && (DEBUG=1 time -p ./experiments.sh)

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
	zip -r $(DIR_TARGET)/proj1.zip $(SRC_DIR) $(DIR_TESTS) Makefile experiments.sh

.PHONY: all tmp debug stdusrv clean zip
