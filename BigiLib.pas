{ Big integer library v2     }
{ Turbo Pascal 3.01A, CP/M   }
{ Tim Holyoake, August 2023  }

{ Turbo Pascal CP/M compiler directives to allow recursive calls }
{ and turn off argument bounds checking to function calls        }
{$A-}
{$V-}

{ Global declarations }

const MAXLEN = 25;              { Maximum length of a BigInt, including sign }
const ORD0 = 48;                { ord('0') }
const ORD0PLUSORD9 = 105;       { ord('0') + ord('9') }
const FULLMAX = '32767';        { MAXINT as a BigInt }
const NEARMAX = '32766';        { MAXINT-1 as a BigInt }
const HALFMAX = '16383';        { Half of MAXINT-1 as a BigInt }
const SAFELEN = 4;              { length(MAXINT) - 1 }

type BigInt = string[MAXLEN];

{ Forward references - note TP requires the actual function NOT to }
{ have the parameters declared - different to native FreePascal.   }

function add(num1: BigInt; num2: BigInt): BigInt; Forward;
function sub(num1: BigInt; num2: BigInt): BigInt; Forward;
function multiply(num1: BigInt; num2: BigInt): BigInt; Forward;
function lt(num1: BigInt; num2: BigInt): Boolean; Forward;

{ *** Internal Library Functions and Procedures *** }

{ Karatsuba multiplication - recursive function }
function karatsuba(x: BigInt; y: BigInt): BigInt;
var i, hx, hy, posx: Integer;
    part1, part2, part3, xl, xr, yl, yr, t1, t2: BigInt;
begin
  hx := length(x);
  hy := length(y);

  { Zap any unwanted leading zeros - recursive entries may have them }
  if (hx > 1) and (x[1]='0') then
  begin
    i := 1;
    while (x[i]='0') and (i < hx) do
      i := i+1;
    x := copy(x,i,hx+1-i);
    hx := length(x)
  end;
  if (hy > 1) and (y[1]='0') then
  begin
    i := 1;
    while (y[i]='0') and (i < hy) do
      i := i+1;
    y := copy(y,i,hy+1-i);
    hy := length(y)
  end;

  if (hx+hy) < SAFELEN then { Can safely multiply - return result }
  begin                     { Standard karatsuba assumes only }
    val(x,hx,i);            { single digits are safe }
    val(y,hy,i);
    str(hx*hy,part1);
    karatsuba := part1
  end
  else
  begin
    if hx > hy then
      for i := 1 to hx-hy do
        insert('0',y,1)
    else
      for i := 1 to hy-hx do
        insert('0',x,1);

    if odd(length(x)) then
    begin
      insert('0',x,1);
      insert('0',y,1)
    end;

    posx := length(x);
    hx := posx div 2;
    hy := length(y) div 2;
    xl := copy(x,1,hx);
    xr := copy(x,1+hx,255);
    yl := copy(y,1,hy);
    yr := copy(y,1+hy,255);

    t1 := add(xl,xr);
    t2 := add(yl,yr);

    part1 := karatsuba(xl,yl);
    part2 := karatsuba(t1,t2);
    part3 := karatsuba(xr,yr);

    t1 := sub(part2,part1);
    t2 := sub(t1,part3);

    for i := 1 to (posx div 2) do
      t2 := t2 + '0';
    t1 := part1;
    for i := 1 to posx do
      t1 := t1 + '0';

    karatsuba := add(add(t1,t2),part3)
  end
end;

