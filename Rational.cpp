/* Illya Kuzmych
   HW7. CSE 374. 22wi
*/

// implements Rational class functions

#include "Rational.h"

// find greatest common denominator
int GCD(int a, int b);


// namespace based on
// starter code
namespace Rational374 {

  // constructors
  Rational::Rational() {
    // set default
    numer_ = 0;
    denom_ = 1;
  }
  Rational::Rational(int n) {
    // make n / 1
    numer_ = n;
    denom_ = 1;
  }
  Rational::Rational(int n, int d) {
    // if d is positive, make n / d
    if (d < 0) {
      n = 0 - n;
      d = 0 - d;
    }
    // to reduce the fraction
    int gcd = GCD(n, d);
    numer_ = n / gcd;
    denom_ = d / gcd;
  }

  // accessors to return numerator and denominator
  int Rational::n() const {
    return numer_;
  }
  int Rational::d() const {
    return denom_;
  }

  // multiply
  // return new Rational
  Rational Rational::times(Rational other) const {
    int newNumer = numer_ * other.n();
    int newDenom = denom_ * other.d();
    Rational result(newNumer, newDenom);
    return result;
  }

  // divide, return rational
  Rational Rational::div(Rational other) const {
    Rational inv(other.d(), other.n());
    return Rational::times(inv);
  }
  // add
  // return new rational
  Rational Rational::plus(Rational other) const {
    int newNumer = numer_ * other.d() + other.n() * denom_;
    int newDenom = denom_ * other.d();
    Rational result(newNumer, newDenom);
    return result;
  }

  // subtract
  // return new Rational
  Rational Rational::minus(Rational other) const {
    Rational neg((0 - other.n()), other.d());
    return Rational::plus(neg);
  }
}

// helper to return the greatest common denom of two vals
int GCD(int a, int b) {
  // check for zero values
  if (a == 0 && b == 0) {
    return 1;
  } else if (a == 0) {
    return b;
  } else if (b == 0) {
    return a;
  }
  // make #s positive

  if (a < 0) {
    a = 0 - a;
  }
  if (b < 0) {
    b = 0 - b;
  }
  // to find greatest common denom
  int result;
  for (int i = 1; i <= a && i <= b; i++) {
    if (a % i == 0 && b % i == 0) {
      result = i;
    }
  }
  return result;
}
