{ Big integer prime number test harness }
{ Turbo Pascal 3.01A, CP/M              }
{ Tim Holyoake, May 2023                }

program bigprimes(output);

{ Include the library }
{$I BIGILIB.PAS}

{ *** Test harness begins ***}

type Primea = array [1..255] of BigInt;

function sieve(var number: BigInt; var pc: integer; var p: primea): boolean;
var count :Integer;
var sr, test :BigInt;
var foundprime :Boolean;
begin
  sr := isqrt(number);
  count := 1;
  foundprime := TRUE;
  while ((count <= pc) and foundprime) do begin
    test := p[count];
    if le(test,sr) and (modulo(number,test)='0') then
      foundprime := FALSE;
    count := count+1
  end;
  sieve := foundprime
end;

var primearray: Primea;
    limit, next: BigInt;
    primecount : Integer;
begin
   limit := '100';
   primecount := 0;
   next := '3';
   write('2');
   while (le(next,limit)) do
   begin
     if sieve(next,primecount,primearray) then
     begin
       if primecount < 255 then
       begin
         primecount := primecount+1;
         primearray[primecount] := next
       end;
       write(', ',next)
     end;
     next := add(next,'2')
   end;
   writeln(' ')
end.
