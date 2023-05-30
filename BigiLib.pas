{ Big integer library v1   }
{ Turbo Pascal 3.01A, CP/M }
{ Tim Holyoake, May 2023   }

{ Turbo Pascal CP/M compiler directives to allow recursive calls }
{ and turn off argument bounds checking to function calls        }
{$A-}
{$V-}

{ Global declarations }

const MAXLEN = 10;
const ORD0 = 48;                 { ord('0') }
const ORD0PLUSORD9 = 105;        { ord('0') + ord('9') }
type BigInt = string[MAXLEN];

{ Forward references - note TP requires the actual function to }
{ NOT have the parameters declared - different to FreePascal   }

function add(num1: BigInt; num2: BigInt): BigInt; Forward;
function sub(num1: BigInt; num2: BigInt): BigInt; Forward;
function multiply(num1: BigInt; num2: BigInt): BigInt; Forward;
function lt(num1: BigInt; num2: BigInt): Boolean; Forward;

{ *** Internal Library Functions and Procedures *** }

{ Strip leading zeros from a BigInt }
function zapzeros(num: BigInt; len: Integer): BigInt;
var i: Integer;
begin
  i := 1;
  while (num[i]='0') and (i < len) do
    i :=  i + 1;
  zapzeros := copy(num,i,len+1-i)
end;

