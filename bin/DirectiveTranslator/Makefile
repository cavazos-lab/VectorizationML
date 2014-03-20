CC=clang
LEX=flex
YACC=yacc

CPPFLAGS=-std=c99
CFLAGS=-O3
YFLAGS=-d

LDLIBS=-lfl

.SUFFIXES: .c .o .l .y

translator : tokenizer.o parser.o pragma_information.o option_printer.o translator.o

tokenizer.o : parser.o

%.o : %.y

%.o : %.l

.PHONY: clean veryclean tidy

clean:
	@rm -v -f *.o

veryclean : clean
	@rm -v -f y.tab.h

tidy: veryclean
	@rm -v -f translator
