# PascalBigIntegers
## Big Integer library and test programs for Turbo Pascal 3.01A, CP/M.

Big Integers are a user defined type (BigInt) based on Turbo Pascal Strings.

You can set the maximum length of a BigInt by altering the MAXLEN
constant in the library (BigiLib.pas). This must not exceed the maximum
allowed string length of 255.

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
a Raspberry Pi using Buster or Bullseye), use the -Mtp compiler flag.

For example, **fpc -Mtp BigPrime.pas** 

## Test programs

**BigTest.pas** - a harness to check the correctness of each library function

**BigPrime.pas** - a sieve of Eratosthenes prime number generator

## Bugs and Improvements

The library does no checking on the validity of BigInts used as function arguments. An
earlier version included an internal fucntion to do this, but doubled the time taken for
the prime numbers between 1 and 100 to be calcuated, so was removed. 

The assumption now made is that all digits of a BigInt are in the set [0..9] except for the 
first position in the string, which may also be a '-'. Any BigInt arguments that do not conform
to this pattern may give unpredictable results.

The algorithms used are naive - for example, multiplication is an O(n^2) algorithm as it is 
based on a manual pencil and paper method. Better algorithms, such as Karatsuba-Comba, should
improve the efficiency of the library if implemented.
