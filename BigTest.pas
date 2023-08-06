{ Big integer test harness }
{ Turbo Pascal 3.01A, CP/M }
{ Tim Holyoake, May 2023   }

program bigtest(output);

{ Include the library }
{$I BIGILIB.PAS}

{ *** Test harness begins ***}

procedure compare;
begin
  writeln('All of the following tests must be TRUE to pass');
  writeln('');
  writeln('eq function');
  writeln('');
  writeln('0 = 0 is ',eq('0','0'));
  writeln('-1 = -1 is ',eq('-1','-1'));
  writeln('1 = 1 is ',eq('1','1'));
  writeln('10 = 10 is ',eq('10','10'));
  writeln('100 = 100 is ',eq('100','100'));
  writeln('1000000 = 1000000 is ',eq('1000000','1000000'));
  writeln('-10 = -10 is ',eq('-10','-10'));
  writeln('-100 = -100 is ',eq('-100','-100'));
  writeln('-1000000 = -1000000 is ',eq('-1000000','-1000000'));
  writeln('');
  writeln('ne function');
  writeln('');
  writeln('0 <> 1 is ',ne('0','1'));
  writeln('1 <> 0 is ',ne('1','0'));
  writeln('1 <> -1 is ',ne('1','-1'));
  writeln('-1 <> 1 is ',ne('-1','1'));
  writeln('10 <> 100 is ',ne('10','100'));
  writeln('1000 <> 100 is ',ne('1000','100'));
  writeln('123456789 <> 987654321 is ',ne('123456789','987654321'));
  writeln('-10 <> -100 is ',ne('-10','-100'));
  writeln('-1000 <> -100 is ',ne('-1000','-100'));
  writeln('');
  writeln('lt function');
  writeln('');
  writeln('0 < 1 is ',lt('0','1'));
  writeln('-1 < 1 is ',lt('-1','1'));
  writeln('1 < 2 is ',lt('1','2'));
  writeln('10 < 100 is ',lt('10','100'));
  writeln('100 < 1000 is ',lt('100','1000'));
  writeln('100 < 1000000 is ',lt('100','1000000'));
  writeln('-11 < -9 is ',lt('-11','-9'));
  writeln('-100 < -99 is ',lt('-100','-99'));
  writeln('-1000000 < 1000000 is ',lt('-1000000','1000000'));
  writeln('');
  writeln('gt function');
  writeln('');
  writeln('1 > 0 is ',gt('1','0'));
  writeln('1 > -1 is ',gt('1','-1'));
  writeln('2 > 1 is ',gt('2','1'));
  writeln('100 > 10 is ',gt('100','10'));
  writeln('1000 > 100 is ',gt('1000','100'));
  writeln('1000000 > 100 is ',gt('1000000','100'));
  writeln('-9 > -11 is ',gt('-9','-11'));
  writeln('-99 > -100 is ',gt('-99','-100'));
  writeln('1000000 > -1000000 is ',gt('1000000','-1000000'));
  writeln('');
  writeln('le function');
  writeln('');
  writeln('0 <= 1 is ',le('0','1'));
  writeln('-1 <= 1 is ',le('-1','1'));
  writeln('1 <= 2 is ',le('1','2'));
  writeln('10 <= 100 is ',le('10','100'));
  writeln('100 <= 1000 is ',le('100','1000'));
  writeln('100 <= 1000000 is ',le('100','1000000'));
  writeln('-11 <= -9 is ',le('-11','-9'));
  writeln('-100 <= -99 is ',le('-100','-99'));
  writeln('0 <= 0 is ',le('0','0'));
  writeln('-1 <= -1 is ',le('-1','-1'));
  writeln('1 <= 1 is ',le('1','1'));
  writeln('10 <= 10 is ',le('10','10'));
  writeln('100 <= 100 is ',le('100','100'));
  writeln('1000000 <= 1000000 is ',le('1000000','1000000'));
  writeln('-10 <= -10 is ',le('-10','-10'));
  writeln('-100 <= -100 is ',le('-100','-100'));
  writeln('-1000000 <= 1000000 is ',le('-1000000','1000000'));
  writeln('');
  writeln('ge function');
  writeln('');
  writeln('1 >= 0 is ',ge('1','0'));
  writeln('1 >= -1 is ',ge('1','-1'));
  writeln('2 >= 1 is ',ge('2','1'));
  writeln('100 >= 10 is ',ge('100','10'));
  writeln('1000 >= 100 is ',ge('1000','100'));
  writeln('1000000 >= 100 is ',ge('1000000','100'));
  writeln('-9 >= -11 is ',ge('-9','-11'));
  writeln('-99 >= -100 is ',ge('-99','-100'));
  writeln('0 >= 0 is ',ge('0','0'));
  writeln('-1 >= -1 is ',ge('-1','-1'));
  writeln('1 >= 1 is ',ge('1','1'));
  writeln('10 >= 10 is ',ge('10','10'));
  writeln('100 >= 100 is ',ge('100','100'));
  writeln('1000000 >= 1000000 is ',ge('1000000','1000000'));
  writeln('-10 >= -10 is ',ge('-10','-10'));
  writeln('-100 >= -100 is ',ge('-100','-100'));
  writeln('1000000 >= -1000000 is ',ge('1000000','-1000000'));
  writeln('');
  writeln('All of the following tests must be FALSE to pass');
  writeln('');
  writeln('ne function');
  writeln('');
  writeln('0 <> 0 is ',ne('0','0'));
  writeln('-1 <> -1 is ',ne('-1','-1'));
  writeln('1 <> 1 is ',ne('1','1'));
  writeln('10 <> 10 is ',ne('10','10'));
  writeln('100 <> 100 is ',ne('100','100'));
  writeln('1000000 <> 1000000 is ',ne('1000000','1000000'));
  writeln('-10 <> -10 is ',ne('-10','-10'));
  writeln('-100 <> -100 is ',ne('-100','-100'));
  writeln('-1000000 <> -1000000 is ',ne('-1000000','-1000000'));
  writeln('');
  writeln('eq function');
  writeln('');
  writeln('0 = 1 is ',eq('0','1'));
  writeln('1 = 0 is ',eq('1','0'));
  writeln('1 = -1 is ',eq('1','-1'));
  writeln('-1 = 1 is ',eq('-1','1'));
  writeln('10 = 100 is ',eq('10','100'));
  writeln('1000 = 100 is ',eq('1000','100'));
  writeln('123456789 = 987654321 is ',eq('123456789','987654321'));
  writeln('-10 = -100 is ',eq('-10','-100'));
  writeln('-1000 = -100 is ',eq('-1000','-100'));
  writeln('');
  writeln('gt function');
  writeln('');
  writeln('0 > 1 is ',gt('0','1'));
  writeln('-1 > 1 is ',gt('-1','1'));
  writeln('1 > 2 is ',gt('1','2'));
  writeln('10 > 100 is ',gt('10','100'));
  writeln('100 > 1000 is ',gt('100','1000'));
  writeln('100 > 1000000 is ',gt('100','1000000'));
  writeln('-11 > -9 is ',gt('-11','-9'));
  writeln('-100 > -99 is ',gt('-100','-99'));
  writeln('-1000000 > 1000000 is ',gt('-1000000','1000000'));
  writeln('');
  writeln('lt function');
  writeln('');
  writeln('1 < 0 is ',lt('1','0'));
  writeln('1 < -1 is ',lt('1','-1'));
  writeln('2 < 1 is ',lt('2','1'));
  writeln('100 < 10 is ',lt('100','10'));
  writeln('1000 < 100 is ',lt('1000','100'));
  writeln('1000000 < 100 is ',lt('1000000','100'));
  writeln('-9 < -11 is ',lt('-9','-11'));
  writeln('-99 < -100 is ',lt('-99','-100'));
  writeln('1000000 < -1000000 is ',lt('1000000','-1000000'));
  writeln('');
  writeln('ge function');
  writeln('');
  writeln('0 >= 1 is ',ge('0','1'));
  writeln('-1 >= 1 is ',ge('-1','1'));
  writeln('1 >= 2 is ',ge('1','2'));
  writeln('10 >= 100 is ',ge('10','100'));
  writeln('100 >= 1000 is ',ge('100','1000'));
  writeln('100 >= 1000000 is ',ge('100','1000000'));
  writeln('-11 >= -9 is ',ge('-11','-9'));
  writeln('-100 >= -99 is ',ge('-100','-99'));
  writeln('-1000000 >= 1000000 is ',ge('-1000000','1000000'));
  writeln('');
  writeln('le function');
  writeln('');
  writeln('1 <= 0 is ',le('1','0'));
  writeln('1 <= -1 is ',le('1','-1'));
  writeln('2 <= 1 is ',le('2','1'));
  writeln('100 <= 10 is ',le('100','10'));
  writeln('1000 <= 100 is ',le('1000','100'));
  writeln('1000000 <= 100 is ',le('1000000','100'));
  writeln('-9 <= -11 is ',le('-9','-11'));
  writeln('-99 <= -100 is ',le('-99','-100'));
  writeln('1000000 <= -1000000 is ',le('1000000','-1000000'));
  writeln('')
