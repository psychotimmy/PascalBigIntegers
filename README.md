# PascalBigIntegers
Big Integer library and test programs for Turbo Pascal 3.01A, CP/M.

Big Integers are a user defined type (BigInt) based on Turbo Pascal Strings.

You can set the maximum length of a BigInt by altering the MAXLEN
constant in the library (Bigilib.pas). This must not exceed the maximum
allowed string length of 255.

The library supports the use of positive and negative integers. Using a
unary minus in front of a BigInt means that only MAXLEN-1 digits are available.

The following functions are included in the library.

add(BigInt1, BigInt2) - Addition

sub(BigInt1, BigInt2) - Subtract BigInt2 from BigInt1

multiply(BigInt1, BigInt2) - Multiplication

divide(BigInt1, BigInt2) - Integer division of BigInt1 by BigInt2

modulo(BigInt1, BigInt2) - Modulo of BigInt1 when divided by BigInt2

isqrt(BigInt) - Integer sqaure root of BigInt
eq(BigInt1, BigInt2) - True if BigInt1 is equal to BigInt2

ne(BigInt1, BigInt2) - True if BigInt1 is not equal to BigInt2

lt(BigInt1, BigInt2) - True if BigInt1 is less than BigInt2

le(BigInt1, BigInt2) - True is BigInt1 is less than or equal to BigInt2

gt(BigInt1, BigInt2) - True if BigInt1 is greater than BigInt2

ge(BigInt1, BigInt2) - True is BigInt1 is greater than or equal to BigInt2

The library file is Bigilib.pas. 
To use it, your program must include it after the declaration, e.g.

program bigtest(output);
{$I BIGILIB.PAS}

The test programs are:

Bigtest.pas - a harness to check the correctness of each library function

Bigprime.pas - a sieve of Eratosthenes prime number generator

As the library is large by CP/M standards it is recommended that the option to produce COM
output is selected in the compiler, otherwise it is likely any non-trivial program will 
run out of space.
