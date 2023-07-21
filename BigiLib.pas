{ Big integer library v2   }
{ Turbo Pascal 3.01A, CP/M }
{ Tim Holyoake, July 2023  }

{ Turbo Pascal CP/M compiler directives to allow recursive calls }
{ and turn off argument bounds checking to function calls        }
{$A-}
{$V-}

{ Global declarations }

const MAXLEN = 50;              { Maximum length of a BigInt, including sign }
type BigInt = string[MAXLEN];
const ORD0 = 48;                { ord('0') }
const ORD0PLUSORD9 = 105;       { ord('0') + ord('9') }
const FULLMAX = '32766';        { MAXINT-1 as a BigInt }
const HALFMAX = '16383';	{ Half of MAXINT-1 as a BigInt }
const SAFELEN = 4;              { length(MAXINT) - 1 }

{ Forward references - note TP requires the actual function NOT to }
{ have the parameters declared - different to native FreePascal.   }

function add(num1: BigInt; num2: BigInt): BigInt; Forward;
function sub(num1: BigInt; num2: BigInt): BigInt; Forward;
function multiply(num1: BigInt; num2: BigInt): BigInt; Forward;
function lt(num1: BigInt; num2: BigInt): Boolean; Forward;

{ *** Internal Library Functions and Procedures *** }

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
      i := deni*2;
      str(i,dent)
    end
    else
      dent := multiply(den,'2');

    fastdiv(num,dent,quott,remt);

    if lt(remt,den) then
    begin
      if lt(quott,HALFMAX) then
      begin
        val(quott,quoti,i);
        i := quoti*2;
        str(i,quot)
      end
      else
        quot := multiply(quott,'2');
      rem := remt
    end
    else
    begin
      if lt(quott,HALFMAX) then
      begin
        val(quott,quoti,i);
        i := quoti*2;
        str(i,quot)
      end
      else
        quot := multiply(quott,'2');

      if lt(quot,FULLMAX) then
      begin
        val(quot,quoti,i);
        i := quoti+1;
        str(i,quot)
      end
      else
        quot := add(quot, '1');

      if (length(remt)<=SAFELEN) and (length(den)<=SAFELEN) then
      begin
        val(remt,remti,i);
        val(den,deni,i);
        i := remti-deni;
        str(i,dent);
        rem := dent
      end
      else
        rem := sub(remt,den)
    end
  end
end;

{ Karatsuba multiplication - recursive function }
function karatsuba(x: BigInt; y: BigInt): BigInt;
var i, hx, hy, pos: Integer;
    part1, part2, part3, xl, xr, yl, yr, t1, t2, t3: BigInt;
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

  if (hx = 1) and (hy = 1) then { Single digits - return result }
  begin
    i := (ord(x[1])-ORD0)*(ord(y[1])-ORD0);
    str(i,part1);
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

    if (length(x) mod 2) <> 0 then
    begin
      insert('0',x,1);
      insert('0',y,1)
    end;  

    pos := length(x);
    hx := pos div 2;
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

    for i := 1 to (pos div 2) do
      t2 := t2 + '0';
    t1 := part1;
    for i := 1 to pos do
      t1 := t1 + '0';

    t3 := add(t1,t2);

    karatsuba := add(t3,part3)
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
var len1, len2, i: Integer;
    tgt: Boolean;
    temp: Bigint;
    found: Boolean;
