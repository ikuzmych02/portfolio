/**
 * Interactive calculator for expressions with fractional numerbers.
 * CSE 374, 21sp, muh after HP
 */

#include <iostream>
#include <string>

#include "Parser.h"
#include "Rational.h"
#include "Scanner.h"

using std::cout;
using std::endl;
using std::cin;
using std::string;

// Print rational r followed by a newline
void prrat(Rational374::Rational r) {
  cout << r.n() << "/" << r.d() << endl;
}

// Read and print expressions until eof
int main() {
  Rational374::Scanner scanner;
  Rational374::Parser parser(&scanner);
  string inputLine;
  cout << "Enter expressions with integer rational numerbers (n/d) and"
            << endl;
  cout << "the operations +, -, *, and %.  One line per expression."
            << endl;
  cout << "Enter eof (cntrl-D) to stop." << endl;
  while (getline(cin, inputLine)) {
    scanner.setInput(inputLine);
    prrat(parser.expr());
  }

  return 0;
}
