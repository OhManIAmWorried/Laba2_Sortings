program Laba2_Sortings;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Math;

type
  TFileInt = file of Integer;
  TArrInt = array of Integer;

var
  dirCustom: string;
  dirExp: string;
  f: TFileInt;

procedure separator(cv: Integer);
begin
  case cv of
  1:  Writeln('________________________________________');
  2:
    begin
      Writeln;
      Writeln('_Laba2_Sortings_________________________');
      Writeln;
    end;
  end;
end;

procedure ShowArr(arr: TArrInt);
var
  i: Integer;
begin
  if Length(arr) = 0 then
   Writeln('No elements')
  else
   for i:= 0 to Length(arr) -1 do
   begin
     if (i mod 3 = 0) and (i <> 0) then Writeln;
     write(arr[i],' ');
   end;
  Writeln;
end;

procedure CreateFile(cfcv: ShortInt; stepcv: Integer; n: Integer);
var
  f: TFileInt;
  i,j,rand: Integer;
  arr: TArrInt;
begin
  case cfcv of
  1: AssignFile(f,dirCustom);
  2: AssignFile(f,dirExp);
  end;
  Rewrite(f);
  Randomize;
  SetLength(arr,n);
  for i:= 0 to n-1 do
  begin
    rand:= Random(2147483648);
    if Random(2) = 1 then
     rand:= rand * (-1);
    arr[i]:= rand;
  end;
  for i:= 0 to stepcv - 1 do
   for j:= 0 to n - 1 do
    Write(f,arr[j]);
  CloseFile(f);
end;

function ArrGet(agcv: ShortInt; n: Integer): TArrInt;
var
  res: TArrInt;
  i: Integer;
  f: TFileInt;
begin
  case agcv of
  1: AssignFile(f,dirCustom);
  2: AssignFile(f,dirExp);
  end;
  Reset(f);
  SetLength(res,n);
  for i:= 0 to n-1 do
   read(f,res[i]);
  CloseFile(f);
  Result:= res;
end;

function IsSorted(iscv:ShortInt; arr: TArrInt): Boolean;
var
  i: Integer;
  res: Boolean;
begin
  res:= True;
  for i:=0 to Length(arr) - 2 do
   if ((arr[i] < arr[i+1]) and (iscv = 1)) or ((arr[i] > arr[i+1]) and (iscv = 2)) then
   begin
     res:= False;
     Break;
   end;
  result:= res;
end;

procedure WriteToFile(wtf: ShortInt; arr: TArrInt);
var
  i: Integer;
  f: TFileInt;
begin
  case wtf of
  1: AssignFile(f,dirCustom);
  2: AssignFile(f,dirExp);
  end;
  Rewrite(f);
  for i:= 0 to Length(arr) - 1 do
   Write(f,arr[i]);
  CloseFile(f);
end;

procedure SelectionSort(var arr: TArrInt; starti,finishi: Integer);
var
  min,minj,i,j: Integer;
begin
  for i:= starti to finishi do
  begin
    min:= 2147483647;
    for j:= Length(arr) - 1 - i downto 0 do
     if arr[j] <= min then
     begin
       minj:= j;
       min:= arr[j];
     end;
    for j:= minj to Length(arr) - 2 - i do
     arr[j]:= arr[j+1];
    arr[Length(arr) - 1 - i]:= min;
  end;
end;

procedure InsertionSort(var arr: TArrInt; starti,finishi: Integer);
var
  i,tmpi,tmp: Integer;
begin
  for i:= starti to finishi do
  begin
    tmp:= arr[i];
    tmpi:= i;
    while (tmp > arr[tmpi-1]) and (tmpi-1 >= 0) do
    begin
      arr[tmpi]:= arr[tmpi-1];
      Dec(tmpi);
    end;
    arr[tmpi]:= tmp;
  end;
end;

procedure BubbleSort(var arr: TArrInt; starti,finishi: Integer);
var
  i,j,tmp: Integer;
begin
  for i:= starti to finishi - 1 do
   for j:= i + 1 to finishi do
    if arr[j] > arr[i] then
    begin
      tmp:= arr[j];
      arr[j]:= arr[i];
      arr[i]:= tmp;
    end;
end;

procedure QuickSort(qscv: ShortInt; var arr: TArrInt; sl,sr: Integer);
var
  mid,l,r,tmp: Integer;
