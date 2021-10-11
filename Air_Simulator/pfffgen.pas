unit pfffgen;
// Auteur Montero-Ribas
// Logiciel sous license GNU GPL
interface
Uses Windows,graphics,SysUtils,Classes,dialogs;
type   str2=string[2];
       Str12=String[12];
       Str20=String[20];

var epais,fin:Smallint;
    nomdefichier:string;
    sauve:boolean;

Const deuxpi:Single=2*PI;
      PI_Single:Single=PI;

Procedure SetLinestyle(S:TpenStyle;Epaisseur:Smallint);
Procedure SetLinemode(m:Tpenmode);
function strg(a:single):string;
function strint(a:Smallint):string;
Procedure Putpixel(x,y:Smallint;col:TColor);
Function Getx:Smallint;
Function Gety:Smallint;
Procedure Ot(s:String);
Procedure SetColor(Coul:TColor);
function strg5(a:Single):string;
Function Max(a,b:Smallint):Smallint;
Function Min(a,b:Smallint):Smallint;
procedure PetitMenu(couleur:tcolor;s:String);
function ed(entete,demande:string;var ouiounon:boolean):string;
Procedure pause;
procedure cercle(x,y,R:Single);
implementation
uses pfffunit;

Procedure SetLinestyle(S:TpenStyle;Epaisseur:Smallint);
Begin
  With Feuille.Pen do
  begin
    Style:=S;
    Width:=Epaisseur;
  end;
End;

Procedure SetLinemode(m:Tpenmode);
Begin
  With Feuille.Pen do mode:=m;
End;

function strg(a:single):string;
var s:string;
begin
  str(a:3:2,s);
  If a=0 then s:='0';
  If pos('.',s)<>0 then while s[length(s)]='0' do delete(s,length(s),1);
  if s[length(s)]='.' then delete(s,length(s),1);
  strg:=s;
end;

function strint(a:Smallint):string;
var s:string;
begin
  str(a,s);
  strint:=s;
end;

Procedure Putpixel(x,y:Smallint;Col:TColor);
Begin
  With Feuille do pixels[x,y]:=col;
End;

Function Getx:Smallint;
begin
  With feuille do Getx:=PenPos.X;
End;

Function Gety:Smallint;
begin
  With feuille do Gety:=PenPos.Y;
End;

Procedure Ot(s:String);
Begin
  With Feuille do TextOut(Penpos.x,Penpos.y,s);
End;

Procedure SetColor(Coul:TColor);
Begin
  Feuille.Pen.Color:=Coul;
  Feuille.font.color:=Coul;
End;

function strg5(a:Single):string;
var s:string;
begin
  str(a:7:7,s);
  If a=0 then s:='0';
  If pos('.',s)<>0 then while s[length(s)]='0' do delete(s,length(s),1);
  if s[length(s)]='.' then delete(s,length(s),1);
  Strg5:=s;
end;


Function Max(a,b:Smallint):Smallint;
begin
  If a>b then Max:=a else Max:=b;
end;

Function Min(a,b:Smallint):Smallint;
begin
  If a<b then Min:=a else Min:=b;
end;

procedure PetitMenu(couleur:tcolor;s:String);
begin
  form1.panel1.color:=couleur;form1.panel1.caption:=s;
end;

function ed(entete,demande:string;var ouiounon:boolean):string;
begin
   ouiounon:=Inputquery('Pfff',entete,demande);ed:=demande;
end;

Procedure pause;
begin
  Sleep(1000);
end;

procedure cercle(x,y,R:Single);
begin
  feuille.ellipse(round(x-R),round(y-R),round(x+R),round(y+R));
end;

end.