{ Fast(er) divide procedure (than repeated subtraction) }
var quott,remt: BigInt; { Used as var parameters so can't be declared  }
                        { locally in fastdiv - see TP 3.0 reference manual }
procedure fastdiv(num: BigInt; den: BigInt; var quot: BigInt; var rem: BigInt);
var dent: BigInt;
    quoti, remti, deni, i: Integer;
begin
  if lt(num,den) then
  begin
    quot := '0';
    rem := num
  end
  else
  begin
    if lt(den,HALFMAX) then      { Can safely use Integer arithmetic }
    begin
      val(den,deni,i);
      str(deni*2,dent)
    end
    else
      dent := karatsuba(den,'2');

    fastdiv(num,dent,quott,remt);

    if lt(remt,den) then
    begin
      if lt(quott,HALFMAX) then
      begin
        val(quott,quoti,i);
        str(quoti*2,quot)
      end
      else
        quot := karatsuba(quott,'2');
      rem := remt
    end
    else
    begin
      if lt(quott,HALFMAX) then
      begin
        val(quott,quoti,i);
        str(quoti*2,quot)
      end
      else
        quot := karatsuba(quott,'2');

      if lt(quot,NEARMAX) then
      begin
        val(quot,quoti,i);
        str(quoti+1,quot)
      end
      else
        quot := add(quot, '1');

      if ((length(remt) <= SAFELEN) and (length(den) <= SAFELEN)) or
         ((length(remt) = SAFELEN+1) and (remt <= FULLMAX ) and (length(den) <= SAFELEN)) or
         ((length(den) = SAFELEN+1) and (den <= FULLMAX ) and (length(remt) <= SAFELEN)) then
      begin
        val(remt,remti,i);
        val(den,deni,i);
        str(remti-deni,dent);
        rem := dent
      end
      else
        rem := sub(remt,den)
    end
  end
end;

{ *** Big Integer Library Functions *** }

{ Equal to }
function eq(num1: BigInt; num2: BigInt): Boolean;
begin
  eq := (num1=num2)
end;

{ Not equal to }
function ne(num1: BigInt; num2: BigInt): Boolean;
begin
  ne := (num1<>num2)
end;

{ Greater than }
function gt(num1: BigInt; num2: BigInt): Boolean;
begin
  if ((num1[1]='-') and (num2[1]<>'-')) then
    gt := FALSE
  else
  if ((num1[1]<>'-') and (num2[1]='-')) then
    gt := TRUE
  else
  if (num1[1]='-') and (num2[1]='-') then
  begin
    delete(num1,1,1);
    delete(num2,1,1);
    if (length(num1) = length(num2)) then
      gt := num2 > num1
    else
      gt := length(num2) > length(num1)
  end
  else
  if (length(num1) = length(num2)) then
    gt := num1 > num2
  else
    gt := length(num1) > length(num2)
end;

{ Greater than or equal to }
function ge(num1: BigInt; num2: BigInt): Boolean;
begin
  ge := gt(num1,num2) or (num1=num2)
end;

{ Less than - forward referenced }
function lt;
begin
  if ((num1[1]<>'-') and (num2[1]='-')) then
    lt := FALSE
  else
  if ((num1[1]='-') and (num2[1]<>'-')) then
    lt := TRUE
  else
  if (num1[1]='-') and (num2[1]='-') then
  begin
    delete(num1,1,1);
    delete(num2,1,1);
    if (length(num1) = length(num2)) then
      lt := num2 < num1
    else
      lt := length(num2) < length(num1)
  end
  else
    if (length(num1) = length(num2)) then
      lt := num1 < num2
    else
      lt := length(num1) < length(num2)
end;

{ Less than or equal to }
function le(num1: BigInt; num2: BigInt): Boolean;
begin
  le := lt(num1,num2) or (num1=num2)
end;

{ Subtraction - forward referenced }
function sub;
var i, t1i, t2i: Integer;
    out, temp1, temp2, temp3: BigInt;
    neg: Boolean;
begin
  if (length(num1) <= SAFELEN) and (length(num2) <=SAFELEN) then
  { Safe for integer subtraction }
  begin
    val(num1,t1i,i);
    val(num2,t2i,i);
    str(t1i-t2i,out);
    sub := out;
    exit
  end;

  out :='';
  neg := FALSE;  { Used if both operands have the same sign }
  { If one operand is negative, this is addition }
  if (num1[1]<>'-') and (num2[1]='-') then
  begin
    delete(num2,1,1);
    out := add(num1,num2)
  end
  else
  if (num1[1]='-') and (num2[1]<>'-') then
  begin
    delete(num1,1,1);
    out := add(num1,num2);
    insert('-',out,1)
  end;

  { If out is still empty, then operands are of the same sign }
  if out = '' then
  begin
    { Reverse operands and negate if both are negative }
    if (num1[1]='-') and (num2[1]='-') then
    begin
      { Swap the operands over and make them both positive }
      temp1 := num2;
      num2 := num1;
      num1 := temp1;
      delete(num1,1,1);
      delete(num2,1,1)
    end;

    { Subtraction using complements - current num1 > num2 }
    if gt(num1,num2) then
    begin
      temp1 := '';
      for i := 1 to length(num1) do
        insert(chr(ORD0PLUSORD9-ord(num1[i])),temp1,i);
      num1 := temp1;
      temp1 := add(num1,num2);
      if length(temp1) < length(num1) then
        for i := 1 to length(num1)-length(temp1) do
          insert('0',temp1,1);
      for i := 1 to length(temp1) do
        insert(chr(ORD0PLUSORD9-ord(temp1[i])),out,i)
    end
    else
    if gt(num2,num1) then
    begin
      neg := TRUE;
      temp1 := '';
      temp2 := '';
      temp3 := '';
      for i := 1 to length(num2) do
        insert(chr(ORD0PLUSORD9-ord(num2[i])),temp2,i);
      temp2 := add(num1,temp2);
      temp2 := add('1',temp2);
      for i := 1 to length(temp2) do
        insert('0',temp1,1);
      insert('1',temp1,1);
      for i := 1 to length(temp1) do
        insert(chr(ORD0PLUSORD9-ord(temp1[i])),temp3,i);
      out := add(temp3,temp2);
      if length(out) < length(temp3) then
        for i := 1 to length(temp3)-length(out) do
          insert('0',out,1);
      temp1 := '';
      for i := 1 to length(out) do
        insert(chr(ORD0PLUSORD9-ord(out[i])),temp1,i);
      out := temp1
    end
      else
        out := '0';

    { Zap leading zeros and deal with a negative result }
    if (length(out) > 1) and (out[1]='0') then
    begin
      i := 1;
      while (out[i]='0') and (i < length(out)) do
        i :=  i + 1;
      out := copy(out,i,length(out)+1-i)
    end;
    if (neg) then { Correct result if both operands have same sign }
      insert('-',out,1)
  end;
  sub := out
end;

{ Addition - forward referenced }
function add;
var len1, len2, lenmax, carry, ci, currnum, i, j: Integer;
    neg: Boolean;
    out: BigInt;
begin
  len1 := length(num1);
  len2 := length(num2);
  if len1 > len2 then
    lenmax := len1+1
  else
    lenmax := len2+1;
  if (lenmax > MAXLEN) or (lenmax < 2) then
    out := 'NaN'
  else
  if (len1 <= SAFELEN) and (len2 <=SAFELEN) then { Safe for integer addition }
  begin
    val(num1,i,ci);
    val(num2,j,ci);
    str(i+j,out)
  end
  else
  begin
    out := '';
    neg := FALSE;
    { One number is negative - therefore subtraction }
    if (num1[1]='-') and (num2[1]<>'-') then
    begin
      delete(num1,1,1);
      out := sub(num2,num1)
    end;
    if (num1[1]<>'-') and (num2[1]='-') and (out='') then
    begin
      delete(num2,1,1);
      out := sub(num1,num2)
    end;
    { Both numbers negative - so add and invert sign }
    if (num1[1]='-') and (num2[1]='-') and (out = '') then
    begin
      delete(num1,1,1);
      delete(num2,1,1);
      len1 := length(num1);
      len2 := length(num2);
      if (len1 = 0) or (len2 = 0) then
        out := 'NaN'
      else
        neg := TRUE;
    end;
    { If out is still blank, then perform addition }
    if (out = '') then
    begin
      for i := 1 to lenmax do
        insert('0',out,1);
      j := lenmax;
      for i := len1 downto 1 do
      begin
        out[j] := num1[i];
        j := j-1
      end;
      j := lenmax;
      for i := len2 downto 1 do
      begin
        currnum := ord(num2[i])+ord(out[j])-2*ORD0;
        out[j] := chr((currnum mod 10)+ORD0);
        carry := currnum div 10;
        j := j-1;
        if carry > 0 then
          ci := j;
        while carry > 0 do
        begin
          currnum := ord(out[ci])-ORD0+carry;
          carry := currnum div 10;
          out[ci] := chr((currnum mod 10)+ORD0);
          ci := ci -1
        end { carry loop }
      end; { i loop }
      if (length(out) > 1) and (out[1]='0') then
      { Zap all leading zeros }
      begin
        i := 1;
        while (out[i]='0') and (i < length(out)) do
          i :=  i + 1;
        out := copy(out,i,length(out)+1-i)
      end;
      { Don't use a negative sign if result was 0 }
      if (neg) and (out<>'0') then
        insert('-',out,1)
    end
  end;
  add := out
end;

{ Multiplication - forward referenced }
function multiply;
var neg: Boolean;
    x, y, i: Integer;
    out: BigInt;
begin
  x := length(num1);
  y := length(num2);
  if (x+y) <= SAFELEN then
  begin
    val(num1,x,i);
    val(num2,y,i);
    str(x*y,out);
    multiply := out
  end
  else
  begin
    neg := FALSE;
    if (x+y) > MAXLEN then
      multiply := 'NaN'
    else
    begin
      if num1[1]='-' then
      begin
        neg := TRUE;
        delete(num1,1,1)
      end;
      if num2[1]='-' then
      begin
        neg := not(neg);
        delete(num2,1,1)
      end;
      out := karatsuba(num1,num2);
      if (neg) and (out<>'0') then
        insert('-',out,1);
      multiply := out
    end
  end
end;

{ Division }
function divide(num: BigInt; den: BigInt): BigInt;
var n, d, i: Integer;
    quotient, remainder: BigInt;
    neg: Boolean;
begin
  neg := FALSE;
  if num[1]='-' then
  begin
    neg := TRUE;
    delete(num,1,1)
  end;
  if den[1]='-' then
  begin
    neg := not(neg);
    delete(den,1,1)
  end;
  if den='0' then
    divide := 'NaN'
  else
  begin
    if lt(num,FULLMAX) and lt(den,FULLMAX) then
    begin
      val(num,n,i);
      val(den,d,i);
      str(n div d,quotient)
    end
    else
    begin
      fastdiv(num,den,quotient,remainder);
      if (length(quotient) > 1) and (quotient[1]='0') then
      begin
        i := 1;
        while (quotient[i]='0') and (i < length(quotient)) do
          i :=  i + 1;
        quotient := copy(quotient,i,length(quotient)+1-i)
      end
    end;
    if (neg) and (quotient<>'0') then
      insert('-',quotient,1);
    divide := quotient
  end
end;

{ Modulo  - implements the same definition as TP3.01A }
function modulo(num: BigInt; den: BigInt): BigInt;
var n, d, i: Integer;
    quotient, remainder: BigInt;
    neg: Boolean;
begin
  neg := FALSE;
  if num[1]='-' then
  begin
    neg := TRUE;
    delete(num,1,1)
  end;
  if den[1]='-' then
    delete(den,1,1);
  if den='0' then
    modulo := 'NaN'
  else
  begin
    if lt(num,FULLMAX) and lt(den,FULLMAX) then
    begin
      val(num,n,i);
      val(den,d,i);
      str(n mod d,remainder)
    end
    else
    begin
      fastdiv(num,den,quotient,remainder);
      if (length(remainder)>1) and (remainder[1]='0') then
      begin
        i := 1;
        while (remainder[i]='0') and (i < length(remainder)) do
          i :=  i + 1;
        remainder := copy(remainder,i,length(remainder)+1-i)
      end
    end;
    if (neg) and (remainder<>'0') then
      insert('-',remainder,1);
    modulo := remainder
  end
end;

{ Square root }
function isqrt(num: BigInt): BigInt;
var x, y, z : BigInt;
var i, j: Integer;
begin
  if (num[1]='-') then
    x := 'NaN'
  else
  if le(num,FULLMAX) then
  begin
    val(num,i,j);
    str(trunc(sqrt(i)),x)
  end
  else
  begin
    i := length(num);
    if odd(i) then
      if i=5 then
        z := '180'
      else
      begin
        z := '999';
        j := i div 2 - 3;
        while j > 0 do
        begin
          insert('9',z,1);
          j := j - 1
        end
      end
    else
    begin
      z := '316';
      j := i div 2 - 3;
      while j > 0 do
      begin
        z := z + '0';
        j := j - 1
      end
    end;
    x := divide(num,z);
    y := divide(add(x,divide(num,x)),'2');
    while lt(y,x) do
    begin
      x := y;
      y := divide(add(x,divide(num,x)),'2')
    end
  end;
  isqrt := x
end;
