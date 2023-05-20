CC = gcc
CFLAGS = -Wall -g -Wextra

build: main

main: main.o operations.o extras.o
	$(CC) -o main $^ 

main.o: main.c
	$(CC) $(CFLAGS) -c $^

operations.o: operations.c
	$(CC) $(CFLAGS) -c $^

extras.o: extras.c
	$(CC) $(CFLAGS) -c $^

run: build
	./main

clean:
	rm -f *.o main