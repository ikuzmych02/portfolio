/**
 * Header file for Rational 
 * HW7. CSE 374. 22wi
 */

#ifndef RATIONAL_H
#define RATIONAL_H

namespace Rational374 {

class Rational {
 public:
  // ----------- CONSTRUCTORS -----------
  // Construct Rational 0/1
  Rational();

  // Construct Rational n / 1
  explicit Rational(int n);

  // Construct Rational n / d
  Rational(int n, int d);

  // ----------- ACCESSORS -----------
  // Return the numerator and denominator of this Rational.
  // Results are in lowest terms (i.e., for rational r, r.n() and r.d()
  // have no common integer divisors greater than 1).
  // 'const' specifies that attributes are not changed by the function.
  int n() const;
  int d() const;


  // ----------- ARITHMETIC -----------
  // Return a new Rational that results from combining this Rational
  // with another.  Neither operand is changed.

  // = this + other
  Rational plus(Rational other) const;

  // = this - other
  Rational minus(Rational other) const;

  // = this * other
  Rational times(Rational other) const;

  // = this / other
  Rational div(Rational other) const;

 private:
  // Representation of a Rational: numer/denom
  // No attempt is made to detect a denominator of 0 as an error
  int numer_;
  int denom_;
};

}  // namespace Rational374

#endif
