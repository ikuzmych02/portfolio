# Illya Kuzmych
# CSE 374. HW7. 22wi
# Makefile Rational 

CPP = g++

CPPFLAGS = -Wall -std=c++11

all: rcalc

rcalc: Calc.o Parser.o Rational.o Scanner.o
	$(CPP) $(CPPFLAGS) -o rcalc Calc.o Parser.o Rational.o Scanner.o

## complete the following targets below
## add the dependcies, both cpp and h files
## add command line
Rational.o: Rational.cpp Rational.h
	$(CPP) $(CPPFLAGS) -c Rational.cpp

Scanner.o: Scanner.cpp Scanner.h
	$(CPP) $(CPPFLAGS) -c Scanner.cpp

Parser.o: Parser.cpp Parser.h Rational.h Scanner.h Token.h
	$(CPP) $(CPPFLAGS) -c Parser.cpp

Calc.o: Calc.cpp Parser.h Rational.h Scanner.h
	$(CPP) $(CPPFLAGS) -c Calc.cpp

debug: CPPFLAGS += -g
debug: rcalc

# clean up the working directory
clean:
	rm -f *.o rcalc *~