begin
  l:= sl;
  r:= sr;
  mid:= arr[l - ((l-r) div 2)];
  while l < r do
  begin
    case qscv of
    1:
      begin
        while (arr[l] > mid) do
         Inc(l);
        while (arr[r] < mid) do
         Dec(r);
      end;
    2:
      begin
        while (arr[l] < mid) do
         Inc(l);
        while (arr[r] > mid) do
         Dec(r);
      end;
    end;
    if (l <= r) then
    begin
      tmp:= arr[l];
      arr[l]:= arr[r];
      arr[r]:= tmp;
      Inc(l);
      Dec(r);
    end;
  end;
  if sr > l then
   QuickSort(qscv,arr,l,sr);
  if sl < r then
   QuickSort(qscv,arr,sl,r);
end;

procedure SortPartlySorted();
var
  starttime,finishtime: TDateTime;
  n,starti,finishi: Integer;
  arr: TArrInt;
begin
  separator(1);
  Write('Length of array: ');
  Readln(n);
  separator(1);
  CreateFile(1,1,n);
  arr:= ArrGet(1,n);
  Writeln('Array created');
  separator(1);
  Writeln('ArraySorted = ',IsSorted(1,arr));
  separator(1);
  Writeln('i - index of the begining of a part');
  Write('i: ');
  Readln(starti);
  Writeln('j - index of the end of a part');
  Write('j: ');
  Readln(finishi);
  separator(1);
  QuickSort(1,arr,starti,finishi);
  Writeln('The part is sorted');
  separator(1);
  Writeln('Sorting the whole array');
  starttime:= Now;
  QuickSort(1,arr,0,High(arr));
  finishtime:= Now;
  separator(1);
  Writeln('ArraySorted = ',IsSorted(1,arr));
  separator(1);
  Writeln('Time spent to sort the array: ');
  Writeln(FormatDateTime('hh:nn:ss:zzz',(finishtime - starttime)));
  WriteToFile(1,arr);
end;

procedure SortDecreasing();
var
  starttime,finishtime: TDateTime;
  n: Integer;
  arr: TArrInt;
begin
  separator(1);
  Write('Length of array: ');
  Readln(n);
  CreateFile(1,1,n);
  arr:= ArrGet(1,n);
  Writeln('Array created');
  separator(1);
  Writeln('ArraySorted = ',IsSorted(1,arr));
  separator(1);
  Writeln('Sorting from max to min');
  starttime:= Now;
  QuickSort(1,arr,0,High(arr));
  finishtime:= Now;
  separator(1);
  Writeln('ArraySorted = ',IsSorted(1,arr));
  separator(1);
  Writeln('Time spent to sort the array: ');
  Writeln(FormatDateTime('hh:nn:ss:zzz',(finishtime - starttime)));
  separator(1);
  Writeln('Sorting from min to max');
  starttime:= Now;
  QuickSort(2,arr,0,High(arr));
  finishtime:= Now;
  separator(1);
  Writeln('ArraySorted = ',IsSorted(2,arr));
  separator(1);
  Writeln('Time spent to sort the array: ');
  Writeln(FormatDateTime('hh:nn:ss:zzz',(finishtime - starttime)));
  WriteToFile(1,arr);
end;

procedure SortArr(tv: Integer; var arr: TArrInt; starti,finishi: Integer);
begin
  case tv of
  1: SelectionSort(arr,starti,finishi);
  2: InsertionSort(arr,starti,finishi);
  3: BubbleSort(arr,starti,finishi);
  4: QuickSort(1,arr,starti,finishi);
  end;
end;

procedure menuCustom(tv: ShortInt);
var
  starttime,finishtime: TDateTime;
  cv,n: Integer;
  f: TFileInt;
  arr: TArrInt;
begin
  AssignFile(f,dirCustom);
  n:= 0;
  while true do
  begin
    separator(2);
    Writeln('0. Return');
    Writeln('1. Set the number of elements in array');
    Writeln('2. Sort the array');
    Writeln('3. Show the array');
    Writeln('4. Is sorted');
    Writeln('5. Change sorting type');
    separator(1);
    Write('Choice: ');
    Readln(cv);
    if cv in [1..4] then
     separator(1);
    case cv of
    0: Break;
    1:
      begin
        write('The number of elements: ');
        Readln(n);
        CreateFile(1,1,n);
        arr:= ArrGet(1,n);
      end;
    2: if n <> 0 then
       begin
         arr:= ArrGet(1,n);
         starttime:= Now;
         SortArr(tv,arr,0,High(arr));
         finishtime:= Now;
         Writeln('Time spent to sort the array: ');
         Writeln(FormatDateTime('hh:nn:ss:zzz',(finishtime - starttime)));
       end;
    3: if n <> 0 then
        ShowArr(arr)
       else
        Writeln('Empty array');
    4: if n <> 0 then
        Writeln(IsSorted(1,arr))
       else
        Writeln('Empty array');
    5:
       begin
         separator(2);
         Writeln('1. Selection sort');
         Writeln('2. Insertion sort');
         Writeln('3. Bubble sort');
         Writeln('4. Quick sort');
         separator(1);
         Write('Choice: ');
         Readln(tv);
         if n <> 0 then
          arr:= ArrGet(1,n);
       end;
    end;
  end;
