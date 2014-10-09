CFLAGS := $(CFLAGS) -std=c99 

shell: main.c exec.o shellparser.o shellscanner.o
	$(CC) -o shell main.c exec.o shellparser.o shellscanner.o

exec.o: exec.h exec.c

shellparser.o: shellparser.h shellparser.c exec.o

shellparser.h shellparser.c: shellparser.y exec.h lemon
	./lemon shellparser.y

shellscanner.o: shellscanner.h

shellscanner.h: shellscanner.l
	flex --outfile=shellscanner.c --header-file=shellscanner.h shellscanner.l

# Prevent yacc from trying to build parsers.
# http://stackoverflow.com/a/5395195/79202
%.c: %.y

lemon: lemon.c
	$(CC) -o lemon lemon.c

.PHONY: clean
clean:
	rm -f *.o
	rm -f shellscanner.c shellscanner.h
	rm -f shellparser.c shellparser.h shellparser.out
	rm -f shell lemon
