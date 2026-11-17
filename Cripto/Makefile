
APP := golden_vectors

CC ?= gcc

CFLAGS ?= -Wall -Wextra

SRCS := kernels/present80_ref.c \
	kernels/present_sbox.c \
	kernels/simon64_128_ref.c \
	framework/golden_vectors.c

OBJS := $(SRCS:.c=.o)

.PHONY: all run clean help

all: $(APP)

$(APP): $(OBJS)
	$(CC) $(OBJS) -o $@ 

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(APP)
	./$(APP)

clean:
	rm -f $(OBJS) $(APP)

help:
	@echo "Usage:"
	@echo "  make        - Build"
	@echo "  make run    - Run"
	@echo "  make clean  - Clean up build files"