{ Nines' complement }
function nines(num: BigInt): BigInt;
var i: Integer;
    out: BigInt;
begin
  out := '';
  for i := 1 to length(num) do
    insert(chr(ORD0PLUSORD9-ord(num[i])),out,i);
  nines := out
end;

{ Fast(er) divide procedure (than repeated subtraction!) }
var quott, remt: BigInt; { Used as var parameters so can't be declared  }
                         { locally in fastdiv - see TP reference manual }
procedure fastdiv(num: BigInt; den: BigInt; var quot: BigInt; var rem: BigInt);
var dent: BigInt;
begin
  if lt(num,den) then
  begin
    quot := '0';
    rem := num
  end
  else
  begin
    dent := multiply(den,'2');
    fastdiv(num,dent,quott,remt);
    if lt(remt,den) then
    begin
      quot := multiply(quott,'2');
      rem := remt
    end
    else
    begin
      quot := multiply(quott,'2');
      quot := add(quot, '1');
      rem := sub(remt,den)
    end
  end
end;

{ *** Big Integer Library Functions *** }

{ Equal to }
function eq(num1: BigInt; num2: BigInt): Boolean;
var len1, len2, i: Integer;
    teq: Boolean;
begin
  len1 := length(num1);
  len2 := length(num2);
  begin
    if (num1[len1]='-') and (num2[len2]='-') then
    begin
      { Ignore the negative sign }
      delete(num1,1,1);
      delete(num2,1,1);
      len1 := len1 - 1;
      len2 := len2 - 1
    end
    else
    begin
      if ((num1[len1]='-') and (num2[len2]<>'-')) or
         ((num1[len1]<>'-') and (num2[len2]='-')) then
         teq := FALSE
      else
      begin
        if (len1 > len2) then
          for i := 1 to len1-len2 do
            insert('0',num2,1);
        if (len2 > len1) then
          for i := 1 to len2-len1 do
            insert('0',num1,1);
        teq := TRUE;
        i := 1;
        while (i <= length(num1)) and (teq = TRUE) do
        begin
          if (num1[i]<>num2[i]) then
            teq := FALSE;
          i := i+1
        end
      end
    end
  end;
  eq := teq
end;

{ Not equal to }
function ne(num1: BigInt; num2: BigInt): Boolean;
begin
  ne := not(eq(num1,num2))
end;

{ Greater than }
function gt(num1: BigInt; num2: BigInt): Boolean;
var len1, len2, i: Integer;
    tgt: Boolean;
    temp: Bigint;
    found: Boolean;
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
        len1 := len2 - 1;
        len2 := len1 - 1
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
        begin
          found := TRUE
        end;
        i := i+1
      end
    end
  end;
  gt := tgt
end;

{ Greater than or equal to }
function ge(num1: BigInt; num2: BigInt): Boolean;
begin
  ge := gt(num1,num2) or eq(num1,num2)
end;

{ Less than - forward referenced }
function lt;
var len1, len2, i: Integer;
    temp: BigInt;
    found, tlt: Boolean;
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
        begin
          found := TRUE
        end;
        i := i+1
      end
    end
  end;
  lt := tlt
end;

{ Less than or equal to }
function le(num1: BigInt; num2: BigInt): Boolean;
begin
  le := lt(num1,num2) or eq(num1,num2)
end;

{ Subtraction - forward referenced }
function sub;
var i: Integer;
    out, temp1, temp2: BigInt;
begin
  out := '';
  temp1 := '';
  temp2 := '';
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
      num1 := nines(num1);
      out := add(num1,num2);
      if length(out) < length(num1) then
        for i := 1 to length(num1)-length(out) do
          insert('0',out,1);
      out := nines(out);
    end
    else
    begin
      if gt(num2,num1) then
      begin
        num2 := nines(num2);
        temp2 := add(num1,num2);
        temp2 := add('1',temp2);
        for i := 1 to length(num2) do
          insert('0',temp1,1);
        insert('1',temp1,1);
        temp1 := nines(temp1);
        out := add(temp1,temp2);
        if length(out) < length(temp1) then
          for i := 1 to length(temp1)-length(out) do
            insert('0',out,1);
        out := nines(out);
        out := zapzeros(out,length(out));
        insert('-',out,1);
      end
      else
      begin
        out := '0'
      end
    end
  end;
  out := zapzeros(out,length(out));
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
      end; { carry loop }
    end; { i loop }
    out := zapzeros(out,lenmax);
    if neg=TRUE then
      insert('-',out,1);
  end;
  add := out
end;

{ Multiplication - forward referenced }
function multiply;
var len1, len2, idxcounter, idx, carry, currnum, total, i, j: Integer;
    neg: Boolean;
    out: BigInt;
begin
  len1 := length(num1);
  len2 := length(num2);
  out := '';
  neg := FALSE;
  if (len1+len2)>MAXLEN then
    multiply := 'NaN'
  else
  begin
    if num1[1]='-' then
    begin
      neg := TRUE;
      delete(num1,1,1);
      len1 := len1-1
    end;
    if num2[1]='-' then
    begin
      neg := not(neg);
      delete(num2,1,1);
      len2 := len2-1
    end;
    for i := 1 to (len1+len2) do
      out:= out + '0';
    idxcounter := 0;
    for i := len1 downto 1 do
    begin
      carry := 0;
      idx := len1+len2-idxcounter;
      currnum := ord(num1[i])-ORD0;
      for j := len2 downto 1 do
      begin
        total := (ord(num2[j])-ORD0)*currnum+carry+(ord(out[idx])-ORD0);
        carry := total div 10;
        out[idx] := chr((total mod 10)+ORD0);
        idx := idx-1;
        while carry > 0 do
        begin
          total := ord(out[idx])-ORD0+carry;
          carry := total div 10;
          out[idx] := chr((total mod 10)+ORD0);
          idx := idx-1
        end;
        idxcounter := idxcounter+1
      end {j loop - num2}
    end; {i loop - num1}
    out := zapzeros(out,len1+len2);
    if neg=TRUE then
      insert('-',out,1);
    multiply := out
  end
end;

{ Division }
function divide(num: BigInt; den: BigInt): BigInt;
var len1, len2: Integer;
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
  if eq(den,'0') then
    divide := 'NaN'
  else
  begin
    fastdiv(num,den,quotient,remainder);
    quotient := zapzeros(quotient,length(quotient));
    if (neg=TRUE) and (eq(quotient,'0')=FALSE) then
      insert('-',quotient,1);
    divide := quotient
  end
end;

{ Modulo  - implements the same definition as TP3.01A }
function modulo(num: BigInt; den: BigInt): BigInt;
var len1, len2: Integer;
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
  if eq(den,'0') then
    modulo := 'NaN'
  else
  begin
    fastdiv(num,den,quotient,remainder);
    remainder:= zapzeros(remainder,length(remainder));
    if (neg=TRUE) and (eq(remainder,'0')=FALSE) then
      insert('-',remainder,1);
    modulo := remainder
  end
end;

{ Square root }
function isqrt(num: BigInt): BigInt;
var t0, t1 : BigInt;
begin
  if (num[1]='-') then
    isqrt := 'NaN'
  else
  begin
    if (eq(num,'0') or eq(num,'1')) then
      isqrt := num
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
        t1 := divide(t1,'2')
      end;
      isqrt := t0
    end
  end
end;
