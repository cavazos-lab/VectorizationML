CC=gcc
CXX=g++
LEX=flex
YACC=yacc
LINK.o=$(LINK.cc)

CPPFLAGS=
CFLAGS=-O3 -std=c99
CXXFLAGS=-O3
YFLAGS=-d

LDLIBS=-lfl

.SUFFIXES: .c .o .l .y

translator : tokenizer.o parser.o pragma_information.o translator.o

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