end;

procedure menuExperiments(tv: Integer);
var
  arr: TArrInt;
  mecv,sw: ShortInt;
  starttime,finishtime: TDateTime;
begin
  sw:= 0;
  while true do
  begin
    separator(2);
    Writeln('0. Return');
    Writeln('1. Sort 1 x 100000');
    Writeln('2. Sort 10 x 10000');
    Writeln('3. Sort 100 x 1000');
    Writeln('4. Sort 1000 x 100');
    Writeln('5. Sort 10000 x 10');
    Writeln('6. Show the array');
    Writeln('7. Is sorted');
    Writeln('8. Change sorting type');
    separator(1);
    Write('Choice: ');
    Readln(mecv);
    separator(1);
    case mecv of
    0: Break;
    1: if sw <> 1 then
       begin
         CreateFile(2,1,100000);
         sw:= 1;
       end;
    2: if sw <> 2 then
       begin
         CreateFile(2,10,10000);
         sw:= 2;
       end;
    3: if sw <> 3 then
       begin
         CreateFile(2,100,1000);
         sw:= 3;
       end;
    4: if sw <> 4 then
       begin
         CreateFile(2,1000,100);
         sw:= 4;
       end;
    5: if sw <> 5 then
       begin
         CreateFile(2,10000,10);
         sw:= 5;
       end;
    6: if Length(arr) <> 0 then
        ShowArr(arr)
       else
        Writeln('Empty array');
    7: if Length(arr) <> 0 then
        Writeln(IsSorted(1,arr))
       else
        Writeln('Empty array');
    8:
       begin
         separator(2);
         Writeln('1. Selection sort');
         Writeln('2. Insertion sort');
         Writeln('3. Bubble sort');
         Writeln('4. Quick sort');
         separator(1);
         Write('Choice: ');
         Readln(tv);
       end;
    end;
    if mecv in [1..5] then
    begin
      arr:= ArrGet(2,100000);
      if Length(arr) <> 0 then
      begin
        starttime:= Now;
        SortArr(tv,arr,0,High(arr));
        finishtime:= Now;
        Writeln('Time spent to sort the array: ');
        Writeln(FormatDateTime('hh:nn:ss:zzz',(finishtime - starttime)));
      end;
    end;
  end;
end;

procedure menu();
var
  cv: ShortInt;
  tv: ShortInt;
begin
  tv:= -1;
  while True do
  begin
    if tv = -1 then
    begin
      cv:= -1;
      separator(2);
      Writeln('0. Exit');
      Writeln('1. Selection sort');
      Writeln('2. Insertions sort');
      Writeln('3. Bubble sort');
      Writeln('4. Quick sort');
      separator(1);
      Write('Choice: ');
      Readln(tv);
      if tv = 0 then Break; //else AllOk
    end
    else
    begin
      separator(2);
      Writeln('0. Return');
      Writeln('1. Custom Amount of Elements');
      Writeln('2. Experiments');
      if tv = 4 then
      begin
        Writeln('3. Sort partly-sorted array');
        Writeln('4. Sort decreasing array');
      end;
      separator(1);
      Write('Choice: ');
      Readln(cv);
      case cv of
        0: tv:= -1;
        1: menuCustom(tv);
        2: menuExperiments(tv);
        3: if tv = 4 then
            SortPartlySorted();
        4: if tv = 4 then
            SortDecreasing();
      end;
    end;
  end;
end;

begin
  dirCustom:= 'C:\Users\Oly\Desktop\Algo\Laba\Laba_3Semestr\Laba2_Sortings\Custom.txt';
  dirExp:= 'C:\Users\Oly\Desktop\Algo\Laba\Laba_3Semestr\Laba2_Sortings\Experimental.txt';
  menu();
  DeleteFile(dirCustom);
  DeleteFile(dirExp);
end.
