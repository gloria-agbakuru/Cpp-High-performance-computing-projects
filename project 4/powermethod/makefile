CC=mpicc
CFLAGS=-O3

all: powermethod

powermethod: powermethod.c
	$(CC) $(CFLAGS) $^ -o $@ -lm

clean:
	rm -f powermethod
