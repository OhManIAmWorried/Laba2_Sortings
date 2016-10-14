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

function NumberSet(): TArrInt;
var
  n,i,rand: Integer;
  res: TArrInt;
  f: TFileInt;
begin
  AssignFile(f,dirCustom);
  Rewrite(f);
  write('The number of elements: ');
  Readln(n);
  Randomize;
  for i:= 0 to n-1 do
  begin
    rand:= Random(2147483648);
    if Random(2) = 1 then
     rand:= rand * (-1);
    Write(f,rand);
  end;
  CloseFile(f);
  Reset(f);
  SetLength(res,n);
  for i:= 0 to n-1 do
   read(f,res[i]);
  CloseFile(f);
  Result:= res;
end;

function IsSorted(arr: TArrInt): Boolean;
var
  i: Integer;
  res: Boolean;
begin
  res:= True;
  for i:=0 to Length(arr) - 2 do
   if arr[i] < arr[i+1] then
   begin
     res:= False;
     Break;
   end;
  result:= res;
end;

procedure WriteToFile(arr: TArrInt);
var
  i: Integer;
  f: TFileInt;
begin
  AssignFile(f,dirCustom);
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
  for i:= starti to finishi do
   for j:= starti to finishi - i do
    if arr[j] < arr[j+1] then
    begin
      tmp:= arr[j];
      arr[j]:= arr[j+1];
      arr[j+1]:= tmp;
    end;
end;

procedure QuickSort(var arr: TArrInt; sl,sr: Integer);
var
  mid,l,r,tmp: Integer;
begin
  l:= sl;
  r:= sr;
  mid:= arr[l - ((l-r) div 2)];
  while l < r do
  begin
    while (arr[l] > mid) do
     Inc(l);
    while (arr[r] < mid) do
     Dec(r);
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
   QuickSort(arr,l,sr);
  if sl < r then
   QuickSort(arr,sl,r);
end;

procedure SortArr(tv: Integer; var arr: TArrInt);
var
  starttime,finishtime: TDateTime;
begin
  case tv of
  1:
    begin
      starttime:= Now;
      SelectionSort(arr,0,High(arr));
      finishtime:= Now;
    end;
  2:
    begin
      starttime:= Now;
      InsertionSort(arr,0,High(arr));
      finishtime:= Now;
    end;
  3:
    begin
      starttime:= Now;
      BubbleSort(arr,0,High(arr));
      finishtime:= Now;
    end;
  4:
    begin
      starttime:= Now;
      QuickSort(arr,0,High(arr));
      finishtime:= Now;
    end;
  end;
  Writeln('Time spent to sort the array: ',TimeToStr(finishtime - starttime));
  WriteToFile(arr);
end;

procedure menuCustom(tv: Integer);
var
  cv: Integer;
  f: TFileInt;
  arr: TArrInt;
begin
  AssignFile(f,dirCustom);
  while true do
  begin
    separator(2);
    Writeln('0. Return');
    Writeln('1. Set the number of elements in array');
    Writeln('2. Sort the array');
    Writeln('3. Show the array');
    Writeln('4. Is sorted');
    separator(1);
    Write('Choice: ');
    Readln(cv);
    if cv in [1..4] then
     separator(1);
    case cv of
    0: Break;
    1: arr:= NumberSet();      //identical for all the types
    2: SortArr(tv,arr);
    3: ShowArr(arr);            //identical for all the types
    4: Writeln(IsSorted(arr));  //identical for all the types
    end;
  end;
end;

procedure menuExperiments(tv: Integer);
begin

end;

procedure menu();
var
  cv: Integer; //case variable
  tv: Integer; //type variable
begin
  tv:= -1;
  while True do
  begin
    if tv = -1 then
    begin
      cv:= -1;
      separator(2);
      Writeln('0. Exit');
      Writeln('1. ChoiceSort');
      Writeln('2. InsertionsSort');
      Writeln('3. BubbleSort');
      Writeln('4. QuickSort');
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
      separator(1);
      Write('Choice: ');
      Readln(cv);
      case cv of
        0: tv:= -1;  //Not the solution I guess Q.Q
        1: menuCustom(tv);
        2: menuExperiments(tv);
      end;
    end;
  end;
end;

begin
  dirCustom:= 'C:\Users\Oly\Desktop\Algo\Laba\Laba_3Semestr\Laba2_Sortings\Custom.txt';
  dirExp:= 'C:\Users\Oly\Desktop\Algo\Laba\Laba_3Semestr\Laba2_Sortings\Experimental.txt';
  menu();
end.