begin
  if (length(num1) <= SAFELEN) and (length(num2) <= SAFELEN) then
  begin
    val(num1,len1,i);
    val(num2,len2,i);
    tgt := len1 > len2
  end
  else
  begin
    len1 := length(num1);
    len2 := length(num2);
    begin
      if ((num1[len1]='-') and (num2[len2]<>'-')) then
        tgt := FALSE
      else
      if ((num1[len1]<>'-') and (num2[len2]='-')) then
        tgt := TRUE
      else
      begin
        if (num1[len1]='-') and (num2[len2]='-') then
        begin
          delete(num1,1,1);
          delete(num2,1,1);
          temp := num1;
          num1 := num2;
          num2 := temp;
          len1 := len2-1;
          len2 := len1-1
        end;
        if (len1 > len2) then
          for i := 1 to len1-len2 do
            insert('0',num2,1);
        if (len2 > len1) then
          for i := 1 to len2-len1 do
            insert('0',num1,1);
        tgt := FALSE;
        found := FALSE;
        i := 1;
        while (i <= length(num1)) and (found = FALSE) do
        begin
          if (num1[i]>num2[i]) then
          begin
            found := TRUE;
            tgt := TRUE
          end;
          if (num1[i]<num2[i]) then
            found := TRUE;
          i := i+1
        end
      end
    end
  end;
  gt := tgt
end;

{ Greater than or equal to }
function ge(num1: BigInt; num2: BigInt): Boolean;
begin
  ge := gt(num1,num2) or (num1=num2)
end;

{ Less than - forward referenced }
function lt;
var len1, len2, i: Integer;
    temp: BigInt;
    found, tlt: Boolean;
begin
  if (length(num1) <= SAFELEN) and (length(num2) <= SAFELEN) then
  begin
    val(num1,len1,i);
    val(num2,len2,i);
    tlt := len1 < len2
  end
  else
  begin
    len1 := length(num1);
    len2 := length(num2);
    begin
      if ((num1[len1]='-') and (num2[len2]<>'-')) then
        tlt := TRUE
      else
      if ((num1[len1]<>'-') and (num2[len2]='-')) then
        tlt := FALSE
      else
      begin
        if (num1[len1]='-') and (num2[len2]='-') then
        begin
          delete(num1,1,1);
          delete(num2,1,1);
          temp := num1;
          num1 := num2;
          num2 := temp;
          len1 := len2 - 1;
          len2 := len1 - 1
        end;
        if (len1 > len2) then
          for i := 1 to len1-len2 do
            insert('0',num2,1);
        if (len2 > len1) then
          for i := 1 to len2-len1 do
            insert('0',num1,1);
        tlt := FALSE;
        found := FALSE;
        i := 1;
        while (i <= length(num1)) and (found = FALSE) do
        begin
          if (num1[i]<num2[i]) then
          begin
            found := TRUE;
            tlt := TRUE
          end;
          if (num1[i]>num2[i]) then
            found := TRUE;
          i := i+1
        end
      end
    end
  end;
  lt := tlt
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
begin
  if (length(num1) <= SAFELEN) and (length(num2) <=SAFELEN) then { Safe for integer subtraction }
  begin
    val(num1,t1i,i);
    val(num2,t2i,i);
    i := t1i-t2i;
    str(i,out)
  end 
  else
  begin
    out := '';
    if (num1[1]<>'-') and (num2[1]='-') and (out='') then
    begin
      delete(num2,1,1);
      out := add(num1,num2)
    end;
    if (num1[1]='-') and (num2[1]<>'-') and (out='') then
    begin
      delete(num1,1,1);
      out := add(num1,num2);
      insert('-',out,1)
    end;
    if (num1[1]='-') and (num2[1]='-') and (out='') then
    begin
      out := num1;
      num2 := num1;
      num1 := num2;
      delete(num1,1,1);
      out := ''
    end;
    if (out = '') then
    begin
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
      begin
        if gt(num2,num1) then
        begin
          temp1 := '';
          temp2 := '';
          temp3 := '';
          for i := 1 to length(num2) do
            insert(chr(ORD0PLUSORD9-ord(num2[i])),temp2,i);
          num2 := temp2;
          temp2 := add(num1,num2);
          temp2 := add('1',temp2);
          for i := 1 to length(num2) do
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
          out := temp1;
          if (length(out) > 1) and (out[1]='0') then
          begin
            i := 1;
            while (out[i]='0') and (i < length(out)) do
              i :=  i + 1;
            out := copy(out,i,length(out)+1-i)
          end;
          insert('-',out,1)
        end
        else
        begin
          out := '0'
        end
      end
    end;
    if (length(out) > 1) and (out[1]='0') then
    begin
      i := 1;
      while (out[i]='0') and (i < length(out)) do
        i :=  i + 1;
      out := copy(out,i,length(out)+1-i)
    end
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
  if (len1 <= SAFELEN) and (len2 <=SAFELEN) then { Safe for integer addition }
  begin
    val(num1,len1,i);
    val(num2,len2,i);
    i := len1+len2;
    str(i,out)
  end 
  else
  begin
    out := '';
    neg := FALSE;
    if len1 > len2 then
      lenmax := len1+1
    else
      lenmax := len2+1;
    if (lenmax>MAXLEN) then
      out := 'NaN';
    if (num1[1]='-') and (num2[1]<>'-') and (out='') then
    begin
      delete(num1,1,1);
      out := sub(num2,num1)
    end;
    if (num1[1]<>'-') and (num2[1]='-') and (out='') then
    begin
      delete(num2,1,1);
      out := sub(num1,num2)
    end;
    if (num1[1]='-') and (num2[1]='-') then
    begin
      neg := TRUE;
      delete(num1,1,1);
      delete(num2,1,1);
      len1 := length(num1);
      len2 := length(num2);
      if (len1 = 0) or (len2 = 0) then
        out := 'NaN'
    end;
    if (out = '') then
    begin
      for i := 1 to lenmax do
        insert('0',out,i);
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
      begin
        i := 1;
        while (out[i]='0') and (i < length(out)) do
          i :=  i + 1;
        out := copy(out,i,length(out)+1-i)
      end;
      if (neg) and (out<>'0') then
        insert('-',out,1)
    end
  end;
  add := out