end;

procedure addition;
var i: Integer;
  res: BigInt;
begin
  res := '0';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := add(res,'1');
  writeln('End value is ',res,' : ',i,' greater than start value to pass test');
  writeln('');
  res := '1';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := add(res,'1');
  writeln('End value is ',res,' : ',i,' greater than start value to pass test');
  writeln('');
  res := '-1001';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := add(res,'1');
  writeln('End value is ',res,' : ',i,' greater than start value to pass test');
  writeln('');
  writeln('The following results are undefined - adding non-integers ...');
  writeln(add('A','k'));
  writeln(add('--0','-0'));
  writeln(add('',''))
end;

procedure subtraction;
var i: Integer;
  res: BigInt;
begin
  res := '0';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := sub(res,'1');
  writeln('End value is ',res,' : ',i,' less than start value to pass test');
  writeln('');
  res := '-1';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := sub(res,'1');
  writeln('End value is ',res,' : ',i,' less than start value to pass test');
  writeln('');
  res := '1001';
  writeln('Start value is ',res);
  for i := 1 to 1001 do
    res := sub(res,'1');
  writeln('End value is ',res,' : ',i,' less than start value to pass test');
  writeln('');
  writeln('The following results are undefined - subtracting non-integers ...');
  writeln(sub('A','k'));
  writeln(sub('--0','-0'));
  writeln(sub('',''))
