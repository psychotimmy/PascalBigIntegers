# PascalBigIntegers
## Big Integer library and test programs for Turbo Pascal 3.01A, CP/M.

Big Integers are a user defined type (BigInt) based on Turbo Pascal Strings.

The maximum length of a BigInt is set by altering the MAXLEN
constant in the library (BigiLib.pas). This must not exceed the maximum
allowed string length of 255. This is currently set to 50 in version 2.

Significant performance improvements made over version 1:

  - Modified karatsuba multiplication algorithm implemented
  - lt, gt, eq and ne functions simplified as they are mostly string comparisons
  - add/sub/fastdiv/karatsuba/multiply/divide/isqrt functions check to see if
    standard integers can be used for calculations instead of always using
    big integer algorithms
  - Inlined all internal functions (e.g zapzeros, nines complement) to improve speed
    at the cost of slight downgrades in code readability and maintainability

The library supports the use of positive and negative integers. Using a
unary minus in front of a BigInt means that only MAXLEN-1 digits are available.

## Library functions

**add(BigInt1, BigInt2)** - Addition

**sub(BigInt1, BigInt2)** - Subtract BigInt2 from BigInt1

**multiply(BigInt1, BigInt2)** - Multiplication

**divide(BigInt1, BigInt2)** - Integer division of BigInt1 by BigInt2

**modulo(BigInt1, BigInt2)** - BigInt1 modulo BigInt2

**isqrt(BigInt)** - Integer sqaure root of BigInt

**eq(BigInt1, BigInt2)** - True if BigInt1 is equal to BigInt2

**ne(BigInt1, BigInt2)** - True if BigInt1 is not equal to BigInt2

**lt(BigInt1, BigInt2)** - True if BigInt1 is less than BigInt2

**le(BigInt1, BigInt2)** - True if BigInt1 is less than or equal to BigInt2

**gt(BigInt1, BigInt2)** - True if BigInt1 is greater than BigInt2

**ge(BigInt1, BigInt2)** - True if BigInt1 is greater than or equal to BigInt2

## Usage

The library file is **BigiLib.pas** 

To use it, your program must include it after the declaration, e.g.

program bigtest(output);

{$I BIGILIB.PAS}

As the library is large by CP/M standards it is recommended that the option to produce COM
output is selected in the compiler, otherwise it is likely any non-trivial program will 
run out of space.

To compile the library and test programs unaltered under Free Pascal 3.0.4 and 3.2 (for example, on
a Raspberry Pi using Buster or Bullseye), you **must** use the -Mtp compiler flag.

For example, **fpc -Mtp BigPrime.pas** 

## Test programs

**BigTest.pas** - an incomplete harness to check the correctness of each library function

**BigPrime.pas** - a sieve of Eratosthenes prime number generator

## Bugs and Improvements

The library does no checking on the validity of BigInts used as function arguments. An
earlier version included an internal function to do this, but doubled the time taken for
the prime numbers between 1 and 100 to be calcuated, so was removed. 

The assumption now made is that all digits of a BigInt are in the set [0..9] except for the 
first position in the string, which may also be a '-'. Any BigInt arguments that do not conform
to this pattern will give unpredictable results.

While this library produces results at a reasonable speed on more modern hardware (such as a 2012 
Raspberry Pi B) you will need great patience to wait for results on a Z80 running CP/M 2.2 - the 
real target architecture! 
