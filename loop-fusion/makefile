CC=llvm-gcc
CFLAGS=-I ../../include -c -emit-llvm
all: $(patsubst %.c, %.bc, $(wildcard *.c))

%.bc: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.bc
