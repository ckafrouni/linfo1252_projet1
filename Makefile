CC=gcc
CFLAGS=-g -Wall -Wextra

TARGET=target
SRC=src

$(TARGET):
	mkdir $(TARGET)

build_philosopher: $(SRC)/philosophers.c
	$(CC) $(CFLAGS) -o $(TARGET)/philosophers $(SRC)/philosophers.c



clean:
	rm -rf $(TARGET)