end;

{ Multiplication - forward referenced }
function multiply;
var neg: Boolean;
    out: BigInt;
begin
  neg := FALSE;
  if (length(num1)+length(num2))>MAXLEN then
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
end;

{ Division }
function divide(num: BigInt; den: BigInt): BigInt;
var len1, len2, i: Integer;
    quotient, remainder: BigInt;
    neg: Boolean;
begin
  len1 := length(num);
  len2 := length(den);
  neg := FALSE;
  if num[1]='-' then
  begin
    neg := TRUE;
    delete(num,1,1);
    len1 := len1-1
  end;
  if den[1]='-' then
  begin
    neg := not(neg);
    delete(den,1,1);
    len2 := len2-1
  end;
  if den='0' then
    divide := 'NaN'
  else
  begin
    if lt(num,FULLMAX) and lt(den,FULLMAX) then
    begin
      val(num,len1,i);
      val(den,len2,i);
      i := len1 div len2;
      str(i,quotient)
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
var len1, len2, i: Integer;
    quotient, remainder: BigInt;
    neg: Boolean;
begin
  len1 := length(num);
  len2 := length(den);
  neg := FALSE;
  if num[1]='-' then
  begin
    neg := TRUE;
    delete(num,1,1);
    len1 := len1-1
  end;
  if den[1]='-' then
  begin
    delete(den,1,1);
    len2 := len2-1
  end;
  if den='0' then
    modulo := 'NaN'
  else
  begin
    if lt(num,FULLMAX) and lt(den,FULLMAX) then
    begin
      val(num,len1,i);
      val(den,len2,i);
      i := len1 mod len2;
      str(i,remainder)
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
var t0, t1: BigInt;
begin
  if (num[1]='-') then
    t0 := 'NaN'
  else
  begin
    t0 := divide(num,'2');
    t1 := divide(num,t0);
    t1 := add(t0,t1);
    t1 := divide(t1,'2');

    while lt(t1,t0) do
    begin
      t0 := t1;
      t1 := divide(num,t0);
      t1 := add(t0,t1);
      t1 := divide(t1,'2');
    end { while }
  end;
  isqrt := t0
end;
