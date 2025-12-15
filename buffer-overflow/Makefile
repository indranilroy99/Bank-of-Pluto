CC = gcc
# Detect OS and set appropriate flags
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS flags
    CFLAGS = -fno-stack-protector -g -O0
else
    # Linux flags
    CFLAGS = -fno-stack-protector -z execstack -g -O0
endif
SRC_DIR = src
BIN_DIR = bin

# Target binaries
TARGETS = $(BIN_DIR)/stack_overflow $(BIN_DIR)/heap_overflow $(BIN_DIR)/format_string

.PHONY: all clean

all: $(TARGETS)

# Stack overflow binary
$(BIN_DIR)/stack_overflow: $(SRC_DIR)/stack_overflow.c
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $<

# Heap overflow binary
$(BIN_DIR)/heap_overflow: $(SRC_DIR)/heap_overflow.c
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $<

# Format string binary
$(BIN_DIR)/format_string: $(SRC_DIR)/format_string.c
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(BIN_DIR)

install: all
	chmod +x $(BIN_DIR)/*
	chmod +x cgi-bin/*.php