end;

procedure multiplication;
begin
  writeln('Next 4 results should all be 0 to pass');
  writeln('');
  write(multiply('0','1000'),', ');
  write(multiply('1000','0'),', ');
  write(multiply('0','-1000'),', ');
  writeln(multiply('-1000','0'));
  writeln('');
  writeln('Next 4 results should all be -999 to pass');
  writeln('');
  write(multiply('1','-999'),', ');
  write(multiply('-1','999'),', ');
  write(multiply('999','-1'),', ');
  writeln(multiply('-999','1'));
  writeln('');
  writeln('The following results are undefined - multiplying non-integers ...');
  writeln(multiply('A','k'));
  writeln(multiply('--0','-0'));
  writeln(multiply('',''))
end;

procedure division;
begin
  writeln('Next 2 results should be 0, following 2 results NaN to pass');
  writeln('');
  write(divide('0','1000'),', ');
  write(divide('0','-1000'),', ');
  write(divide('-1000','0'),', ');
  writeln(divide('1000','0'));
  writeln('');
  writeln('Next 2 results should be 20, follwing 2 results -20 to pass');
  writeln('');
  write(divide('100','5'),', ');
  write(divide('-100','-5'),', ');
  write(divide('100','-5'),', ');
  writeln(divide('-100','5'));
  writeln('');
  writeln('The following results are undefined - dividing non-integers ...');
  writeln(divide('A','k'));
  writeln(divide('--0','-0'));
  writeln(divide('',''))
end;

procedure modd;
begin
  writeln('Next 2 results should be 1, following 2 results -1 to pass');
  writeln('');
  write(modulo('51','50'),', ');
  write(modulo('51','-50'),', ');
  write(modulo('-51','50'),', ');
  writeln(modulo('-51','-50'));
  writeln('');
  writeln('The following results are undefined - modulo non-integers ...');
  writeln(modulo('A','k'));
  writeln(modulo('--0','-0'));
  writeln(modulo('',''))
end;

procedure squareroot;
begin
  writeln('Next result should be 1000, following result NaN to pass');
  writeln('');
  write(isqrt('1000000'),', ');
  writeln(isqrt('-1000000'));
  writeln('');
  writeln('The following results are undefined - isqrt non-integers ...');
  writeln(isqrt('A'));
  writeln(isqrt('--0'));
  writeln(isqrt(''))
end;

begin
   writeln('');
   writeln('Maximum size of BigInt is set to ',MAXLEN);
   writeln('');
   writeln('Starting compare ...');
   writeln('');
   compare;
   writeln('');
   writeln('Starting addition ...');
   writeln('');
   addition;
   writeln('');
   writeln('Starting subtraction ...');
   writeln('');
   subtraction;
   writeln('');
   writeln('Starting multiplication ...');
   writeln('');
   multiplication;
   writeln('');
   writeln('Starting division ...');
   writeln('');
   division;
   writeln('');
   writeln('Starting modulo ...');
   writeln('');
   modd;
   writeln('');
   writeln('Starting square root ...');
   writeln('');
   squareroot;
   writeln('*** Tests finished ***');
   writeln('')
end.
