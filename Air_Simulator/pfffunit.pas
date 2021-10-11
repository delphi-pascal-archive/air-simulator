unit pfffunit;
// Auteur Montero-Ribas
// Logiciel sous license GNU GPL
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Clipbrd, Menus, StdCtrls,pfffgen, Buttons,printers, ExtDlgs,shellapi;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Composant1: TMenuItem;
    Texte1: TMenuItem;
    Puissance1: TMenuItem;
    Commande1: TMenuItem;
    Anime1: TMenuItem;
    Nouveau1: TMenuItem;
    Ouvrir1: TMenuItem;
    Enregregistersous1: TMenuItem;
    Quitter1: TMenuItem;
    Pressepapier1: TMenuItem;
    Sauverlimage1: TMenuItem;
    Efface1: TMenuItem;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PrintDialog1: TPrintDialog;
    Apropos1: TMenuItem;
    Noiretblanc1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Couleur1: TMenuItem;
    Image1: TImage;
    MspaintBmp1: TMenuItem;
    Timer1: TTimer;
    SauverlimageEMF1: TMenuItem;
    SavePictureDialog2: TSavePictureDialog;
    Loupe1: TMenuItem;
    Loupe2: TMenuItem;
    sortir1: TMenuItem;
    Gauche1: TMenuItem;
    Droite1: TMenuItem;
    Dessus1: TMenuItem;
    Dessous1: TMenuItem;
    Memo1: TMemo;
    SauverlcranSVG1: TMenuItem;
    SaveDialog2: TSaveDialog;
    Dplacer1: TMenuItem;
    Timer2: TTimer;
    Continu1: TMenuItem;
    RAZ1: TMenuItem;
    Excuter1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Composant1Click(Sender: TObject);
    procedure Texte1Click(Sender: TObject);
    procedure Efface(Sender: TObject);
    procedure Puissance1Click(Sender: TObject);
    procedure Commande1Click(Sender: TObject);
    procedure Anime1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Enregregistersous1Click(Sender: TObject);
    procedure Nouveau1Click(Sender: TObject);
    procedure Pressepapier1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Quitter1Click(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure Noiretblanc1Click(Sender: TObject);
    procedure Sauverlimage1Click(Sender: TObject);
    procedure Couleur1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure MspaintBmp1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SauverlimageEMF1Click(Sender: TObject);
    procedure Loupe1Click(Sender: TObject);
    procedure Loupe2Click(Sender: TObject);
    procedure sortir1Click(Sender: TObject);
    procedure Gauche1Click(Sender: TObject);
    procedure Droite1Click(Sender: TObject);
    procedure Dessus1Click(Sender: TObject);
    procedure Dessous1Click(Sender: TObject);
    procedure SauverlcranSVG1Click(Sender: TObject);
    procedure Dplacer1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Continu1Click(Sender: TObject);
    procedure RAZ1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  Bitmap:TBitmap;
  NomdeFichier:String;
  heure:Boolean;
  Feuille:Tcanvas;
implementation

uses apUnit1,jpeg;

{$R *.DFM}
Type Str16=String[16];
     Type_V   = (Simple,Simple_R,R_Simple,Double2,Double_T,Double_A,Double_T_A,Double_V);
     Type_D   = (_3_2,_4_2,_5_2,_2_2,_2_2_,_4_3,_5_3);
     Type_C   = (Poussoir_Gauche,Poussoir_Droit,Ressort_Droit,Pas_De_Com,Pilote_Gauche,Pilote_Droit,Scie_Droite);
     Type_    = (Un_V,Un_D,Une_C,Une_Alim,Une_Alim_Pilote,Un_Canal,Rien,Un_Cap,Un_Canal_Pilote,
                 Tout,Un_Carrefour,Un_Carrefour_Pilote,Action,Deux_Canaux,temps,Une_memoire,
                 Un_Sequenceur,Un_Texte,Une_Cellule,ouste,toutsaufcanal);
     Type_Cap = (A_Poussoir,A_Roue,A_Levier,A_Galet,A_Poussoir_Bistable,A_Levier_Bistable,Et,Ou,Inhibition,A_Galet_V);
     T_Bout   = Record
                  Quoi:Type_;
                  Lequel:Smallint;
                  Branchement:Smallint;
               End;
     t_Com    = Record
                  Quoi:Type_C;
                  Laquelle:Smallint;
                End;
     T_Distributeur = Record
                        X,Y     : single;
                        Etat_Ext: Array [-1..5] Of Byte;
                        ExtX    : Array [-1..5] Of single;
                        ExtY    : Array [-1..5] Of single;
                        COm     : Array [1..2 ] Of T_Com;
                        Modele  : Type_D;
                        Etat    : Byte;
                      End;
     T_Sequenceur = Record
                        X,Y     : single;
                        Etat_Ext: Array [1..22] Of Byte;
                        ExtX    : Array [1..22] Of single;
                        ExtY    : Array [1..22] Of single;
                        Etat    : Byte;
                        Combien :byte;
                      End;

     T_Capteur      = Record
                        X,Y     : single;
                        Etat_Ext: Array [1..3] Of Byte;
                        ExtX    : Array [1..3] Of single;
                        ExtY    : Array [1..3] Of single;
                        Modele  : Type_Cap;
                        Etat    : Byte;
                        Lie_a   : Smallint;
                        Position: Byte;
                      End;
     T_Memoire      = Record
                        X,Y     : single;
                        Etat_Ext: Array [1..4] Of Byte;
                        ExtX    : Array [1..4] Of single;
                        ExtY    : Array [1..4] Of single;
                        Etat    : Byte;
                      End;

     T_Verin        = Record
                        X,Y     : single;
                        Tige    : Smallint;
                        Etat_Ext: Array [1..2] Of Byte;
                        EntreeX : Array [1..2] Of single;
                        EntreeY : Array [1..2] Of single;
                        Modele  : Type_V;
                      End;
     T_Commande     = Record
                        X,Y     : single;
                        Etat    : Byte;
                        Modele  : Type_C;
                      End;

     T_Parcours     = Array [1..11] Of single;
     T_Canal        = Record
                        X,Y     : single;
                        NbPoint:Smallint;
                        ParcoursX,ParcoursY:T_Parcours;
                        Etat:Byte;
                        Bout:Array[1..2] Of T_Bout;
                      End;
     T_Canal_Pilote = Record
                        X,Y     : single;
                        NbPoint:Smallint;
                        ParcoursX, ParcoursY: T_Parcours;
                        Etat:Byte;
                        Bout:Array[1..2] Of T_Bout;
                      End;
     T_Pilote       = Record
                        NbPoint:Smallint;
                        ParcoursX, ParcoursY: T_Parcours;
                        Etat:Boolean;
                        Bout:Array[1..2] Of T_Bout;
                      End;
     T_Alimentation = Record
                        X,Y:single;
                      End;
     T_Alim_Pilote  = Record
                        X,Y:single;
                      End;
     T_Carrefour    = Record
                        X,Y:single;
                        Etat:Byte;
                      End;
     T_Carrefour_Pilote= Record
                          X,Y:single;
                          Etat:Byte;
                         End;
     T_Texte           =Record
                          X,Y:single;
                          lataille:integer;
                          Le_Texte:Str16;
                        End;


Type Pointe=Array[1..2] Of single;

Const Max_Distributeur = 35;
      Max_Verin        = 30;
      Max_Commande     = 70;  {Le double des distributeurs}
      Max_Canal        = 100;
      Max_Canal_Pilote = 200;
      Max_Alimentation = 50;
      Max_Capteur      = 60;
      Max_Alim_Pilote  = 50;
      Max_Carrefour    = 50;
      Max_Carrefour_Pilote  =50;
      Max_Memoire      = 20;
      Max_Sequenceur   =  5;
      Max_Texte        = 80;

      Coef             =  1.2;
      VHauteur         =  35*Coef;
      VLargeur         = 130*Coef;
      VH_Tige          =   4*Coef;
      VL_Tige          = 130*Coef;
      VH_Bout          =   6*Coef;
      VCanal           =   8*Coef;
      VAmor=10*Coef;
      DLargeur         =  30*Coef;
      A_Droite         =  True;
      L_Bout           =  VLargeur/10;
      ARayon           =  5;
      CLargeur         =  20*Coef;
      DMEmoire         =  24*Coef;
      SLargeur         =  36*Coef;
      Maxtige=9;
      MinTige=2;
Const Un=1;
      Zero=0;
      Bof=2;
      Bouche=3;

Var Distributeur              : Array [1..Max_Distributeur] Of T_Distributeur;
    Verin                     : Array [1..Max_Verin]        Of T_Verin;
    Commande                  : Array [1..Max_Commande]     Of T_Commande;
    Canal                     : Array [1..Max_Canal]        Of T_Canal;
    Canal_Pilote              : Array [1..Max_Canal_Pilote] Of T_Canal_Pilote;
    AliMentation              : Array [1..Max_Alimentation] Of T_Alimentation;
    Alim_Pilote               : Array [1..Max_Alimentation] Of T_Alim_Pilote;
    Capteur                   : Array [1..Max_Capteur] Of T_Capteur;
    Carrefour                 : Array [1..Max_Carrefour] Of T_Carrefour;
    Carrefour_Pilote          : Array [1..Max_Carrefour_Pilote] Of T_Carrefour_Pilote;
    Memoire                   : Array [1..Max_Memoire] Of T_Memoire;
    Sequenceur                : Array [1..Max_Sequenceur] Of T_Sequenceur;
    Texte                     : Array [1..Max_Texte] Of T_Texte;
    Nb_Verin,Nb_Distributeur,Nb_Commande,Nb_Canal,Nb_Alimentation,Nb_Capteur,Nb_Alim_Pilote,Nb_Canal_pilote,Nb_Carrefour,
    Nb_Carrefour_Pilote,Nb_Memoire,Nb_Sequenceur,Nb_Texte,G_Pour,G_K,x_s,y_s,Nb_Point:Smallint;
    Vieux_Nb_Verin,Vieux_Nb_Distributeur,Vieux_Nb_Capteur,Vieux_Nb_Alim,Vieux_Nb_Alim_Pilote,Vieux_Nb_Carrefour,Vieux_Nb_Carrefour_Pilote,
    Vieux_Nb_Commande,Vieux_Nb_Canal,Vieux_Nb_Canal_Pilote,Vieux_Nb_Memoire,Vieux_Nb_Sequenceur,Vieux_Nb_Texte:Smallint;
    heur,minute,seconde,sec100:word;
    Les_points: Array [1..200] Of Pointe;
    Gauche,Droite,SVG,immonde_rustine_double_v, immonde_rustine_galet_v:Boolean;
    actionencours,fichiermodifie,pasapas:boolean;
    Dialogvaleur:integer;
    Compteursouris:longint;
    MetaFile:TMetaFile;
    facteur,vieux_facteur,XG,YG : single;

Function Change_svg(s:string):String;
var resultat:string;
    position:byte;
    car:char;
begin
  resultat:='';
  position:=1;
  While position<=length(s) do
  begin
    car:=char(s[position]);
    case car of
      '&':resultat:=resultat +'&amp;';
      '<':resultat:=resultat +'&lt;';
      '>':resultat:=resultat +'&gt;';
      '''':resultat:=resultat +'&apos;';
      '"':resultat:=resultat +'&quot;';
       else resultat:=resultat+car;
     end;
    inc(position);
  end;
  Change_svg:=resultat;
end;

Procedure Otxy(x,y:Smallint;s:String);
Begin
  if svg then s:=Change_svg(s);
  If not SVG then With Feuille do TextOut(round(x*facteur),round(y*facteur),s)
             else form1.memo1.lines.Add('   <text x= "'+  Strg(X)+  '" y= "'+strg(y+abs(form1.Image1.Canvas.Font.height))+
                                        '" style="font-size:'+Strint(abs(form1.Image1.Canvas.Font.height))+'">'+s+'</text>');
End;

Procedure NPave(X,Y:single;co:Tcolor);
Begin
  setcolor(co);
  feuille.Brush.style:=bssolid;
  feuille.brush.color:=co;
  feuille.polygon([point(round((X-2)*facteur),round((Y+2)*facteur)),point(round((X+2)*facteur),round((Y+2)*facteur)),
                   point(round((X+2)*facteur),round((Y-2)*facteur)),point(round((X-2)*facteur),round((Y-2)*facteur))]);
  feuille.Brush.style:=bsclear;
  setcolor(clblack);
End;

Procedure NPavepetit(X,Y:single;co:Tcolor);
Begin
  setcolor(co);
  feuille.Brush.style:=bssolid;
  feuille.brush.color:=co;
  feuille.polygon([point(round((X-1)*facteur),round((Y+1)*facteur)),point(round((X+1)*facteur),round((Y+1)*facteur)),
                   point(round((X+1)*facteur),round((Y-1)*facteur)),point(round((X-1)*facteur),round((Y-1)*facteur))]);
  feuille.Brush.style:=bsclear;
  setcolor(clblack);
End;

Procedure RAZ;
Var i,k:Smallint;
Begin
  FOr I:=1 to Nb_Canal do With Canal[i] Do eTat:=zero;
  FOr I:=1 to Nb_Distributeur do With Distributeur[i] Do For K:=-1 to 5 Do   Etat_Ext[K]:=0;
  FOr I:=1 to Nb_Memoire do With memoire[i] Do For K:=1 to 4 Do   Etat_Ext[K]:=0;
  FOr I:=1 to Nb_Sequenceur do With Sequenceur[i] Do For K:=1 to 22 Do   Etat_Ext[K]:=0;
  FOr I:=1 to Nb_Canal_Pilote do With Canal_Pilote[i] Do eTat:=bof;
  FOr I:=1 to Nb_Capteur do With Capteur[i] Do For K:=1 to 3 Do   Etat_Ext[K]:=bof;
  FOr I:=1 to Nb_Verin do With Verin[i] Do For K:=1 to 2 Do   Etat_Ext[K]:=0;
  FOr I:=1 to Nb_Carrefour do With Carrefour[i] Do eTat:=zero;
  FOr I:=1 to Nb_Carrefour_Pilote do With Carrefour_Pilote[i] Do eTat:=bof;
End;

Procedure Raz_Vieux;
Begin
    Vieux_Nb_Verin:=0;
    Vieux_Nb_Distributeur:=0;
    Vieux_Nb_Capteur:=0;
    Vieux_Nb_Alim:=0;
    Vieux_Nb_Alim_Pilote:=0;
    Vieux_Nb_Carrefour_Pilote:=0;
    Vieux_Nb_Carrefour:=0;
    Vieux_Nb_Commande:=0;
    Vieux_Nb_Canal_Pilote:=0;
    Vieux_Nb_Canal:=0;
    Vieux_Nb_Memoire:=0;
    Vieux_Nb_Sequenceur:=0;
End;

Procedure Super_Raz;
var Pour,K:integer;
Begin
    Raz_Vieux;
    Nb_Verin:=0;
    Nb_Distributeur:=0;
    Nb_Commande:=0;
    NB_Canal:=0;
    NB_Canal_Pilote:=0;
    Nb_Alimentation:=0;
    Nb_Capteur:=0;
    Nb_Alim_Pilote:=0;
    Nb_Carrefour:=0;
    Nb_Carrefour_Pilote:=0;
    Nb_Memoire:=0;
    Nb_Sequenceur:=0;
    Nb_Texte:=0;
    For Pour:=1 to Max_Canal do With Canal[Pour] Do For K:=1 to 2 Do
    Begin
      eTat:=zero;
      Bout[K].Quoi:=Rien;
    End;
    For Pour:=1 to Max_Canal_Pilote do With Canal_Pilote[Pour] Do For K:=1 to 2 Do
    Begin
      eTat:=Bof;
      Bout[K].Quoi:=Rien;
    End;
    For Pour:=1 to Max_Distributeur do With Distributeur[Pour] Do  For K:=-1 to 5 Do Etat_Ext[K]:=0;
    For Pour:=1 to Max_Capteur do With Capteur[Pour] Do Etat:=0;
    Raz;
End;

Procedure lecturede(nom:String);
var pour:smallint;
    F:File;
Begin
    ASSIGNfile(F,nomdefichier);
    ReSet(f,1);
    BlockRead(f,Nb_Verin,2);
    BlockRead(f,Nb_Distributeur,2);
    BlockRead(f,Nb_Commande,2);
    BlockRead(f,NB_Canal,2);
    BlockRead(f,NB_Canal_Pilote,2);
    BlockRead(f,Nb_Alimentation,2);
    BlockRead(f,Nb_Capteur,2);
    BlockRead(f,Nb_Alim_Pilote,2);
    BlockRead(f,Nb_Carrefour,2);
    BlockRead(f,Nb_Carrefour_Pilote,2);
    BlockRead(f,Nb_Memoire,2);
    BlockRead(f,Nb_Sequenceur,2);
    BlockRead(f,Nb_Texte,2);
    BlockRead(f,Pour,2);
    BlockRead(f,Pour,2);
    BlockRead(f,Verin[1],Nb_Verin*SizeOf(Verin[1]));
    BlockRead(f,Distributeur[1],Nb_Distributeur*SizeOf(Distributeur[1]));
    BlockRead(f,Commande[1],Nb_Commande*SizeOf(Commande[1]));
    BlockRead(f,Canal[1],NB_Canal*SizeOf(Canal[1]));
    BlockRead(f,Canal_Pilote[1],Nb_Canal_Pilote*SizeOf(Canal_Pilote[1]));
    BlockRead(f,Alimentation[1],Nb_Alimentation*SizeOf(Alimentation[1]));
    BlockRead(f,Capteur[1],Nb_Capteur*SizeOf(Capteur[1]));
    BlockRead(f,Alim_Pilote[1],Nb_Alim_Pilote*SizeOf(Alim_Pilote[1]));
    BlockRead(f,Carrefour[1],Nb_Carrefour*SizeOf(Carrefour[1]));
    BlockRead(f,Carrefour_Pilote[1],Nb_Carrefour_Pilote*SizeOf(Carrefour_Pilote[1]));
    BlockRead(f,memoire[1],Nb_Memoire*SizeOf(memoire[1]));
    BlockRead(f,Sequenceur[1],Nb_Sequenceur*SizeOf(Sequenceur[1]));
    For Pour:=1 to Nb_Texte Do BlockRead(f,Texte[Pour],SizeOf(Texte[Pour]));
    Closefile(f);
End;

Procedure Couleur(c:TColor);
Begin
  Feuille.Pen.Color:=C;
  Feuille.font.color:=C;
End;

procedure ligne(x1,y1,X2,Y2:single);
begin
  If not SVG then With feuille do
  Begin
    MoveTo(round(X1*facteur),round(Y1*facteur));
    LineTo(round(X2*facteur),round(Y2*facteur));
  end        else form1.memo1.lines.Add('   <line x1= "'+Strg(X1*facteur)+'" y1= "'+strg(y1*facteur)+'" x2 ="'
                                        +Strg(x2*facteur)+'" y2= "'+Strg(y2*facteur)+'"  stroke="black"    />');

end;

Procedure ellipse_SVG(x1,y1,x2,y2:single);
begin
   If not SVG then feuille.Ellipse(round(x1), round(y1),round(x2) , round(y2))
              else form1.memo1.lines.Add('   <ellipse cx= "'+Strg((X1+x2)/2)+'" cy= "'+strg((y1+y2)/2)+'" rx = "'+Strg(abs(x2-x1)/2)+
                                         '" ry= "'+Strg(abs(y2-y1)/2)+'"  fill="none" stroke="black"  stroke-width="1"  />');
end;

Procedure cercle(x,y,rr:single);
begin
  Ellipse_SVG((x-rr)*facteur, (Y-rr)*facteur, (X+rr)*facteur, (Y+rr)*facteur);
end;

Procedure Rect(Xe,Ye,Xf,Yf:Single);
Begin
  ligne(xe,ye,xe,yf);
  ligne(xf,ye,xf,yf);
  ligne(xe,ye,xf,ye);
  ligne(xe,yf,xf,yf);
End;

procedure pointille(x1,y1,x2,y2:Single);
begin
   With Feuille do
   Begin
     SetLinestyle(psdashDot,fin);
     ligne(X1,Y1,X2,Y2);
     SetLinestyle(psSolid,fin);
   end;
End;

Procedure ClearDevice;
Var pour:smallint;
begin
 Couleur(clwhite);
     for pour := 0 to form1.Image1.height do  With Feuille do
     begin
        moveTo(0,pour);
        LineTo(form1.Image1.Width,pour);
     end;
end;

Procedure Arc_De_Cercle(X,Y,AngleDebut,AngleFin,Rayon:single);
var pour:Smallint;
    increment,X1,X2,Y1,Y2:single;
Begin
   With feuille do
   Begin
     angledebut:=angledebut*pi/180;
     anglefin:=anglefin*pi/180;
     increment:=(anglefin-angledebut)/20;
     X1:=x+rayon*cos(angledebut);
     Y1:=y-rayon*sin(angledebut);
     for pour:=1 to 20 do
     Begin
       X2:=x+rayon*cos(angledebut+pour*increment);
       Y2:=y-rayon*sin(angledebut+pour*increment);
       Ligne(X1,Y1,X2,Y2);
       X1:=X2;Y1:=Y2;
     end;
   end;
End;

Procedure Affiche_Temps(X,y:single;Go:boolean);
Const dim=18;
var h,m:word;
    heure:single;
Begin
  heure:=frac(time)*24;h:=round(int(heure));
  m:=round((frac(heure)*60));
  if H>=12 then dec(H,12);
  If (H<>Heur) Or (M<>Minute) Or Go then
  Begin
    Couleur(clwhite);
    Ligne(X,Y,X+2*DIM/3*Cos(-(heur*60+minute)*pi/360+pi/2),Y-2*dim/3*sin(-(heur*60+minute)*pi/360+pi/2));
    Ligne(X,Y,X+dim*Cos(-minute*pi/30+pi/2),Y-DIm*sin(-minute*pi/30+pi/2));
    Heur:=H;minute:=m;
    Couleur(clgreen);
    Ligne(X,Y,X+2*DIM/3*Cos(-(heur*60+minute)*pi/360+pi/2),Y-2*dim/3*sin(-(heur*60+minute)*pi/360+pi/2));
    Ligne(X,Y,X+dim*Cos(-minute*pi/30+pi/2),Y-DIm*sin(-minute*pi/30+pi/2));
    Cercle(X,Y,Dim+2);
    npave(X,y,clgreen);
  End;
End;

procedure changemenu;
begin
   form1.composant1.enabled:=not actionencours;
   form1.texte1.enabled:= not actionencours;
   form1.efface1.enabled:= not actionencours;
   form1.puissance1.enabled:= not actionencours;
   form1.commande1.enabled:= not actionencours;
   form1.fichier1.enabled:=not actionencours;
   form1.excuter1.enabled:=not actionencours;
   form1.apropos1.enabled:=not actionencours;
   form1.loupe1.enabled:=not actionencours;
   form1.loupe2.enabled:=not actionencours;
   form1.dessus1.enabled:=not actionencours;
   form1.dessous1.enabled:=not actionencours;
   form1.gauche1.enabled:=not actionencours;
   form1.droite1.enabled:=not actionencours;
   form1.dplacer1.enabled:=not actionencours;
   form1.continu1.enabled:=not actionencours;
   form1.raz1.enabled:=not actionencours;
   form1.sortir1.enabled:=actionencours;
end;

procedure cacommence;
begin
  actionencours:=true;
  changemenu;
end;

Procedure Affiche_Ressort(X,Y,XFin,Hauteur:single;Droite:Boolean);
Var Pour:Smallint;
    Intervalle,Signe:single;
Begin
  Intervalle:=(XFin-X)/3;
  If Droite then Signe:=1 Else Signe:=-1;
  For Pour:=0 to 2 Do
  Begin
    Ligne(X+Signe*Pour*Intervalle,y-Hauteur/2,X+Signe*(Pour+0.5)*intervalle,y+Hauteur/2);
    Ligne(X+Signe*(Pour+0.5)*Intervalle,y+Hauteur/2,X+Signe*(Pour+1)*intervalle,y-Hauteur/2);
  End;
End;

Procedure Affiche_Ressort_Vertical(X,Y,YFin,Largeur:single;Bas:Boolean);
Var Pour:Smallint;
    Intervalle,Signe:single;
Begin
  Intervalle:=(YFin-Y)/3;
  If Bas then Signe:=1 Else Signe:=-1;
  For Pour:=0 to 2 Do
  Begin
    Ligne(X-Largeur/2,Y+Signe*Pour*Intervalle,X+Largeur/2,Y+Signe*(Pour+0.5)*intervalle);
    Ligne(X+Largeur/2,Y+Signe*(Pour+0.5)*Intervalle,X-Largeur/2,Y+Signe*(Pour+1)*intervalle);
  End;
End;

Procedure Cree_Sequenceur(Xe,Ye:single;Combien_etape:Smallint);
Var Pour:Smallint;
Begin
  Inc(Nb_Sequenceur);
  With Sequenceur[Nb_Sequenceur] Do
  Begin
    X:=Xe;Y:=Ye;
    Combien:=Combien_Etape;
    For Pour:=1 to 8 Do
    Begin
      ExtX[Pour]:=X+(Pour-1/4)*SLargeur;
      ExtX[Pour+8]:=ExtX[Pour];
      ExtY[Pour]:=Y+5/4*SLargeur-Slargeur/2;
      ExtY[Pour+8]:=Y-1/4*SLargeur-Slargeur/2;
    End;
    For Pour:=17 To 20 Do
    Begin
      ExtX[Pour]:=X-1/4*SLargeur;
      ExtY[Pour]:=Y+(Pour-16)*SLargeur/5-Slargeur/2;
    End;
    ExtX[21]:=X+(Combien+3/4)*SLargeur;
    ExtX[22]:=ExtX[21];
    ExtY[21]:=ExtY[17];
    ExtY[22]:=ExtY[20];
    Etat:=0;
  End;
End;

procedure affiche_etat_Sequenceur(numero:Smallint);
Var Pour:Smallint;
Begin
  With Sequenceur[Numero] Do
  Begin
   For Pour:=1 to Combien Do If Pour=Etat Then npave(X+(Pour-1)*Slargeur+Slargeur/2,Y-Slargeur/4,clblack)
                                          Else npave(X+(Pour-1)*Slargeur+Slargeur/2,Y-Slargeur/4,clwhite);
  End;
End;

Procedure Affiche_Sequenceur(Numero:Smallint;Blanc:Boolean);
Var Pour:Integer;
    XX,yy:single;
Begin
  If svg then form1.memo1.lines.Add('<g>');
  With Sequenceur[Numero] Do
  Begin
    Couleur(clblack);
    Rect(X,Y-SLargeur/2,X+Slargeur/4,Y+Slargeur/2);
    Rect(X+combien*SLargeur+Slargeur/4,Y-SLargeur/2,X+Slargeur/2+combien*SLargeur,Y+Slargeur/2);
    For Pour :=1 to Combien Do
    Begin
      Rect(X+SLargeur/4+(Pour-1)*SLargeur,Y-SLargeur/2,X+Slargeur/4+Pour*SLargeur,Y+Slargeur/2);
      xx:=X+3*SLargeur/4+(Pour-1)*SLargeur;
      Ligne(xx,Y+SLargeur/2,xx,Y+SLargeur/2+SLargeur/4);
      Ligne(xx,Y-SLargeur/2,xx,Y-SLargeur/2-SLargeur/4);
      Pointille(X+SLargeur/4+(Pour-1)*SLargeur,Y+SLargeur/2,X+Slargeur/4+Pour*SLargeur,Y-Slargeur/2);
    End;
    For Pour:=1 To 4 Do
    Begin
      yy:=Pour*SLargeur/5-Slargeur/2;
      Ligne(X,Y+yy,x-slargeur/4,y+yy);
    End;
      xx:=Slargeur/2+Slargeur*Combien;
      Ligne(X+xx,Y+SLargeur/5-Slargeur/2,x+xx+Slargeur/4,y+SLargeur/5-Slargeur/2);
      Ligne(X+xx,Y+4*SLargeur/5-Slargeur/2,x+xx+Slargeur/4,y+4*SLargeur/5-Slargeur/2);
    {If Not Blanc Then
    Begin
      For Pour:=1 To Combien Do
      Begin
        npavepetit(ExtX[Pour],ExtY[Pour],clfuchsia);
        npavepetit(ExtX[Pour+8],ExtY[Pour+8],clfuchsia);
      End;
      For Pour := 17 To 22 Do npavepetit(ExtX[Pour],ExtY[Pour],clfuchsia);
    End; }
    affiche_etat_Sequenceur(numero);
    Couleur(clblack);
  End;
  If svg then form1.memo1.lines.Add('</g>');
End;

Procedure Triangle(X,Y:single);
Const Cote=2.6*Coef;
Begin
  Ligne(X-Cote,Y,X+Cote,Y);
  Ligne(X-Cote,Y,X,Y+Cote*1.7);
  Ligne(X+Cote,Y,X,Y+Cote*1.7);
End;

Procedure Cree_Verin(XX,YY:single;Model:Type_V);
Begin
  Inc(Nb_Verin);
  With Verin[Nb_Verin] Do
  Begin
    X:=XX;
    Y:=YY;
    If model<>Double_V then
    begin
      EntreeX[1]:=XX+L_Bout/2;
      EntreeY[1]:=YY+VHauteur/2+VCanal;
      EntreeX[2]:=XX-L_Bout/2+VLargeur;
      EntreeY[2]:=YY+VHauteur/2+VCanal;
    end else
    begin
      EntreeX[1]:=XX+VHauteur/2+VCanal;
      EntreeY[1]:=YY-L_Bout/2;
      EntreeX[2]:=XX+VHauteur/2+VCanal;
      EntreeY[2]:=YY+L_Bout/2-VLargeur;
    end;
    Tige:=2;
    Modele:=Model;
  End;
End;

Procedure Affiche_Verin(Numero:Smallint;C:Tcolor;Blanc:Boolean);
Var coul:tcolor;
Procedure Affiche_Simple(Amortissement:Boolean);
Var Amor:single;
Begin
  If Amortissement Then Amor:=VAmor Else Amor:=0;
  With Verin[Numero] Do
  Begin
    If not svg then
    begin
      If modele<>Double_V then
      begin
        SetLinestyle(psDot,fin);
        Rect(X+(Maxtige-1)*L_Bout+VL_Tige+L_Bout,   Y-VH_Bout,X+(Maxtige-1)*L_Bout+VL_Tige+2*L_Bout,Y+VH_Bout);
        Rect(X+(MinTige-1)*L_Bout+VL_Tige+L_Bout,   Y-VH_Bout,X+(MinTige-1)*L_Bout+VL_Tige+2*L_Bout,Y+VH_Bout);
        SetLinestyle(psSolid,fin);
        ligne(X,Y+VHauteur/2,X+VLargeur,Y+VHauteur/2);
        ligne(X,Y-VHauteur/2,X+VLargeur,Y-VHauteur/2);
      end else
      begin
        SetLinestyle(psDot,fin);
        Rect(X-VH_Bout          ,Y-(Maxtige-1)*L_Bout-VL_Tige-L_Bout,X+VH_Bout          ,Y-(Maxtige-1)*L_Bout-VL_Tige-2*L_Bout);
        Rect(X-VH_Bout          ,Y-(Mintige-1)*L_Bout-VL_Tige-L_Bout,X+VH_Bout          ,Y-(Mintige-1)*L_Bout-VL_Tige-2*L_Bout);
        SetLinestyle(psSolid,fin);
        ligne(X+VHauteur/2,Y,X+VHauteur/2,Y-VLargeur);
        ligne(X-VHauteur/2,Y,X-VHauteur/2,Y-VLargeur);
      end;
    end;
    If modele<>Double_V then
    begin
      Ligne(X+VLargeur,Y-VHauteur/2,X+VLargeur,Y-VH_Tige);
      Ligne(X+VLargeur,Y+VHauteur/2,X+VLargeur,Y+VH_Tige);
      Rect(X+(tige-1)*L_Bout,Y-VHauteur/2,X+(tige-1)*L_Bout+L_Bout,Y+VHauteur/2);
      Rect(X+(tige-1)*L_Bout,Y-Amor,X+(tige-1)*L_Bout-Amor/5,Y+Amor);
      Rect(X+tige*L_Bout,Y-Amor,X+tige*L_Bout+Amor/5,Y+Amor);
      Rect(X+tige*L_Bout+Amor/5,              Y-VH_Tige,X+(tige-1)*L_Bout+VL_Tige+L_Bout,Y+VH_Tige);
      Rect(X+(tige-1)*L_Bout+VL_Tige+L_Bout  ,Y-VH_Bout,X+(tige-1)*L_Bout+VL_Tige+2*L_Bout,Y+VH_Bout);
      Ligne(X+L_Bout/2,Y+VHauteur/2,X+L_Bout/2,Y+VHauteur/2+VCanal);
      Ligne(X+VLargeur-L_Bout/2,Y+VHauteur/2,X-L_Bout/2+VLargeur,Y+VHauteur/2+VCanal);
    end else
    begin
      Ligne(X-VHauteur/2,Y-VLargeur,X-VH_Tige,Y-VLargeur);
      Ligne(X+VHauteur/2,Y-VLargeur,X+VH_Tige,Y-VLargeur);
      Rect(X-VHauteur/2    ,    Y-(tige-1)*L_Bout,    X+VHauteur/2    ,    Y-(tige-1)*L_Bout-L_Bout);
      Rect(X-VH_Tige ,              Y-tige*L_Bout-Amor/5  ,X+VH_Tige   ,Y-(tige-1)*L_Bout-VL_Tige-L_Bout       );
      Rect(X-VH_Bout ,Y-(tige-1)*L_Bout-VL_Tige-L_Bout ,X+VH_Bout,Y-(tige-1)*L_Bout-VL_Tige-2*L_Bout);
      Ligne(X+VHauteur/2,Y-L_Bout/2,X+VHauteur/2+VCanal,Y-L_Bout/2);
      Ligne(X+VHauteur/2,Y-VLargeur+L_Bout/2,X+VHauteur/2+VCanal,Y+L_Bout/2-VLargeur);
    end;
  End;
End;

Begin
  If svg then form1.memo1.lines.Add('<g>');
  If Not Blanc Then Couleur(C) Else Couleur(Clblack);
  With Verin[Numero] Do
  Begin

    Case Modele Of
      Simple,Double2,Double_A:Begin
                                Ligne(X,Y-VHauteur/2,X,Y+VHauteur/2);
                                Affiche_Simple(Modele=DOuble_A);
                                If Modele=Simple Then Triangle(X-L_Bout/2+VLargeur,Y+VHauteur/2+VCanal);
                              End;
      Simple_R:Begin
                 Ligne(X,Y-VHauteur/2,X,Y+VHauteur/2);
                 Affiche_Simple(False);
                 Affiche_Ressort(X+(tige-1)*L_Bout+L_Bout,Y,X+VLargeur,VHauteur/1.5,A_Droite);
                 Triangle(X-L_Bout/2+VLargeur,Y+VHauteur/2+VCanal);
               End;
      R_Simple:Begin
                 Ligne(X,Y-VHauteur/2,X,Y+VHauteur/2);
                 Tige:=11-Tige;
                 Affiche_Simple(False);
                 Affiche_Ressort(X,Y,X+(tige-1)*L_Bout,VHauteur/1.5,A_Droite);
                 Tige:=11-Tige;
                 Triangle(X+L_Bout/2,Y+VHauteur/2+VCanal);
               End;
      Double_T,Double_T_A
                   :Begin
                      Ligne(X,Y-VHauteur/2,X,Y-VH_Tige);
                      Ligne(X,Y+VHauteur/2,X,Y+VH_Tige);
                      Affiche_Simple(Modele=Double_T_A);
                      If Modele=Double_T_A Then Rect(X+(Tige-1)*L_Bout-VL_Tige,Y-VH_Tige,X+(Tige-1)*L_Bout-VAmor/5,Y+VH_Tige)Else
                      Rect(X+(Tige-1)*L_Bout-VL_Tige,Y-VH_Tige,X+(Tige-1)*L_Bout,Y+VH_Tige);
                      Rect(X+(Tige-1)*L_Bout-L_Bout -VL_Tige ,Y-VH_Bout,X+(tige-1)*L_Bout-VL_Tige,Y+VH_Bout);
                    End;
      Double_V:    Begin
                     Ligne(X-VHauteur/2,Y,X+VHauteur/2,Y);
                     Affiche_Simple(Modele=DOuble_A);
                    End;
    End;
    If Not Blanc Then
    Begin
      If C=clwhite Then Coul:=clwhite Else Coul:=clred;
      npavepetit(EntreeX[1],EntreeY[1],Coul);
      if modele in [double2,double_v] then npavepetit(EntreeX[2],EntreeY[2],Coul);
    End;
  End;
  Couleur(clwhite);
  If svg then form1.memo1.lines.Add('</g>');
End;

Procedure Cree_Commande(XX,YY:single;Model:TYpe_C);
Begin
  Inc(Nb_Commande);
  With Commande[Nb_Commande] Do
  Begin
    X:=XX;
    Y:=YY;
    Modele:=Model;
  End;
End;

Procedure Affiche_Commande(Numero,C:tcolor;Blanc:Boolean;deca:single;etat:byte);
Var Largeur:single;
    z:single;

Procedure Affiche_Poussoir_Gauche;
Begin
  With Commande[Numero] Do
  Begin
    Ligne(Z,Y-VHauteur/8,Z-Largeur/6,Y-VHauteur/8);
    Ligne(Z,Y+VHauteur/8,Z-Largeur/6,Y+VHauteur/8);
    Ligne(Z-Largeur/6,Y-VHauteur/6,Z-Largeur/6,Y+VHauteur/6);
    Arc_De_Cercle(Z-Largeur/6,Y,90,270,VHauteur/6);
  End;
End;

Begin
  If Not Blanc Then Couleur(C) Else Couleur(clblack);
  With Commande[Numero] Do
  Begin
    Z:=X+Deca;
    Case Modele Of
      Scie_Droite:Begin
                    Largeur:=4/5*DLargeur;
                    Ligne(Z,Y+4/5*DLargeur/10,Z+4/5*4/5*Dlargeur,Y+4/5*Dlargeur/10);
                    Ligne(Z+4/5*4/5*DLargeur,Y+4/5*Dlargeur/10,Z+4/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z+4/5*4/5*DLargeur,Y-4/5*Dlargeur/10,Z+3/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z+1/2*4/5*DLargeur,Y,Z+3/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z+1/2*4/5*DLargeur,Y,Z+2/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z+3/10*4/5*Dlargeur,Y,Z+2/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z+3/10*4/5*Dlargeur,Y,Z+1/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                    Ligne(Z,Y-4/5*Dlargeur/10,Z+1/5*4/5*Dlargeur,Y-4/5*Dlargeur/10);
                  End;
      Poussoir_Gauche: Begin
                         Largeur:=VLargeur;
                         Affiche_Poussoir_Gauche;
                       End;
      Ressort_Droit  : Begin
                         Largeur:=DLargeur/2;
                         if etat=1 then Affiche_Ressort(Z,Y,Z+2*Largeur,VHauteur/4,A_Droite)
                         else Affiche_Ressort(Z,Y,Z+Largeur/2,VHauteur/4,A_Droite);
                       End;
      Pilote_Gauche  : Begin
                         Rect(Z-DLargeur/2,Y-DLargeur/6,Z,Y+DLargeur/6);
                         Ligne(Z-DLargeur/2,Y-DLargeur/6,Z-DLargeur/3,Y);
                         Ligne(Z-DLargeur/2,Y+DLargeur/6,Z-DLargeur/3,Y);
                       End;
      Pilote_Droit  : Begin
                         Rect(Z+DLargeur/2,Y-DLargeur/6,Z,Y+DLargeur/6);
                         Ligne(Z+DLargeur/2,Y-DLargeur/6,Z+DLargeur/3,Y);
                         Ligne(Z+DLargeur/2,Y+DLargeur/6,Z+DLargeur/3,Y);
                       End;
    End;
  End;
  Couleur(clblack);
End;

Procedure Cree_Memoire(Xc,Yc:single;L_Etat:Byte);
Begin
  Inc(Nb_Memoire);
  With Memoire[Nb_Memoire] Do
  Begin
    X:=Xc;Y:=Yc;
    Etat:=L_Etat;
    ExtX[1]:=X-Dmemoire*5/4;
    ExtY[1]:=Y+1/4*Dmemoire;
    ExtX[2]:=ExtX[1];
    ExtY[2]:=Y+3/4*Dmemoire;
    ExtX[3]:=X+Dmemoire*5/4;
    ExtY[3]:=ExtY[1];
    ExtX[4]:=X;
    ExtY[4]:=Y+5/4*Dmemoire;
  End;
End;

Procedure Affiche_Memoire(Numero:Smallint;C:tcolor;Blanc:Boolean);
Var Coul:tcolor;
    pour:Byte;
Begin
  If svg then form1.memo1.lines.Add('<g>');
  Couleur(C);
  With Memoire[Numero] Do
  Begin
  If C=clwhite Then Coul:=clwhite Else Coul:=clfuchsia;
    Rect(X-DMemoire,Y,X+DMemoire,Y+DMemoire);
    Pointille(X-DMemoire,Y+DMemoire/2,X+DMemoire,Y+DMemoire/2);
    Ligne(x-DMemoire*5/4,Y+DMemoire/4,x-DMemoire,Y+DMemoire/4);
    Ligne(x+DMemoire*5/4,Y+DMemoire/4,x+DMemoire,Y+DMemoire/4);
    Ligne(x-DMemoire*5/4,Y+DMemoire*3/4,x-DMemoire,Y+DMemoire*3/4);
    Ligne(x,Y+DMemoire,x,Y+DMemoire*5/4);
    If Not Blanc Then For Pour:=1 To 4 Do npavepetit(ExtX[Pour],ExtY[Pour],Coul);
    If Etat=1 then Coul:=clblack Else Coul:=clwhite;
    npave(X+DMemoire/2,Y+3/4*DMemoire,coul);
    If Etat=2 then Coul:=clblack Else Coul:=clwhite;
    npave(X+DMemoire/2,Y+1/4*DMemoire,coul);
  End;
  Couleur(clblack);
  If svg then form1.memo1.lines.Add('</g>');
End;

Procedure Cree_Capteur(Xc,Yc:single;Modelec:Type_Cap;L_Etat:Byte);
Begin
  Inc(Nb_Capteur);
  With Capteur[Nb_Capteur] Do
  Begin
    X:=Xc;Y:=Yc;
    If not (modelec=A_galet_V) then
    begin
      ExtX[1]:=X-CLargeur/2;
      If Not (Modelec In [Et,Ou,Inhibition]) Then ExtY[1]:=Y+5/4*CLargeur
                                             Else
      Begin
        ExtX[1]:=X-3/4*CLargeur;
        ExtY[1]:=Y+1/4*CLargeur;
      End;
      ExtX[2]:=ExtX[1];
      ExtX[3]:=X+CLargeur/2;
      If (Modelec In [Et,Ou,Inhibition]) Then
      Begin
        ExtY[2]:=Y+3/4*CLargeur;
        ExtX[3]:=X+3/4*CLargeur;
      End                                             Else ExtY[2]:=Y+7/4*CLargeur;
      ExtY[3]:=ExtY[2];
    end else
    begin
       ExtX[1]:=X+5/4*CLargeur;
       ExtY[1]:=Y+1/2*CLargeur;
       ExtX[2]:=X+7/4*CLargeur;
       ExtY[2]:=ExtY[1];
       ExtX[3]:=ExtX[2];
       ExtY[3]:=Y-1/2*CLargeur;
    end;
    Modele:=Modelec;
    Etat:=L_Etat;
  End;
End;

Procedure Affiche_Capteur(Numero:Smallint;C:tcolor;Blanc:Boolean);
Var DecaY:single;

Procedure Stop(X,Y:single);
Begin
  Ligne(X,Y,X+CLargeur/5,Y);
  Ligne(X+CLargeur/5,Y+CLargeur/7,X+CLargeur/5,Y-CLargeur/7);
End;

Procedure Stop_V(X,Y:single);
Begin
  Ligne(X,Y,X,Y-CLargeur/5);
  Ligne(X+CLargeur/7,Y-CLargeur/5,X-CLargeur/7,Y-CLargeur/5);
End;

Procedure Poussoir_Haut(X,Y:single);
Begin
  Ligne(X-DLargeur/11,Y,X-DLargeur/11,Y-Dlargeur/3);
  Ligne(X+DLargeur/11,Y,X+DLargeur/11,Y-Dlargeur/3);
  Ligne(X+DLargeur/6,Y-Dlargeur/3,X-DLargeur/6,Y-Dlargeur/3);
  Arc_De_Cercle(X,Y-DLargeur/3,0,180,DLargeur/6);
End;

Procedure Poussoir_Bas(X,Y:single);
Begin
  Ligne(X-DLargeur/11,Y,X-DLargeur/11,Y-Dlargeur/6);
  Ligne(X+DLargeur/11,Y,X+DLargeur/11,Y-Dlargeur/6);
  Ligne(X+DLargeur/6,Y-Dlargeur/6,X-DLargeur/6,Y-Dlargeur/6);
  Arc_De_Cercle(X,Y-DLargeur/6,0,180,DLargeur/6);
End;

Procedure Galet_Haut(X,Y:single);
Begin
  Ligne(X-DLargeur/11,Y,X-DLargeur/11,Y-Dlargeur/3);
  Ligne(X+DLargeur/11,Y,X+DLargeur/11,Y-Dlargeur/3);
  Cercle(X,Y-DLargeur/3-Dlargeur/8,DLargeur/6);
  Cercle(X,Y-DLargeur/3-Dlargeur/8,DLargeur/12);
End;

Procedure Galet_Haut_V(X,Y:single);
Begin
  Ligne(X,Y+DLargeur/11,X-Dlargeur/3,Y+DLargeur/11);
  Ligne(X,Y-DLargeur/11,X-Dlargeur/3,Y-DLargeur/11);
  Cercle(X-DLargeur/3-Dlargeur/8,Y,DLargeur/6);
  Cercle(X-DLargeur/3-Dlargeur/8,Y,DLargeur/12);
End;

Procedure Galet_Bas(X,Y:single);
Begin
  Ligne(X-DLargeur/11,Y,X-DLargeur/11,Y-Dlargeur/6);
  Ligne(X+DLargeur/11,Y,X+DLargeur/11,Y-Dlargeur/6);
  Cercle(X,Y-DLargeur/6-Dlargeur/8,DLargeur/6);
  Cercle(X,Y-DLargeur/6-Dlargeur/8,DLargeur/12);
End;

Procedure Carre(X,Y:single);
Begin
  Rect(X-CLargeur/2,Y,X+CLargeur/2,Y+Clargeur);
End;

Procedure Carre_Gauche(X,Y:single);
Begin
  Carre(X,Y);
  Ligne(X-CLargeur/2,Y+3/4*CLargeur,X+CLargeur/2,Y+3/4*CLargeur);
  Ligne(X+CLargeur/2,Y+3/4*CLargeur,X+CLargeur/4,Y+(3/4-1/8)*CLargeur);
  Ligne(X+CLargeur/2,Y+3/4*CLargeur,X+CLargeur/4,Y+(3/4+1/8)*CLargeur);
  Stop(X-CLargeur/2,Y+1/4*CLargeur);
End;

Procedure Carre_Droite(X,Y:single);
Begin
  Carre(X,Y);
  Ligne(X-CLargeur/2,Y+1/4*CLargeur,X+CLargeur/2,Y+3/4*CLargeur);
  Ligne(X-CLargeur/2,Y+1/4*CLargeur,X-Clargeur/4,Y+1/4*CLargeur);
  Ligne(X-CLargeur/2,Y+1/4*CLargeur,X-Clargeur/3,Y+(1/4+1/5)*CLargeur);
  Stop(X-CLargeur/2,Y+3/4*CLargeur);
End;

Procedure Scie(X,Y:single);
Begin
  Ligne(X-CLargeur/10,Y,X-CLargeur/10,Y+4/5*Clargeur);
  Ligne(X-CLargeur/10,Y+4/5*Clargeur,X+CLargeur/10,Y+4/5*Clargeur);
  Ligne(X+CLargeur/10,Y+4/5*Clargeur,X+CLargeur/10,Y+3/5*Clargeur);
  Ligne(X+CLargeur/10,Y+3/5*Clargeur,X,Y+1/2*Clargeur);
  Ligne(X+CLargeur/10,Y+2/5*Clargeur,X,Y+1/2*Clargeur);
  Ligne(X+CLargeur/10,Y+2/5*Clargeur,X,Y+3/10*Clargeur);
  Ligne(X+CLargeur/10,Y+1/5*Clargeur,X,Y+3/10*Clargeur);
  Ligne(X+CLargeur/10,Y+1/5*Clargeur,X+CLargeur/10,Y);
End;

Procedure change_Taille;
begin
  If facteur>2.6 then  feuille.font.height:=48 else If facteur>1.9 then  feuille.font.height:=24 else If facteur>=1 then  feuille.font.height:=16;
end;

Procedure Cellule_Et(X,Y:single);
Begin
  Carre(X,Y);
  Change_taille;
  Otxy(Round(X-CLargeur/4),Round(Y+CLargeur/3),'&');
  feuille.font.height:=8;
  Ligne(X-3/4*CLargeur,Y+1/4*CLargeur,X-CLargeur/2,Y+1/4*CLargeur);
  Ligne(X-3/4*CLargeur,Y+3/4*CLargeur,X-CLargeur/2,Y+3/4*CLargeur);
  Ligne(X+3/4*CLargeur,Y+3/4*CLargeur,X+CLargeur/2,Y+3/4*CLargeur);
End;

Procedure Cellule_Inhibition(X,Y:single);
Begin
  Carre(X,Y); Change_taille;
  Otxy(Round(X-CLargeur/4),Round(Y+CLargeur/3),'&');
  Ligne(X-3/4*CLargeur,Y+1/4*CLargeur,X-CLargeur/2,Y+1/4*CLargeur);
  Ligne(X-3/4*CLargeur,Y+3/4*CLargeur,X-CLargeur/2 -CLargeur/5,Y+3/4*CLargeur);
  Cercle(X-CLargeur/2-Clargeur/10,Y+3/4*CLargeur,Clargeur/10);
  Ligne(X+3/4*CLargeur,Y+3/4*CLargeur,X+CLargeur/2,Y+3/4*CLargeur);
End;

Procedure Cellule_Ou(X,Y:single);
Begin
  Carre(X,Y);Change_taille;
  Ligne(X-CLargeur/2+2,Y+Clargeur/3,X-CLargeur/4,Y+Clargeur/2);
  Ligne(X-CLargeur/2+2,Y+Clargeur*2/3,X-CLargeur/4,Y+Clargeur/2);
  Ligne(X-CLargeur/2+2+2,Y+Clargeur*2/3+2,X-CLargeur/4+2,Y+Clargeur/2+2);
  Otxy(Round(X-Clargeur/4+4),Round(Y+CLargeur/3),'1');
  Ligne(X-3/4*CLargeur,Y+1/4*CLargeur,X-CLargeur/2,Y+1/4*CLargeur);
  Ligne(X-3/4*CLargeur,Y+3/4*CLargeur,X-CLargeur/2,Y+3/4*CLargeur);
  Ligne(X+3/4*CLargeur,Y+3/4*CLargeur,X+CLargeur/2,Y+3/4*CLargeur);
End;

Begin
  If svg then form1.memo1.lines.Add('<g>');
  If Not Blanc Then Couleur(C) Else Couleur(clblack);
  With Capteur[Numero] Do
  Begin
    Couleur(C);
    Case modele of
      Inhibition:Cellule_Inhibition(X,Y);
              Et:Cellule_Et(X,Y);
              Ou:Cellule_Ou(X,Y);
      Else
      Begin
        If not(modele=A_galet_V) then
        begin
          If Etat=2 then Decay:=CLargeur Else Decay:=0;
          Carre_Gauche(X,y+Decay);
          Carre_Droite(X,y+CLargeur+Decay);
          If Modele In [A_Poussoir,A_Poussoir_Bistable] Then Poussoir_Haut(X,Y+Decay) Else Galet_Haut(X,Y+Decay);
          If Modele =A_Poussoir_Bistable Then Scie(X,y+2*CLargeur+Decay)
                                         Else If etat=1 then Affiche_Ressort_Vertical(X,y+2*CLargeur+Decay,y+2*CLargeur+3*Clargeur/2+Decay,CLargeur/2,True)
                                                        else Affiche_Ressort_Vertical(X,y+2*CLargeur+Decay,y+2*CLargeur+Clargeur/2+Decay,CLargeur/2,True);
        End else
        begin
          If Etat=2 then Decay:=CLargeur Else Decay:=0;
          Rect(X+Decay,Y-CLargeur/2,X+Clargeur+Decay,Y+CLargeur/2);
          Rect(X+Clargeur+Decay,Y-CLargeur/2,X+Clargeur+Clargeur+Decay,Y+CLargeur/2);
          Galet_Haut_V(X+Decay,Y);
          Stop_V(X+CLargeur/4+decay,Y+CLargeur/2);
          Stop_V(X+Clargeur+3*CLargeur/4+decay,Y+CLargeur/2);
          Ligne(X+3/4*Clargeur+decay,Y-Clargeur/2,X+3/4*Clargeur+decay,Y+Clargeur/2);
          Ligne(X+3/4*Clargeur+decay,Y-CLargeur/2,X+(3/4+1/8)*Clargeur+decay,Y-CLargeur/4);
          Ligne(X+3/4*Clargeur+decay,Y-CLargeur/2,X+(3/4-1/8)*Clargeur+decay,Y-CLargeur/4);
          Ligne(X+5/4*Clargeur+decay,Y+Clargeur/2,X+7/4*Clargeur+decay,Y-Clargeur/2);
          Ligne(X+5/4*Clargeur+decay,Y+Clargeur/2,   X+5/4*Clargeur+decay,Y+Clargeur/4);
          Ligne(X+5/4*Clargeur+decay,Y+Clargeur/2,   X+(5/4+1/5)*Clargeur+decay,Y+Clargeur/3);
          If etat=1 then Affiche_Ressort(X+2*CLargeur+Decay,y,X+2*CLargeur+3*Clargeur/2+Decay,CLargeur/2,True)
                    else Affiche_Ressort(X+2*CLargeur+Decay,y,X+2*CLargeur+Clargeur/2+Decay,CLargeur/2,True);
        end;
      end;
    end;
  End;
  Couleur(clblack);
  If svg then form1.memo1.lines.Add('</g>');
End;

Procedure Cree_Distributeur(Xc,Yc:single;Modelec:Type_D;Commande1,Commande2:Type_C;L_Etat:Byte);
Begin
  Inc(Nb_Distributeur);
  With Distributeur[Nb_Distributeur] Do
  Begin
    X:=Xc;Y:=Yc;
    if not (modelec in[_4_3,_5_3]) then ExtX[-1]:=Xc-DLargeur/2
                                   else ExtX[-1]:=Xc-DLargeur/2-dlargeur;
    ExtY[-1]:=Yc;
    if not (modelec in[_4_3,_5_3]) then ExtX[0]:=Xc+3*DLargeur+DLargeur/2
                                   else ExtX[0]:=Xc+4*DLargeur+DLargeur/2;
    ExtY[0]:=Yc;
    ExtX[2]:=X+9/5*DLargeur;
    ExtY[2]:=Y+DLargeur/2;
    ExtX[3]:=X+9/5*DLargeur;
    ExtY[3]:=Y-DLargeur/2;
    ExtX[4]:=X+6/5*DLargeur;
    ExtY[4]:=Y-DLargeur/2;
    Case Modelec Of
     _3_2,_4_2,_4_3:Begin
                ExtX[1]:=X+6/5*DLargeur;
                ExtY[1]:=Y+DLargeur/2;
                ExtX[5]:=X+1.5*DLargeur;
                ExtY[5]:=Y+DLargeur/2;
               End;
          _5_2,_5_3:Begin
                ExtX[5]:=X+6/5*DLargeur;
                ExtY[5]:=Y+DLargeur/2;
                ExtX[1]:=X+1.5*DLargeur;
                ExtY[1]:=Y+DLargeur/2;
               End;
          _2_2,_2_2_:Begin
                ExtX[1]:=X+1.5*DLargeur;
                ExtY[1]:=Y+DLargeur/2;
                ExtX[5]:=ExtX[1];
                ExtY[5]:=Y+DLargeur/2;
                ExtX[4]:=ExtX[1];
                ExtY[4]:=Y-DLargeur/2;
               End;
    End;
    Modele:=Modelec;
    Etat:=L_Etat;
    Cree_Commande(X,Y,Commande1);
    Commande[Nb_Commande].Etat:=L_Etat;
    Com[1].Quoi:=Commande1;
    Com[1].Laquelle:=Nb_Commande;
    if not (modelec in[_4_3,_5_3]) then Cree_Commande(X+2*DLargeur,Y,Commande2)
                                   else Cree_Commande(X+3*DLargeur,Y,Commande2);
    Commande[Nb_Commande].Etat:=L_Etat;
    Com[2].Quoi:=Commande2;
    Com[2].Laquelle:=Nb_Commande;
  End;
End;

Procedure Affiche_Distributeur(Numero:Smallint;C:tcolor;Blanc:Boolean);
Var coul:tcolor;
    XDeca:single;

Procedure Fleche_Haut(X,Y:single);
Begin
  Ligne(X,Y,X,Y-DLargeur);
  Ligne(X,Y-DLargeur,X-DLargeur/20,Y-DLargeur+DLargeur/5);
  Ligne(X,Y-DLargeur,X+DLargeur/20,Y-DLargeur+DLargeur/5);
End;

Procedure Fleche_Bas(X,Y:single);
Begin            { Point d'accrochage en bas  }
  Ligne(X,Y,X,Y-DLargeur);
  Ligne(X,Y,X-DLargeur/20,Y-0.2*DLargeur);
  Ligne(X,Y,X+DLargeur/20,Y-0.2*DLargeur);
End;

Procedure Carre(X,y:single);
Begin
  Rect(X,Y-DLargeur/2,X+DLargeur,Y+DLargeur/2);
End;

Procedure Carre_Haut_Bas(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Haut(X+DLargeur/5,Y+DLargeur/2);
  Fleche_Bas(X+0.8*DLargeur,Y+DLargeur/2);
End;

Procedure Stop_Bas(X,Y:single);
Begin
  Ligne(X,Y,X,Y-DLargeur/5);
  Ligne(X-DLargeur/10,Y-DLargeur/5,X+DLargeur/10,Y-DLargeur/5);
End;

Procedure Stop_Haut(X,Y:single);
Begin
  Ligne(X,Y,X,Y+DLargeur/5);
  Ligne(X-DLargeur/10,Y+DLargeur/5,X+DLargeur/10,Y+DLargeur/5);
End;

Procedure Fleche_Oblique_Bas(X,Y:single);
Begin
  Ligne(X,Y,X+0.6*Dlargeur,Y+DLargeur);
  Ligne(X+0.60*Dlargeur,Y+DLargeur,X+0.60*Dlargeur-Dlargeur/30,Y+DLargeur-DLargeur/5);
  Ligne(X+0.60*Dlargeur,Y+DLargeur,X+0.43*Dlargeur,Y+0.9*DLargeur);
End;

Procedure Fleche_Oblique_Haut(X,Y:single);
Begin
  Ligne(X,Y,X+0.60*Dlargeur,Y-DLargeur);
  Ligne(X+0.60*Dlargeur,Y-DLargeur,X+0.60*Dlargeur-Dlargeur/30,Y-DLargeur+DLargeur/5);
  Ligne(X+0.60*Dlargeur,Y-DLargeur,X+0.43*Dlargeur,Y-0.9*DLargeur);
End;

Procedure Carre_Haut_Stop(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Haut(X+DLargeur/5,Y+DLargeur/2);
  Stop_Bas(X+DLargeur-DLargeur/5,Y+DLargeur/2);
End;

Procedure Carre_Fleche(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Haut(X+DLargeur/2,Y+DLargeur/2);
End;

Procedure Carre_Stop_Stop(X,y:single);
Begin
  Carre(X,Y);
  Stop_Bas(X+DLargeur/2,Y+DLargeur/2);
  Stop_Haut(X+DLargeur/2,Y-DLargeur/2);
End;

Procedure Carre_Stop_Oblique(X,y:single);
Begin
  Carre(X,Y);
  Stop_Bas(X+DLargeur/5,Y+DLargeur/2);
  Fleche_Oblique_Bas(X+DLargeur/5,Y-DLargeur/2);
End;

Procedure Carre_Oblique_Oblique(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Oblique_Bas(X+DLargeur/5,Y-DLargeur/2);
  Fleche_Oblique_Haut(X+DLargeur/5,Y+DLargeur/2);
End;

Procedure Fleche_Demi_Oblique_Haut_Droite(X,Y:single);
Begin
  Ligne(X,Y,X+0.30*Dlargeur,Y-DLargeur);
  Ligne(X+0.30*Dlargeur,Y-DLargeur,X+0.30*Dlargeur+Dlargeur/30,Y-DLargeur+DLargeur/5);
  Ligne(X+0.30*Dlargeur,Y-DLargeur,X+0.16*Dlargeur,Y-0.87*DLargeur);
End;

Procedure Fleche_Demi_Oblique_Haut_Gauche(X,Y:single);
Begin
  Ligne(X,Y,X-0.30*Dlargeur,Y-DLargeur);
  Ligne(X-0.30*Dlargeur,Y-DLargeur,X-0.30*Dlargeur-Dlargeur/30,Y-DLargeur+DLargeur/5);
  Ligne(X-0.30*Dlargeur,Y-DLargeur,X-0.16*Dlargeur,Y-0.87*DLargeur);
End;

Procedure Carre_1_5_2(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Bas(X+0.2*DLargeur,Y+DLargeur/2);
  Stop_Bas(X+0.8*DLargeur,Y+DLargeur/2);
  Fleche_Demi_Oblique_Haut_Droite(X+0.5*DLargeur,Y+DLargeur/2);
End;

Procedure Carre_2_5_2(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Bas(X+0.8*DLargeur,Y+DLargeur/2);
  Stop_Bas(X+0.2*DLargeur,Y+DLargeur/2);
  Fleche_Demi_Oblique_Haut_Gauche(X+0.5*DLargeur,Y+DLargeur/2);
End;

procedure carre4stop(x,y:single);
begin
  Carre(X,Y);
  Stop_Bas(X+0.2*DLargeur,Y+DLargeur/2);Stop_Bas(X+0.8*DLargeur,Y+DLargeur/2);
  Stop_haut(X+0.2*DLargeur,Y-DLargeur/2);Stop_haut(X+0.8*DLargeur,Y-DLargeur/2);
end;

Procedure Carre2fleches(X,y:single);
Begin
  Carre(X,Y);
  Fleche_Bas(X+0.2*DLargeur,Y+DLargeur/2);
  Fleche_Bas(X+0.8*DLargeur,Y+DLargeur/2);
  Stop_Bas(X+0.5*DLargeur,Y+DLargeur/2);
End;

Begin
  If svg then form1.memo1.lines.Add('<g>');
  If Not Blanc Then Couleur(C) Else Couleur(clblack);
  With Distributeur[Numero] Do
  Begin
    Couleur(C);
    If Etat=1 then XDeca:=0 Else if etat=2 then XDeca:=Dlargeur  else if etat =3 then xdeca:=-dlargeur;
    Case Modele Of
       _3_2:Begin
              Carre_Haut_Stop(X+Xdeca,y);Carre_Stop_Oblique(X+Xdeca+dLargeur,y);
              Ligne(X+9/5*DLargeur,Y+Dlargeur/2,X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
            End;
        _5_2:Begin
              Carre_2_5_2(X+Xdeca,y);Carre_1_5_2(X+Xdeca+dLargeur,y);
              Ligne(X+9/5*DLargeur+xdeca,Y+Dlargeur/2,X+9/5*DLargeur+xdeca,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+9/5*DLargeur+xdeca,Y+Dlargeur/2+Dlargeur/8);
              Ligne(X+6/5*DLargeur+xdeca,Y+Dlargeur/2,X+6/5*DLargeur+xdeca,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+6/5*DLargeur+xdeca,Y+Dlargeur/2+Dlargeur/8);
             End;
        _5_3:Begin
              Carre_2_5_2(X+Xdeca,y);
              carre2fleches(x+dlargeur+xdeca,y);
              Carre_1_5_2(X+Xdeca+dLargeur+dlargeur,y);
              Ligne(X+9/5*DLargeur,Y+Dlargeur/2,X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Ligne(X+6/5*DLargeur,Y+Dlargeur/2,X+6/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+6/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
             End;
        _4_2:Begin
              Carre_Haut_Bas(X+Xdeca,y);Carre_Oblique_Oblique(X+Xdeca+dLargeur,y);
              Ligne(X+9/5*DLargeur,Y+Dlargeur/2,X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
             End;
       _4_3:Begin
              Carre_Haut_Bas(X+Xdeca,y);
              Carre4stop(x+dlargeur+xdeca,y);
              Carre_Oblique_Oblique(X+Xdeca+2*dLargeur,y);
              Ligne(X+9/5*DLargeur,Y+Dlargeur/2,X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
              Triangle(X+9/5*DLargeur,Y+Dlargeur/2+Dlargeur/8);
             End;
       _2_2:Begin
              Carre_Stop_Stop(X+Xdeca+dLargeur,y);Carre_Fleche(X+Xdeca,y);
            End;
       _2_2_:Begin
              Carre_Stop_Stop(X+Xdeca,y);Carre_Fleche(X+Xdeca+dLargeur,y);
            End;
    End;
    If C=clwhite Then Coul:=clwhite Else Coul:=clfuchsia;
    If Not Blanc Then Couleur(Coul) Else Couleur(clblack);
    begin
      If Com[1].Quoi In [Pilote_Gauche,Pilote_Droit] Then
      if not (modele in[_4_3,_5_3]) then ligne(extx[-1],y,extx[-1]+xdeca,y)
                                    else ligne(extx[-1],y,extx[-1]+xdeca+dlargeur,y)    ;
      If Com[2].Quoi In [Pilote_Gauche,Pilote_Droit] Then if not (modele in[_4_3,_5_3]) then ligne(extx[0]-xdeca{-dlargeur},y,extx[0]-dlargeur,y)
                                                                                        else ligne(extx[0]+xdeca-dlargeur{-dlargeur},y,extx[0],y);
    end;
    Affiche_Commande(Com[1].Laquelle,C,Blanc,Xdeca,etat);
    Affiche_Commande(Com[2].Laquelle,C,Blanc,Xdeca,etat);
    Couleur(c);
    if  (modele in[_4_3,_5_3]) then
    begin
     if etat=3 then
     Affiche_Ressort(X-dlargeur/4+xdeca,Y+dlargeur/3,X+xdeca,dlargeur/4,true) else Affiche_Ressort(X-dlargeur+xdeca,Y+dlargeur/3,X+xdeca,dlargeur/4,true);
     if etat=2 then Affiche_Ressort(X+3*dlargeur+xdeca,Y+dlargeur/3,X+3*dlargeur+dlargeur/4+xdeca,dlargeur/4,true)
               else Affiche_Ressort(X+3*dlargeur+xdeca,Y+dlargeur/3,X+3*dlargeur+dlargeur+xdeca,dlargeur/4,true);
    end;
  End;
  Couleur(clblack);
  If svg then form1.memo1.lines.Add('</g>');
End;

Function ENTREPOINT(Puissance:Boolean;Old_X,Old_Y:Smallint;Var Ext:Boolean;Var NX,NY:single;Var Branche:T_Bout):Boolean;
VAR DRA:BOOLEAN;
    Pour,X,Y,Pour2,Combien:Smallint;
    Di,Distance,D,Xd,Yd:single;
    PourPt:Smallint;

procedure croix(x,Y:Smallint);
begin
  SetLinemode(pmnot);
  ligne(x,y-150,x,y+150);
  ligne(x-150,y,x+150,y);
  If Not Ext Then
  Begin
    If (Abs(Old_X-X)<=Abs(Old_Y-Y)) Then ligne(Old_X,Old_Y,Old_X,Y)
                                    else ligne(Old_X,Old_Y,X,Old_Y);
  End;
  SetLinemode(pmcopy);
end;

Function Dista(X,Y:single):single;
Begin
  Dista:=Sqrt(Sqr(x_S-X)+Sqr(Y_S-Y));
End;

Procedure entre_pave(X,Y:single);
Begin
  If Nb_Point<200 Then Inc(Nb_Point);
  Les_Points[Nb_Point,1]:=X;
  Les_Points[Nb_Point,2]:=Y;
  if puissance then npave(x,y,clred) else npave(x,y,clfuchsia);
End;

BEGIN
  form1.image1.cursor:=crnone;
  Nb_Point:=0;
  If Puissance Then
  Begin
    For Pour :=1 To Nb_Alimentation Do With Alimentation[Pour] Do Entre_Pave(X,Y);

    For Pour :=1 to Nb_Distributeur Do With Distributeur[Pour] Do
    Begin
      Case modele of
          _3_2:begin
                 For Pour2:=1 To 2 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
                 Entre_Pave(ExtX[4],ExtY[4]);
               end;
          _5_2,_5_3:For Pour2:=1 To 5 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
          _4_2,_4_3:For Pour2:=1 To 4 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
          _2_2,_2_2_:begin
                       Entre_Pave(ExtX[1],ExtY[1]);
                       Entre_Pave(ExtX[4],ExtY[4]);
                     end;
      end;
    End;
    For Pour :=1 To Nb_Carrefour Do With Carrefour[Pour] Do Entre_Pave(X,Y);
    For Pour:=1 to Nb_Verin Do With Verin[Pour] Do
    begin
      Entre_Pave(EntreeX[1],EntreeY[1]);
      If modele in [Double2,Double_T,Double_A,Double_T_A,Double_V] then Entre_Pave(EntreeX[2],EntreeY[2]);
    end;
  End Else
  Begin
    For Pour :=1 To Nb_Alim_Pilote Do With Alim_Pilote[Pour] Do Entre_Pave(X,Y);
    For Pour :=1 To Nb_Carrefour_Pilote Do With Carrefour_Pilote[Pour] Do Entre_Pave(X,Y);
    For Pour :=1 to Nb_Distributeur Do With Distributeur[Pour] Do
    begin
      If Com[1].Quoi In [Pilote_Gauche] Then Entre_Pave(ExtX[-1],ExtY[-1]);
      If Com[2].Quoi In [Pilote_Droit] Then Entre_Pave(ExtX[0],ExtY[0]);
    end;
    For Pour :=1 to Nb_Capteur Do With Capteur[Pour] Do For Pour2:=1 To 3 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
    For Pour :=1 to Nb_Memoire Do With memoire[Pour] Do For Pour2:=1 To 4 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
    For Pour :=1 to Nb_Sequenceur Do With Sequenceur[Pour] Do
    begin
      For Pour2:=1 To combien Do
      begin
        Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
        Entre_Pave(ExtX[Pour2+8],ExtY[Pour2+8]);
      end;
      For Pour2:=17 To 22 Do Entre_Pave(ExtX[Pour2],ExtY[Pour2]);
    end;
  End;
  Entrepoint:=True;
  DRA:=TRUE;
  Distance:=100000;
  x:=Old_X;Y:=Old_Y;
  WHILE DRA DO
  BEGIN
    Croix(X,Y);
    gauche:=false;
    Droite:=False;
    While  (Not Gauche) And (Not Droite) And (x=X_S) And (y=Y_S) Do application.processmessages;
    PourPt:=1;While PourPt<=Nb_Point do
    Begin
      Di:=Sqrt(Sqr(1.0*x_S-Les_Points[PourPt,1])+Sqr(1.0*Y_S-Les_Points[PourPt,2]));
      If (Di<4) And (Di>1) Then
      Begin
        x_S:=Round(Les_Points[PourPt,1]);
        Y_S:=Round(Les_Points[PourPt,2]);
        PourPt:=Nb_Point+1;
      End;
      Inc(PourPt);
    End;
    Croix(x,Y);
    X:=X_S;Y:=Y_S;
    IF Droite Then
    Begin
      Entrepoint:=False;
      form1.image1.cursor:=crarrow;
      Exit;
    End Else
    If Gauche Then
    Begin
      If Puissance Then For Pour :=1 To Nb_Alimentation Do With Alimentation[Pour] Do
      Begin
        D:=Dista(X,Y);
        If D<Distance Then
        Begin
          Distance:=D;
          Xd:=X;Yd:=Y;
          Branche.Quoi:=Une_Alim;
          Branche.Lequel:=Pour;
          Branche.Branchement:=0;
        End;
      End;
      If Puissance Then For Pour :=1 To Nb_Carrefour Do With Carrefour[Pour] Do
      Begin
        D:=Dista(X,Y);
        If D<Distance Then
        Begin
          Distance:=D;
          Xd:=X;Yd:=Y;
          Branche.Quoi:=Un_Carrefour;
          Branche.Lequel:=Pour;
          Branche.Branchement:=0;
        End;
      End;
      If Not Puissance Then For Pour :=1 To Nb_Alim_Pilote Do With Alim_Pilote[Pour] Do
      Begin
        D:=Dista(X,Y);
        If D<Distance Then
        Begin
          Distance:=D;
          Xd:=X;Yd:=Y;
          Branche.Quoi:=Une_Alim_Pilote;
          Branche.Lequel:=Pour;
          Branche.Branchement:=0;
        End;
      End;
      If Not Puissance Then For Pour :=1 To Nb_Carrefour_Pilote Do With Carrefour_Pilote[Pour] Do
      Begin
        D:=Dista(X,Y);
        If D<Distance Then
        Begin
          Distance:=D;
          Xd:=X;Yd:=Y;
          Branche.Quoi:=Un_Carrefour_Pilote;
          Branche.Lequel:=Pour;
          Branche.Branchement:=0;
        End;
      End;
      If Puissance Then For Pour :=1 to Nb_Distributeur Do With Distributeur[Pour] Do
      Begin
        If Modele=_5_2 Then Combien:=5 Else Combien:=4;
        For Pour2:=1 To Combien Do
        Begin
          D:=Dista(ExtX[Pour2],ExtY[Pour2]);
          If (Not((Pour2=3) And (Modele=_3_2))) And
             (Not((Pour2 in [2,3]) And (Modele in [_2_2,_2_2_])))
             Then If D<Distance Then
          Begin
            Distance:=D;
            Xd:=ExtX[Pour2];Yd:=ExtY[Pour2];
            Branche.Quoi:=Un_D;
            Branche.Lequel:=Pour;
            Branche.Branchement:=Pour2;
          End;
        End;
      End;
      If Not Puissance Then For Pour :=1 to Nb_Distributeur Do With Distributeur[Pour] Do
      Begin
        For Pour2:=-1 To 0 Do
        Begin
          D:=Dista(ExtX[Pour2],ExtY[Pour2]);
          If Not((Pour2=3) And (Modele=_3_2)) Then If D<Distance Then
          Begin
            Distance:=D;
            Xd:=ExtX[Pour2];Yd:=ExtY[Pour2];
            Branche.Quoi:=Un_D;
            Branche.Lequel:=Pour;
            Branche.Branchement:=Pour2;
          End;
        End;
      End;
      If Puissance Then For Pour:=1 to Nb_Verin Do With Verin[Pour] Do
      For Pour2:=1 To 2 Do
      Begin
        D:=Dista(EntreeX[Pour2],EntreeY[Pour2]);
        If D<Distance Then
        Begin
          Distance:=D;
          Xd:=EntreeX[Pour2];Yd:=EntreeY[Pour2];
          Branche.Quoi:=Un_V;
          Branche.Lequel:=Pour;
          Branche.Branchement:=Pour2;
        End;
      End;
      If Not Puissance Then For Pour :=1 to Nb_Capteur Do With Capteur[Pour] Do
      Begin
        For Pour2:=1 To 3 Do
        Begin
          D:=Dista(ExtX[Pour2],ExtY[Pour2]);

          If D<Distance Then
          Begin
            Distance:=D;
            Xd:=ExtX[Pour2];Yd:=ExtY[Pour2];
            Branche.Quoi:=Un_Cap;
            Branche.Lequel:=Pour;
            Branche.Branchement:=Pour2;
          End;
        End;
      End;
      If Not Puissance Then For Pour :=1 to Nb_Memoire Do With memoire[Pour] Do
      Begin
        For Pour2:=1 To 4 Do
        Begin
          D:=Dista(ExtX[Pour2],ExtY[Pour2]);
          If D<Distance Then
          Begin
            Distance:=D;
            Xd:=ExtX[Pour2];Yd:=ExtY[Pour2];
            Branche.Quoi:=Une_memoire;
            Branche.Lequel:=Pour;
            Branche.Branchement:=Pour2;
          End;
        End;
      End;
      If Not Puissance Then For Pour :=1 to Nb_Sequenceur Do With Sequenceur[Pour] Do
      Begin
        For Pour2:=1 To 22 Do
        Begin
         D:=Dista(ExtX[Pour2],ExtY[Pour2]);
         If D<Distance Then
          Begin
            Distance:=D;
            Xd:=ExtX[Pour2];Yd:=ExtY[Pour2];
            Branche.Quoi:=Un_Sequenceur;
            Branche.Lequel:=Pour;
            Branche.Branchement:=Pour2;
          End;
        End;
      End;
      If Distance<6 Then
      Begin
        Nx:=Xd;Ny:=Yd;
        dra:=false;
        If Not Ext then Ext:=True Else Ext:=False;
      End Else
      Begin
        If Not Ext then
        Begin
          dra:=false;
          NX:=X_s;Ny:=Y_S;
         End;
      End;
    End;
  END;
  form1.image1.cursor:=crarrow;
  Couleur(clblack);
END;

Procedure Affiche_Canal(Numero:Smallint;Blanc:Boolean);
Var Pour:Smallint;
    Xe,Ye:single;
Begin
  SetLinestyle(pssolid,2);
  With Canal[Numero] Do
  Begin
    If Not Blanc Then
    begin
       If Etat=un Then Couleur(clred) Else Couleur(clblack)
    end else Couleur(clblack);
    Xe:=ParcoursX[1];Ye:=ParcoursY[1];
    For Pour := 2 To NbPoint Do
    Begin
      Ligne(Xe,Ye,ParcoursX[Pour],ParcoursY[Pour]);
      Xe:=ParcoursX[Pour];Ye:=ParcoursY[Pour];
    End;
  End;
  Couleur(clblack);SetLinestyle(pssolid,1);
End;

Procedure Affiche_Canal_Pilote(Numero:Smallint;Blanc:Boolean);
Var Pour:Smallint;
    Xe,Ye:single;
Begin
  With Canal_Pilote[Numero] Do
  Begin
    If Not Blanc Then
    Case etat of
      0:Couleur(clblack);
      1:Couleur(clfuchsia);
      2:Couleur(clgray);
    End;
    Xe:=ParcoursX[1];Ye:=ParcoursY[1];
    For Pour := 2 To NbPoint Do
    Begin
      ligne(Xe,Ye,ParcoursX[Pour],ParcoursY[Pour]);
      Xe:=ParcoursX[Pour];Ye:=ParcoursY[Pour];
    End;
  End;
  Couleur(clblack);
End;

Procedure Affiche_Alimentation(Numero,C:tcolor;Blanc:Boolean);
Begin
  With Alimentation[Numero] Do
  Begin
    If Not Blanc Then Couleur(C) else couleur(clblack);
    Cercle(X,Y,ARayon);
   If Not Blanc Then Npavepetit(x,y-0.2,c) else Npavepetit(x,y-0.2,clblack);
  End;
  Couleur(clblack);
End;

Procedure Affiche_Alim_Pilote(Numero,C:tcolor;Blanc:Boolean);
Begin
  With Alim_Pilote[Numero] Do
  Begin
    If Not Blanc Then Couleur(C) else couleur(clblack);
    Cercle(X,Y,ARayon);
    If Not Blanc Then Npavepetit(x,y-0.2,c) else Npavepetit(x,y-0.2,clblack);
  End;
  Couleur(clblack);
End;

Procedure Affiche_Carrefour(Numero:Smallint;Blanc:Boolean);
var co:Tcolor;
Begin
  If Not Blanc then co:=clred Else Co:=clblack;
  nPavepetit(Carrefour[Numero].X,Carrefour[Numero].Y,co);
End;

Procedure Affiche_Carrefour_Pilote(Numero:Smallint;Blanc:Boolean);
var co:Tcolor;
Begin
  If Not Blanc then co:=clpurple Else Co:=clblack;
  nPavepetit(Carrefour_Pilote[Numero].X,Carrefour_Pilote[Numero].Y,co);
End;

Procedure Affiche_Texte(Numero,C:tcolor);
Begin
  Couleur(C);
  With feuille do  With Texte[Numero] Do
  Begin
    feuille.font.height:=round(lataille*8*facteur)+4;
   Otxy(Round(X),Round(Y-lataille*6-4),Le_Texte);
    feuille.font.height:=round(8*facteur);
  End;
  Couleur(clblack);
End;

Procedure Redessprinc(Blanc:Boolean);
Var Pour:Smallint;
Begin
  feuille.font.height:=10;
  For Pour :=1 To Nb_Canal        Do Affiche_Canal(Pour,Blanc);
  For Pour :=1 To Nb_Canal_Pilote Do Affiche_Canal_Pilote(Pour,Blanc);
  For Pour :=1 To NB_Verin        Do Affiche_Verin(Pour,clblack,Blanc);
  For Pour :=1 To Nb_Distributeur Do Affiche_Distributeur(Pour,clblack,Blanc);
  For Pour :=1 To Nb_Capteur      Do Affiche_Capteur(Pour,clblack,Blanc);
  For Pour :=1 To Nb_Alimentation Do Affiche_Alimentation(Pour,clred,Blanc);
  For Pour :=1 To Nb_Alim_Pilote  Do Affiche_Alim_Pilote(Pour,clpurple,Blanc);
  For Pour :=1 To Nb_Carrefour_Pilote  Do Affiche_Carrefour_Pilote(Pour,Blanc);
  For Pour :=1 To Nb_Carrefour  Do Affiche_Carrefour(Pour,Blanc);
  For Pour :=1 To Nb_Memoire  Do Affiche_Memoire(Pour,clblack,Blanc);
  For Pour :=1 To Nb_Sequenceur  Do Affiche_Sequenceur(Pour,Blanc);
  For Pour :=1 to Nb_Texte Do Affiche_Texte(Pour,clblack);
  feuille.font.height:=10;
End;

Procedure Redess(Blanc:Boolean);
begin
  ClearDevice;
  Redessprinc(Blanc);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Svg:=false;pasapas:=true;
  DoubleBuffered:=True;
  facteur:=1.1;
  fichiermodifie:=false;
  Feuille:=Form1.Image1.canvas;
  heure:=False;
  Super_Raz;
  if  ParamCount>0 then
  begin
    NomdeFichier:=changefileext(ParamStr(1),'.PWW');
    Lecturede(nomdefichier);
    form1.Caption :='PFFF '+ExtractFilename(NomdeFichier);
  end;
  redess(false);
  SetLinemode(pmcopy);
  compteursouris:=0;
  MetaFile := TMetaFile.Create;
  immonde_rustine_double_v:=false;
  immonde_rustine_galet_v:=false;
end;

procedure cestfini;
begin
  actionencours:=false;
  Redess(False);
  PetitMenu(clwhite,'Pfff');
  form1.image1.cursor:=crarrow;
  Couleur(clblack);
  changemenu;
end;

PROCEDURE Entre_Canal(Var Encore:Boolean);
VAR        XL,YL,Old_Xl,Old_Yl,Xfin,YFin:single;
           Debut,Ext:Boolean;
           Branche:T_Bout;
BEGIN
  petitMenu(clred,'<Circuit de Puissance>  L''origine et l''extrémité sont placées sur les points d''accrochage , bouton droit = Retour');
  With Canal[NB_Canal] Do
  Begin
    Ext:=True;Debut:=True;NbPoint:=0;
    Old_XL:=x_S;Old_YL:=y_S;
    REPEAT
      If NbPoint>9 Then
      Begin
        NbPoint:=0;
        Encore:=False;
        Exit;
      End;
      If Not Entrepoint(True,Round(Old_Xl),Round(Old_Yl),Ext,XL,YL,Branche) Then
      Begin
        NbPoint:=0;
        Encore:=False;
        Exit;
      End;
      If Debut Then
      Begin
        Bout[1]:=Branche;
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XL;
        ParcoursY[NbPoint]:=YL;
      End;
      If Ext Then
      Begin
        Xfin:=XL;Yfin:=YL;
        Bout[2]:=Branche;
      End;
      If Not Debut Then
      Begin
        If abs(Old_XL-XL)<=(Abs(Old_YL-YL)) Then XL:=Old_XL Else YL:=Old_YL;
        LIgne(XL,Yl,Old_Xl,Old_Yl);
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XL;
        ParcoursY[NbPoint]:=YL;
      End;
      Old_Xl:=XL;Old_Yl:=YL;
      If Ext Then
      Begin
        LIgne(XL,Yl,xFIN,YFin);
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XFin;
        ParcoursY[NbPoint]:=YFin;
      End;
      Debut:=False;
    Until Ext;
  End;
End;

PROCEDURE Entre_Canal_Pilote(Var Encore:Boolean);
VAR        XL,YL,Old_Xl,Old_Yl,Xfin,YFin:single;
           Debut,Ext:Boolean;
           Branche:T_Bout;
BEGIN
  PetitMenu(clfuchsia,'<Circuit de  Commande>  L''origine et l''extrémité sont placées sur les points d''accrochage , bouton droit = Retour');
  With Canal_Pilote[NB_Canal_Pilote] Do
  Begin
    Ext:=True;Debut:=True;NbPoint:=0;
    Old_XL:=x_S;Old_YL:=y_S;
    REPEAT
      If NbPoint>9 Then
      Begin
        NbPoint:=0;
        Encore:=False;
        Exit;
      End;
      If Not Entrepoint(False,Round(Old_Xl),Round(Old_Yl),Ext,XL,YL,Branche) Then
      Begin
        NbPoint:=0;
        Encore:=False;
        Exit;
      End;
      If Debut Then
      Begin
        Bout[1]:=Branche;
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XL;
        ParcoursY[NbPoint]:=YL;
      End;
      If Ext Then
      Begin
        Xfin:=XL;Yfin:=YL;
        Bout[2]:=Branche;
      End;
      If Not Debut Then
      Begin
        If abs(Old_XL-XL)<=(Abs(Old_YL-YL)) Then XL:=Old_XL Else YL:=Old_YL;
        ligne(XL,Yl,Old_Xl,Old_Yl);
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XL;
        ParcoursY[NbPoint]:=YL;
      End;
      Old_Xl:=XL;Old_Yl:=YL;
      If Ext Then
      Begin
        ligne(XL,Yl,xFIN,YFin);
        Inc(NbPoint);
        ParcoursX[NbPoint]:=XFin;
        ParcoursY[NbPoint]:=YFin;
      End;
      Debut:=False;
    Until Ext;
  End;
End;

Procedure Cree_Canal;
Var Pour:Smallint;
    Pouet,Encore:Boolean;
Begin
  Encore:=True;
  If Nb_Canal=Max_Canal Then Encore:=False;
  While Encore Do
  Begin
    Inc(NB_Canal);
    FillChar(Canal[Nb_Canal],SizeOf(Canal[Nb_Canal]),0);
    Entre_Canal(Encore);
    Pouet:=False;
    If Canal[Nb_Canal].NBPoint=0 Then Pouet:=True;
    With Canal[Nb_Canal] Do
    Begin
      X:=ParcoursX[1];
      Y:=ParcoursY[1];
      If Not Pouet Then For Pour :=1 To 2 Do
      Begin
        If  (Bout[Pour].Quoi=Une_Alim) And (Bout[3-Pour].Quoi=Une_Alim) Then Pouet:=True;
        If  (Bout[Pour].Quoi=Un_D) And (Bout[3-Pour].Quoi=Un_D) And (Bout[1].Lequel=Bout[2].Lequel) Then  pouet:=True;
        If  (Bout[Pour].Quoi=Un_V) Then
            Begin
              If (Bout[3-Pour].Quoi=Un_V) Then Pouet:=True;
              If (Verin[Bout[Pour].Lequel].Modele=Simple_R) And (Bout[Pour].Branchement=2)  Then Pouet:=True;
              If  (Verin[Bout[Pour].Lequel].Modele=R_Simple) And (Bout[Pour].Branchement=1)  Then Pouet:=True;
            End;
      End;
    End;
    If Pouet Then Dec(Nb_Canal);
    If Nb_Canal=Max_Canal Then Encore:=False;
  End;
End;

Procedure Cree_Canal_Pilote;
Var Pour:Smallint;
    Pouet:Boolean;
    Encore:Boolean;
Begin
  Encore:=True;
  If Nb_Canal_Pilote=Max_Canal_Pilote Then Encore:=False;
  While Encore Do
  Begin
    Inc(NB_Canal_Pilote);
    FillChar(Canal_Pilote[Nb_Canal_Pilote],SizeOf(Canal_Pilote[Nb_Canal_Pilote]),0);
    Entre_Canal_Pilote(Encore);
    Pouet:=False;
    If Canal_Pilote[Nb_Canal_Pilote].NBPoint=0 Then Pouet:=True;
    With Canal_Pilote[Nb_Canal_Pilote] Do
    Begin
      X:=ParcoursX[1];
      Y:=ParcoursY[1];
      If Not Pouet Then For Pour :=1 To 2 Do
      Begin
        If  (Bout[Pour].Quoi=Une_Alim_Pilote) And (Bout[3-Pour].Quoi=Une_Alim_Pilote) Then Pouet:=True;
        If  (Bout[Pour].Quoi=Un_Cap) And (Bout[3-Pour].Quoi=Un_Cap) And (Bout[1].Lequel=Bout[2].Lequel) Then pouet:=True;
      End;
    End;
    If Pouet Then Dec(Nb_Canal_Pilote);
    If Nb_Canal_Pilote=Max_Canal_Pilote Then Encore:=False;
  End;
End;

Procedure Pointe_Objet(Var Objet:Type_;Var Celui_La:Smallint;Co:tcolor);
Type Point=Array[1..2] Of Smallint;
VAR Pour,X,Y,Pour2,Combien:Smallint;
    Di,D,Xd,Yd:single;
    Nombre:Smallint;
    c:Char;
    PourPt:Smallint;
    Prox:single;
    acote:boolean;

procedure croix(x,Y:Smallint);
begin
  SetLinemode(pmnot);
  if Objet<>Action Then
  Begin
    ligne(x,y-50,x,y+50);
    ligne(x-50,y,x+50,y);
  End;
  setlinemode(pmCopy);
end;

Function Dist(X,Y:single):Boolean;
Begin
  Dist:=Sqrt(Sqr(x_S-X*facteur)+Sqr(Y_S-Y*facteur))<Prox;
End;

Procedure PaveP(X,Y:single);
Begin
  nPAVE(x,y,co);
  If Nb_Point<200 Then Inc(Nb_Point);
  Les_Points[Nb_Point,1]:=X*facteur;
  Les_Points[Nb_Point,2]:=Y*facteur;
End;

BEGIN
  form1.image1.cursor:=crhandpoint;acote:=false;
  If Objet=action then prox:=13 else prox:=10;
  Nb_Point:=0;
  Couleur(Co);
  If (Objet=Tout) or (Objet=Toutsaufcanal)Then
  begin
    For Pour :=Vieux_Nb_Alim+1 To Nb_Alimentation Do With Alimentation[Pour] Do PaveP(X,Y);
    For Pour :=Vieux_Nb_Alim_Pilote+1 To Nb_Alim_Pilote Do With Alim_Pilote[Pour] Do PaveP(X,Y);
    For Pour:=Vieux_Nb_Verin+1 to Nb_Verin Do With Verin[Pour] Do PaveP(X,Y);
    For Pour :=Vieux_Nb_memoire+1 to Nb_memoire Do With memoire[Pour] Do PaveP(X,Y);
    For Pour :=Vieux_Nb_Sequenceur+1 to Nb_Sequenceur  Do With Sequenceur[Pour] Do PaveP(X,Y) ;
    For Pour :=Vieux_Nb_Carrefour+1 to Nb_Carrefour Do With Carrefour[Pour] Do PaveP(X,Y);
    For Pour :=Vieux_Nb_Carrefour_Pilote+1 to Nb_Carrefour_Pilote Do  With Carrefour_Pilote[Pour] Do PaveP(X,Y);
    For Pour:=1 To Nb_Texte Do With Texte[Pour] Do PaveP(X,Y);
  end;
  If (Objet=Tout) Then
  begin
    For Pour :=Vieux_Nb_Canal+1 to Nb_Canal Do With Canal[Pour] Do PaveP((ParcoursX[2]+ParcoursX[1])/2,(ParcoursY[2]+ParcoursY[1])/2);
    For Pour :=Vieux_Nb_Canal_Pilote+1 to Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do  PaveP((ParcoursX[2]+ParcoursX[1])/2,(ParcoursY[2]+ParcoursY[1])/2);
  end;
  If (Objet=Action) Or (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Distributeur+1 to Nb_Distributeur Do
    With Distributeur[Pour] Do If  (Objet=Tout)  or (Objet=Toutsaufcanal) Or (Com[1].Quoi In [Poussoir_Gauche]) Then PaveP(X,Y);

  If (Objet=Action) Or (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Capteur+1 to Nb_Capteur
  Do With Capteur[Pour] Do If (Objet=Tout) or (Objet=Toutsaufcanal) Or (Modele In [A_Poussoir,A_Levier,A_Poussoir_Bistable,A_Levier_Bistable]) Then PaveP(X,Y);

  X:=X_S;Y:=Y_S;
  If Objet=action then PaveP(20,30);
  WHILE true DO
  BEGIN
   If Objet=action then Affiche_Temps(20,30,false);
   if acote then form1.image1.cursor:=crhandpoint else form1.image1.cursor:=crcross;
   gauche:=false;Droite:=False;
    While (Not Gauche)And (Not Droite) And (x=X_S) And (y=Y_S) Do application.processmessages;
    acote:=false;
    PourPt:=1;While PourPt<=Nb_Point do
    Begin
      Di:=Sqrt(Sqr(1.0*x_S-Les_Points[PourPt,1])+Sqr(1.0*Y_S-Les_Points[PourPt,2]));
      If (Di<5) {And (Di>1)} Then
      Begin
      acote:=true;
        x_S:=Round(Les_Points[PourPt,1]);
        Y_S:=Round(Les_Points[PourPt,2]);
        PourPt:=Nb_Point+1;
      End;
      Inc(PourPt);
    End;
    X:=X_S;Y:=Y_S;
    IF Droite Then
    Begin
      Objet:=Rien;
      Celui_La:=0;
      form1.image1.cursor:=crarrow;
      Exit;
    End Else
    If Gauche Then
    Begin
      If Heure Then
      Begin
        If dist(20,30) then
        Begin
          Celui_La:=255;
          Objet:=Temps;Exit;
        End;
      End;
      If (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Alim+1 To Nb_Alimentation Do With Alimentation[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Une_Alim;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Carrefour+1 To Nb_Carrefour Do With Carrefour[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_Carrefour;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Carrefour_Pilote+1 To Nb_Carrefour_Pilote Do
      With Carrefour_Pilote[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_Carrefour_Pilote;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Alim_Pilote+1 To Nb_Alim_Pilote Do
      With Alim_Pilote[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Une_Alim_Pilote;Celui_La:=Pour;Exit;
        End;
      End;
      If  (Objet=Action) Or (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Distributeur+1 to Nb_Distributeur Do
      With Distributeur[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_D;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour:=Vieux_Nb_Verin+1 to Nb_Verin Do With Verin[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_V;Celui_La:=Pour;Exit;
        End;
      End;
      If  (Objet=Action) Or (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_Capteur+1 to Nb_Capteur Do
      With Capteur[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_Cap;Celui_La:=Pour;Exit;
        End;
      End;
      If  (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_memoire+1 to Nb_memoire Do
      With memoire[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Une_memoire;Celui_La:=Pour;Exit;
        End;
      End;
      If  (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=Vieux_Nb_sequenceur+1 to Nb_sequenceur Do
      With sequenceur[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_Sequenceur;Celui_La:=Pour;Exit;
        End;
      End;
      If  (Objet=Tout) or (Objet=Toutsaufcanal) Then For Pour :=1 to Nb_Texte Do
      With Texte[Pour] Do
      Begin
        If Dist(X,Y) Then
        Begin
          Objet:=Un_Texte;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) Then For Pour :=1 to Nb_Canal Do With Canal[Pour] Do
      Begin
        If dist( (ParcoursX[2]+ParcoursX[1])/2,(ParcoursY[2]+ParcoursY[1])/2) then
        Begin
          Objet:=Un_Canal;Celui_La:=Pour;Exit;
        End;
      End;
      If (Objet=Tout) Then For Pour :=1 to Nb_Canal_Pilote Do
      With Canal_Pilote[Pour] Do
      Begin
        If dist( (ParcoursX[2]+ParcoursX[1])/2,(ParcoursY[2]+ParcoursY[1])/2) then
        Begin
          Objet:=Un_Canal_Pilote;Celui_La:=Pour;Exit;
        End;
      End;
    End;
  END;
  Couleur(clblack);
  form1.image1.cursor:=crarrow;
END;

Procedure Efface_Canal(Celui_La:Smallint);
Var Pour:Smallint;
Begin
  For Pour:=Celui_La To Nb_Canal-1 Do Canal[Pour]:=Canal[Pour+1];
  Dec(Nb_Canal);
End;

Procedure Efface_Canal_Pilote(Celui_La:Smallint);
Var Pour:Smallint;
Begin
  For Pour:=Celui_La To Nb_Canal_Pilote-1 Do Canal_Pilote[Pour]:=Canal_pilote[Pour+1];
  Dec(Nb_Canal_Pilote);
End;

Procedure Effacer;
Var Pour,Celui_La:Smallint;
    pour2:byte;
    Pointe_Quoi:Type_;
    On_Efface:Boolean;
Begin
  Celui_La:=1;
  While true Do
  Begin
    PetitMenu(clolive	,'<Effacer>   Bouton droit = Retour');
    Pointe_Quoi:=Tout;
    Pointe_Objet(Pointe_Quoi,Celui_La,clolive	);
    if pointe_quoi=rien then  exit;
    If Pointe_Quoi In [Une_Alim,Un_Carrefour,Un_D,Un_V] Then
    begin
      Pour:=1;While Pour<=Nb_Canal Do With Canal[Pour] Do
      Begin
        On_Efface:=False;
        For Pour2:=1 to 2 do
        Begin
          If (Bout[Pour2].Quoi=Pointe_Quoi) Then
          Begin
            If (Bout[Pour2].Lequel=Celui_La) Then On_Efface:=True;
            If (Bout[Pour2].Lequel>Celui_La) Then
                      Bout[Pour2].Lequel:=(Bout[Pour2].Lequel-1);
          End;
        End;
        If On_Efface Then Efface_Canal(Pour) Else Inc(Pour);
      End;
    end;
    If Pointe_Quoi In [Une_Alim_Pilote,Un_Carrefour_Pilote,Un_Cap,Un_D,
    Une_Memoire,Un_Sequenceur] Then
    begin
      Pour:=1;While Pour <=Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do
      Begin
        On_Efface:=False;
        For Pour2:=1 to 2 do
        Begin
          If (Bout[Pour2].Quoi=Pointe_Quoi) Then
          Begin
            If (Bout[Pour2].Lequel=Celui_La) Then On_Efface:=True;
            If (Bout[Pour2].Lequel>Celui_La) Then
            Bout[Pour2].Lequel:=(Bout[Pour2].Lequel-1);
          End;
        End;
        If On_Efface Then Efface_Canal_Pilote(Pour) Else Inc(Pour);
      end;
    End;
    If Pointe_Quoi=Un_Canal Then
    Begin
      Efface_Canal(Celui_La);
    End Else
    If Pointe_Quoi=Un_Canal_Pilote Then Efface_Canal_Pilote(Celui_La)
    Else If Pointe_Quoi=Un_Cap Then
    Begin
      For Pour:=Celui_La To Nb_Capteur-1 Do Capteur[Pour]:=Capteur[Pour+1];
      Dec(Nb_Capteur);
    End Else
    If Pointe_Quoi=Un_Sequenceur Then
    Begin
      For Pour:=Celui_La To Nb_Sequenceur-1 Do Sequenceur[Pour]:=Sequenceur[Pour+1];
      Dec(Nb_Sequenceur);
    End Else
    If Pointe_Quoi=Une_Memoire Then
    Begin
      For Pour:=Celui_La To Nb_memoire-1 Do memoire[Pour]:=memoire[Pour+1];
      Dec(Nb_memoire);
    End Else
    If Pointe_Quoi=Un_D Then
    Begin
      For Pour:=Celui_La To Nb_Distributeur-1 Do Distributeur[Pour]:=Distributeur[Pour+1];
      Dec(Nb_Distributeur);
    End Else
    If Pointe_Quoi=Un_V Then
    Begin
      For Pour:=Celui_La To Nb_Verin-1 Do Verin[Pour]:=Verin[Pour+1];
      Dec(Nb_Verin);
    End Else
    If Pointe_Quoi=Une_Alim Then
    Begin
      For Pour:=Celui_La To Nb_Alimentation-1 Do Alimentation[Pour]:=Alimentation[Pour+1];
      Dec(Nb_Alimentation);
    End Else
    If Pointe_Quoi=Une_Alim_Pilote Then
    Begin
      For Pour:=Celui_La To Nb_Alim_Pilote-1 Do Alim_Pilote[Pour]:=Alim_Pilote[Pour+1];
      Dec(Nb_Alim_Pilote);
    End Else
    If Pointe_Quoi=Un_Carrefour Then
    Begin
      For Pour:=Celui_La To Nb_Carrefour-1 Do Carrefour[Pour]:=Carrefour[Pour+1];
      Dec(Nb_Carrefour);
    End Else
    If Pointe_Quoi=Un_Texte Then
    Begin
      For Pour:=Celui_La To Nb_Texte-1 Do Texte[Pour]:=Texte[Pour+1];
      Dec(Nb_Texte);
    End Else
    If Pointe_Quoi=Un_Carrefour_Pilote Then
    Begin
      For Pour:=Celui_La To Nb_Carrefour_Pilote-1 Do Carrefour_Pilote[Pour]:=Carrefour_Pilote[Pour+1];
      Dec(Nb_Carrefour_Pilote);
    End;
    Redess(False);
  End;
End;

Procedure Cree_Alimentation(Xe,Ye:single);
Begin
  Inc(Nb_Alimentation);
  With Alimentation[Nb_Alimentation] Do
  Begin
    X:=Xe;Y:=Ye;
  End;
End;

Procedure Cree_Alim_Pilote(Xe,Ye:single);
Begin
  Inc(Nb_Alim_Pilote);
  With Alim_Pilote[Nb_Alim_Pilote] Do
  Begin
    X:=Xe;Y:=Ye;
  End;
End;

Procedure Cree_Carrefour(Xe,Ye:single);
Begin
  Inc(Nb_Carrefour);
  With Carrefour[Nb_Carrefour] Do
  Begin
    X:=Xe;Y:=Ye;
    Etat:=zero;
  End;
End;

Procedure Cree_Carrefour_Pilote(Xe,Ye:single);
Begin
  Inc(Nb_Carrefour_Pilote);
  With Carrefour_Pilote[Nb_Carrefour_Pilote] Do
  Begin
    X:=Xe;Y:=Ye;
    Etat:=bof;
  End;
End;

Procedure Ou_Que(Var Old_X,Old_Y:Smallint;panoramique:Boolean;Var Objet:Type_);
VAR   X,Y:Smallint;


procedure croix(x,Y:Smallint);
Var h,v,H2,H3,V2:Smallint;
begin
  setlinemode(pmnot);
  If Not Panoramique then
  Begin
    V:=Round(7/4*CLargeur);
    V2:=Round(1/4*CLargeur);
    H:=Round(5/4*Dlargeur);
    H3:=Round(7/4*Dlargeur);
    H2:=Round(L_Bout/2);
    Case Objet Of
       Un_V:Begin
              if not immonde_rustine_double_v then
              begin
                ligne(X,Y+round(VHauteur/2),X+round(VLargeur),Y+round(VHauteur/2));
                ligne(X,Y-round(VHauteur/2),X+round(VLargeur),Y-round(VHauteur/2));
                ligne(X+round(VLargeur),Y-round(VHauteur/2),X+round(VLargeur),Y+round(VHauteur/2));
                Ligne(x+Vlargeur-H2,y+VHauteur/2,x+Vlargeur-H2,y+VHauteur+10);
                Ligne(x+H2,y+VHauteur/2,x+H2,y+VHauteur+10);
              end else
              begin
                ligne(X+round(VHauteur/2),Y,X+round(VHauteur/2),Y-round(VLargeur));
                ligne(X-round(VHauteur/2),Y,X-round(VHauteur/2),Y-round(VLargeur));
                ligne(X-round(VHauteur/2),Y-round(VLargeur),X+round(VHauteur/2),Y-round(VLargeur));
                Ligne(x+VHauteur/2,y-Vlargeur+H2,x+VHauteur+10,y-Vlargeur+H2);
                Ligne(x+VHauteur/2,y-H2,x+VHauteur+10,y-H2);
              end;
            End;
       Un_D:Begin
              ligne(X,Y-DLargeur/2,X+2*DLargeur,Y-DLargeur/2);
              ligne(X,Y+DLargeur/2,X+2*DLargeur,Y+DLargeur/2);
              ligne(X+3*DLargeur-5,Y-DLargeur/2,X+3*DLargeur,Y-DLargeur/2);
              ligne(X+3*DLargeur-5,Y+DLargeur/2,X+3*DLargeur,Y+DLargeur/2);
              ligne(X+2*dlargeur,Y+DLargeur/2,X+2*DLargeur,Y-DLargeur/2);
              ligne(X+3*dlargeur,Y+DLargeur/2,X+3*DLargeur,Y-DLargeur/2);
              Ligne(x+H,y-DLargeur/2,x+H,y-Dlargeur-10);
              Ligne(x+H,y+DLargeur/2,x+H,y+Dlargeur+10);
              Ligne(x+3*DLargeur/2,y+DLargeur/2,x+3*DLargeur/2,y+Dlargeur+10);
              Ligne(x+H3,y-DLargeur/2,x+H3,y-Dlargeur-10);
            End;
       Un_Cap:if not  immonde_rustine_galet_v then
              Begin
               ligne(X-CLargeur/2,Y,X-CLargeur/2,Y+2*CLargeur);
               ligne(X+CLargeur/2,Y,X+CLargeur/2,Y+2*CLargeur);
               Ligne(x+50,y+V,x-50,y+V);
               Arc_De_Cercle(X,Y-DLargeur/3-Dlargeur/8,0,360,DLargeur/7);
              End else
              begin
                ligne(X,Y-CLargeur/2,X+2*CLargeur,Y-CLargeur/2);
                ligne(X,Y+CLargeur/2,X+2*CLargeur,Y+CLargeur/2);
                Ligne(x+7/4*Clargeur,y+50,x+7/4*Clargeur,y-50);
                Arc_De_Cercle(X-DLargeur/3-Dlargeur/8,Y,0,360,DLargeur/7);
              end;
       Une_Cellule:Begin
                     Rect(X-CLargeur/2,Y,X+CLargeur/2,Y+CLargeur);
                     Ligne(x-Clargeur/2,y+V2,x-50,y+V2);
                     Ligne(x+50,y+3*V2,x-50,y+3*V2);
                   End;
       Une_Alim,Une_Alim_Pilote:Cercle(X,Y,ARayon);
       Une_memoire:Rect(X-DMemoire,Y,X+DMemoire,Y+DMemoire);
      else
      begin
         ligne(x-20,y,x+20,y);
         ligne(x,y-20,x,y+20);
      end;
    end
  End;
  setlinemode(pmcopy);
end;

BEGIN
  form1.image1.cursor:=crnone;
  Couleur(clblack);
  x:=x_s;y:=y_s;
  WHILE true DO
  BEGIN
    Croix(X,Y);
    gauche:=false;
    Droite:=False;
    While  (Not Gauche) And (Not Droite) ANd (x=X_S) And (y=Y_S) Do application.processmessages;
    Croix(x,Y);
    X:=X_S;Y:=Y_S;
    If Gauche Then
    Begin
      Old_X:=X;Old_Y:=Y;
      Couleur(clblack);
      form1.image1.cursor:=crarrow;
      Exit;
    End Else If Droite then
    Begin
      Old_X:=X;Old_Y:=Y;
      Couleur(clblack);
      Objet:=Ouste;
      form1.image1.cursor:=crarrow;
      Exit;
    End;
  END;
END;

Procedure Cree_Texte;
Var Xe,Ye:Smallint;
    s:Str16;
    Quoi_Donc:Type_;
    poured:boolean;
Begin
  Xe:=300;Ye:=200;Quoi_Donc:=Un_Texte;
  PetitMenu(clltgray,'<Texte>  Position du texte ? , bouton droit = retour');
  Ou_Que(Xe,Ye,False,Quoi_Donc);
  If Quoi_Donc=Ouste then
  Begin
    Redess(False); PetitMenu(clwhite,'Pfff');Exit;
  End;
  s:=ed('Entrez le texte : ','',poured);
  If S<>'' Then
  Begin
    Inc(Nb_Texte);
    With Texte[Nb_Texte] Do
    Begin
      X:=Xe;
      Y:=Ye;
      Le_Texte:=S;
      lataille:=1;
      Dialogvaleur:=MessageDlg('Hauteur double ?', mtConfirmation,
      [mbYes,mbno,mbcancel], 0);
     Case dialogvaleur of
       id_yes:lataille:=2;
       id_Cancel:lataille:=1;
     end;
    End;
  End;
End;

procedure AD(Var X:single;increment:single);
Begin
  X:=X+Increment;
End;

Procedure Change_Etat_Capteur(Numero:Smallint);
Begin
  Affiche_Capteur(Numero,clwhite,False);
  Capteur[Numero].etat:=3-Capteur[Numero].etat;
  Affiche_Capteur(Numero,clblack,False);
End;

Procedure Place_Capteur_a(Numero,combien:Smallint);
Begin
  If Capteur[Numero].Etat<>Combien Then Change_Etat_Capteur(Numero);
End;

Procedure Place_Distributeur_a(Numero,combien:Smallint);
Begin
  Affiche_Distributeur(Numero,clwhite,False);
  DistriButeur[Numero].etat:=combien;
  Commande[DistriButeur[Numero].Com[1].Laquelle].Etat:=DistriButeur[Numero].etat;
  Commande[DistriButeur[Numero].Com[2].Laquelle].Etat:=DistriButeur[Numero].etat;
  Affiche_Distributeur(Numero,clblack,False);
End;

Procedure Anime;
Var Pour,Pour2,pour3,Celui_La,Fois,Encours:Smallint;
    Le_Type:type_;
    En_Un,En_Deux:Boolean;
    L_Action:Type_;
    Tempo:Byte;

Begin
  Affiche_Temps(20,30,true);
  While true Do
  Begin
    For Pour:=1 To Nb_Distributeur Do With Distributeur[Pour] Do if not (modele in[_4_3,_5_3]) then
       If (COm[2].Quoi=Ressort_Droit) And (Com[1].Quoi=Poussoir_Gauche) then Place_Distributeur_a(pour,1);
    PetitMenu(cllime,'<Exécuter>   Clic ou appui prolongé sur l''horloge pour faire écouler'+
    ' le temps                Bouton Gauche  :  Action           Bouton Droit : Retour ');
    For Pour:=1 To Nb_Distributeur Do with Distributeur[Pour] do if Com[2].Quoi=Ressort_Droit Then
       If Com[1].Quoi<>Pilote_Gauche Then Place_Distributeur_a(Pour,1);
    For Pour:=1 To Nb_Capteur Do with Capteur[Pour] DO
    Begin
      If modele In [A_Poussoir] Then Place_Capteur_a(Pour,1);
      If modele In [A_Galet,a_Galet_V] Then
      begin
        Place_Capteur_a(Pour,1);
        for pour3:=1 to nb_verin do  if not(verin[pour3].modele=double_V) then
        begin
          if (round(abs(((verin[pour3].X+(verin[pour3].tige-1)*L_Bout+VL_Tige+2*L_Bout)-capteur[pour].x)))< 11)
                                                    and ((verin[pour3].y-capteur[pour].y)<0) and (abs(verin[pour3].y-capteur[pour].y)<40)then Place_Capteur_a(pour,2);
        end else if (round(abs(((verin[pour3].Y-(verin[pour3].tige-1)*L_Bout-VL_Tige-2*L_Bout)-capteur[pour].y)))< 11)
                                                    and ((verin[pour3].x-capteur[pour].x)<0) and (abs(verin[pour3].x-capteur[pour].x)<40) then Place_Capteur_a(pour,2);
      end;
    End;
    L_Action:=Un_Cap;
    While l_Action in [Un_D,Un_Cap] Do
    Begin
      L_Action:=Action;
      Heure:=True;
      If not pasapas then form1.timer2.enabled:=true;
      Pointe_Objet(L_Action,Celui_La,clgreen);
      form1.timer2.enabled:=false;
      Heure:=False;
      If Celui_La=0 Then
      Begin
        Redess(False);
        PetitMenu(clwhite,'Pfff');
        Exit;
      End;
      Case L_Action Of
          Un_D:With Distributeur[Celui_La] Do If (Com[1].QUoi=Poussoir_gauche) And (Com[2].Quoi In [Ressort_Droit,Scie_Droite]) Then
                  place_Distributeur_a(Celui_La,3-distributeur[celui_la].etat);
          Un_Cap:With Capteur[Celui_La] Do Change_Etat_Capteur(Celui_La);
      End;
    End;
    RAZ;
    For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Une_Alim_Pilote) Then Etat:=Un;
    For Pour:=1 To Nb_Canal Do With Canal[Pour] Do Etat:=zero;
    For Fois:=1 To 16 Do
    Begin
      For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do If Etat<>bof Then
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_Carrefour_Pilote) Then Carrefour_Pilote[Bout[Pour2].Lequel].Etat:=Canal_Pilote[Pour].Etat;

      For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do If Etat<>Bof Then
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_Cap) Then If Bout[Pour2].Branchement in [1,2] then
          Capteur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=Canal_Pilote[Pour].Etat;

      For Pour:=1 To Nb_Capteur Do With Capteur[Pour] Do
      Begin
        Case Modele Of
          Ou:If ((Etat_Ext[1]=1) Or (Etat_Ext[2]=1)) Then Etat_Ext[3]:=1
                                                     Else If (Etat_Ext[1]<>bof) and (Etat_Ext[2]<>bof) Then Etat_Ext[3]:=0;
          Et:If ((Etat_Ext[1]<>bof) And (Etat_Ext[2]<>Bof)) Then If ((Etat_Ext[1]=1) And (Etat_Ext[2]=1)) Then Etat_Ext[3]:=1 Else Etat_Ext[3]:=0;
          Inhibition:If (Etat_Ext[1]=1) And  (Etat_Ext[2]=0) Then Etat_Ext[3]:=1
                                                             else If (Etat_Ext[1]<>bof) And  (Etat_Ext[2]<>bof) Then  Etat_Ext[3]:=0;
        Else Case Etat Of
               1:If Etat_Ext[2] in [0,1] Then Etat_Ext[3]:=0;
               2:Etat_Ext[3]:=Etat_Ext[2];
             End;
        End;
      End;
      For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do {If Etat=Bof Then }{ ex gros bug la}
      Begin
        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Un_Cap) Then If Bout[Pour2].Branchement=3 then
          If Capteur[Bout[Pour2].Lequel].Etat_Ext[3]<>Bof  Then Etat:=Capteur[Bout[Pour2].Lequel].Etat_Ext[3];

        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Un_Carrefour_Pilote) Then If Carrefour_Pilote[Bout[Pour2].Lequel].Etat=1 Then  Etat:=1;
      End;
      For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do If Etat=1 Then
      Begin
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Une_Memoire) Then
          if Bout[Pour2].Branchement<>3 then Memoire[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=1;
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_Sequenceur) Then Sequenceur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=1;
      End;
      For Pour:=1 To Nb_Memoire Do With Memoire[Pour] Do
      Begin
        If (Etat_Ext[1]=1) And (Etat_Ext[2]<>1) Then etat:=2;
        If (Etat_Ext[1]<>1) And (Etat_Ext[2]=1) Then etat:=1;
        Affiche_memoire(pour,15,false);
      End;
      For Pour:=1 To Nb_Memoire Do With Memoire[Pour] Do
      Begin
        If Etat=1 Then etat_ext[3]:=0 else
        Begin
          If Etat_Ext[4]=1 then Etat_Ext[3]:=1 else etat_ext[3]:=0;
        End;
      End;
      For Pour:=1 To Nb_Canal_Pilote Do
      With Canal_Pilote[Pour] Do If Etat<>1 Then
      Begin
        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Une_Memoire) Then If Bout[Pour2].branchement=3 then   Etat:=Memoire[Bout[Pour2].Lequel].Etat_Ext[3];
        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Un_Sequenceur) Then
          If Sequenceur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]=1 Then Etat:=1
                                                                                Else if Bout[Pour2].Branchement in [9..16,21,22] then

          If Sequenceur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]=0 then  Etat:=0;
      End;
      For Pour:=1 to Nb_Sequenceur Do With Sequenceur[Pour] Do
      Begin
        If Etat_Ext[18]=1 Then Etat:=0;
        If (Etat<>0) And (Etat_Ext[19]=1) then Etat_Ext[Etat+8]:=1;
        If (Etat=Combien) And (Etat_Ext[Etat]=1) Then Etat_Ext[22]:=1 else Etat_Ext[22]:=0;
        If Etat=1 then Etat_Ext[17]:=1;
        If Etat<>0 Then
        Begin
          If Etat<>combien  then
          Begin
            If (Etat_Ext[19]=1) And (Etat_Ext[Etat]=1) Then Etat:=Etat Mod Combien+1;
          End               Else if (Etat_Ext[20]=1) And (Etat_Ext[Etat]=1) then Etat:=1;
        End        Else if Etat_Ext[20]=1 then Etat:=1;
        Affiche_Etat_Sequenceur(Pour);
      End;
    End;
    For Pour:=1 To Nb_Canal_Pilote Do With Canal_Pilote[Pour] Do If Etat=1 Then For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_D) Then
      Distributeur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=1;
    For Pour:=1 To Nb_Distributeur Do With Distributeur[Pour] Do
    Begin
      if not (modele in[_4_3,_5_3]) then
      begin
         If Etat_Ext[-1]=1 Then
         Begin
           If Etat_Ext[0]=0 Then Place_distributeur_a(Pour,2);
         End Else
         Begin
           If ((COm[2].Quoi=Ressort_Droit) and (modele<>_2_2)) Or (Etat_Ext[0]=1) then Place_Distributeur_a(pour,1);
         End;
     end else
     begin
        If (Etat_Ext[-1]=1) and (Etat_Ext[0]=0) then Place_distributeur_a(Pour,2)
                                                else If (Etat_Ext[-1]=0) and (Etat_Ext[0]=1) then Place_distributeur_a(Pour,3)
                                                                             else If (Etat_Ext[-1]=0) and (Etat_Ext[0]=0)    then Place_distributeur_a(Pour,1)
     end;
    end;
    For Pour:=1 To Nb_Canal Do With Canal[Pour] Do For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Une_Alim) Then Etat:=un;
    For Fois:=1 To 4 Do
    Begin
      For Pour:=1 To Nb_Canal Do With Canal[Pour] Do If Etat in [bouche,un] Then For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_Carrefour) Then
        Carrefour[Bout[Pour2].Lequel].Etat:=etat;
      For Pour:=1 To Nb_Canal Do With Canal[Pour] Do If Etat in [UN,Bouche] Then
      Begin
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_D) Then if Bout[Pour2].Branchement=1 then
          Distributeur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=etat;
        For Pour2:=1 To 2 Do If (Bout[Pour2].Quoi=Un_V) Then Verin[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement]:=etat;
      End;
      For Pour:=1 To Nb_Distributeur Do With Distributeur[Pour] Do
      Begin
         if not (modele in[_4_3,_5_3]) then
        Case Etat Of
          1:begin
              Etat_Ext[3]:=Etat_Ext[1];
              if  (modele=_2_2_) then Etat_Ext[4]:=Etat_Ext[1];
              if modele=_2_2 then Etat_Ext[4]:=bouche;
            End;
          2:if not (modele=_2_2_) then Etat_Ext[4]:=Etat_Ext[1] else Etat_Ext[4]:=bouche;
        End else
        begin
           case etat of
             1: begin Etat_Ext[3]:=bouche;Etat_Ext[4]:=bouche;end;
             2: Etat_Ext[4]:=Etat_Ext[1];
             3: Etat_Ext[3]:=Etat_Ext[1];
           end;
        end;
      End;
      For Pour:=1 To Nb_Canal Do With Canal[Pour] Do If Etat=0 Then
      Begin
        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Un_D) Then if Distributeur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement] in [bouche,un] then
          Etat:=Distributeur[Bout[Pour2].Lequel].Etat_Ext[Bout[Pour2].Branchement];
        For Pour2:= 1 To 2 Do If (Bout[Pour2].Quoi=Un_Carrefour) Then if Carrefour[Bout[Pour2].Lequel].etat in [bouche,un] then
          Etat:=Carrefour[Bout[Pour2].Lequel].Etat;
      End;
    End;
    For Pour:=1 To Nb_Canal Do Affiche_Canal(Pour,False);
    For Pour:=1 To Nb_Canal_Pilote Do Affiche_Canal_Pilote(Pour,False);
    For Pour:=1 To Nb_Verin Do With Verin[Pour] Do
    Begin
      En_Un:=  Etat_Ext[1]=1;
      En_Deux:=Etat_Ext[2]=1;
      Case Modele Of
        Simple_R,R_Simple:
        Begin
          If modele=r_SImple then En_Un:=En_Deux;
          If En_Un Then
          Begin
            If Tige<9 Then
            Begin
              Affiche_Verin(Pour,clwhite,False);
              Inc(Tige);
              Affiche_Verin(Pour,clblack,False);
            End;
          End      Else
          if not ((modele=SImple_r) and (Etat_Ext[1]=bouche)) then if not ((modele=r_SImple) and (Etat_Ext[2]=bouche)) then If (Tige>2) Then
          Begin
            Affiche_Verin(Pour,clwhite,False);
            Dec(Tige);
            Affiche_Verin(Pour,clblack,False);
          End;
        End;
        Double2,Double_T,DouBle_A,Double_T_A,double_V:
        Begin
          If En_Un And En_Deux Then
          Begin
            PetitMenu(clred,'Les deux chambres du vérin sont alimentées !');
            Pause;
          End Else If Not En_Un And Not En_Deux Then
          Begin
            PetitMenu(clred,'Aucune chambre n''est alimentée !');
            Pause;
          End                                   Else
          If En_Un Then
          Begin
            If(Verin[Pour].Tige<9) Then if not (Etat_Ext[2]=bouche) then
            Begin
              Affiche_Verin(Pour,clwhite,False);
              Inc(Verin[Pour].Tige);
              Affiche_Verin(Pour,clblack,False);
            End;
          End      Else If (Verin[Pour].Tige>2) Then if not (Etat_Ext[1]=bouche) then
          Begin
            Affiche_Verin(Pour,clwhite,False);
            Dec(Verin[Pour].Tige);
            Affiche_Verin(Pour,clblack,False);
          End;
        End;
      End;
    End;
  End;
End;

Procedure Ajoute_Objet;
Var Objet:Type_;
    Pour,Celui_La,Lax,Lay:Smallint;
    Quoi_Donc:Type_;
    requete:string;
     pour3:integer;
     pasbon:boolean;
Begin
    Objet:=Tout;
    vieux_facteur:=facteur;facteur:=1.1;
    ClearDevice;
    Couleur(clblack);
    petitmenu(clSkyblue,'<Nouveau Composant>   Pointez un composant');
    Vieux_Nb_Verin:=Nb_Verin;
    Vieux_Nb_Distributeur:=nb_Distributeur;
    Vieux_Nb_Capteur:=Nb_Capteur;
    Vieux_Nb_Alim:=Nb_Alimentation;
    Vieux_Nb_Alim_Pilote:=Nb_Alim_Pilote;
    Vieux_Nb_Carrefour_Pilote:=Nb_Carrefour_Pilote;
    Vieux_Nb_Carrefour:=Nb_Carrefour;
    Vieux_Nb_Commande:=Nb_Commande;
    Vieux_Nb_Canal:=Nb_Canal;
    Vieux_Nb_Canal_Pilote:=Nb_Canal_Pilote;
    Vieux_Nb_Memoire:=Nb_Memoire;
    Vieux_Nb_Sequenceur:=Nb_sequenceur;
    Vieux_Nb_Texte:=Nb_Texte;
    Nb_Texte:=0;
    If (Nb_Verin<Max_Verin-4) Then
    Begin
      Cree_Verin(80,30,Simple_R);
      Cree_Verin(80,95,Double2);
      Cree_Verin(45,320,Double_V);
    End;
    If (Nb_Distributeur<Max_Distributeur-14) Then
    Begin
      Cree_Distributeur(270,225,_3_2,Poussoir_Gauche,Scie_Droite,1);
      Cree_Distributeur(608,225,_3_2,Pilote_Gauche,Ressort_Droit,1);
      Cree_Distributeur(430,225,_3_2,Pilote_Gauche,Pilote_Droit,1);
      Cree_Distributeur(270,280,_4_2,Poussoir_Gauche,Scie_Droite,1);
      Cree_Distributeur(608,280,_4_2,Pilote_Gauche,Ressort_Droit,1);
      Cree_Distributeur(430,280,_4_2,Pilote_Gauche,Pilote_Droit,1);
      Cree_Distributeur(270,335,_5_2,Poussoir_Gauche,Scie_Droite,1);
      Cree_Distributeur(608,335,_5_2,Pilote_Gauche,Ressort_Droit,1);
      Cree_Distributeur(430,335,_5_2,Pilote_Gauche,Pilote_Droit,1);
      Cree_Distributeur(270,170,_2_2,Poussoir_Gauche,Scie_Droite,1);
      Cree_Distributeur(430,170,_2_2_,Poussoir_Gauche,Scie_Droite,1);
      Cree_Distributeur(608,170,_2_2,Poussoir_Gauche,Ressort_Droit,1);
      Cree_Distributeur(608,30,_4_3,Pilote_Gauche,Pilote_Droit,1);
      Cree_Distributeur(608,85,_5_3,Pilote_Gauche,Pilote_Droit,1);
      otxy(750,225,'3/2');
      otxy(750,280,'4/2');
      otxy(750,335,'5/2');
      otxy(750,170,'2/2');
      otxy(750,40,'4/3');
      otxy(750,95,'5/3');
      otxy(380,380,'bistables');
      otxy(640,380,'monostables');
    End;
    If (Nb_Capteur<Max_Capteur-7) Then
    Begin
      Cree_Capteur(20,450,A_Poussoir,1);
      Cree_Capteur(70,450,A_Poussoir_Bistable,1);
      Cree_Capteur(120,450,A_Galet,1);
      Cree_Capteur(430,20,Et,1);
      Cree_Capteur(480,20,Ou,1);
      Cree_Capteur(530,20,Inhibition,1);
      Cree_Capteur(170,460,A_Galet_V,1);
    End;
    If (Nb_Memoire<Max_Memoire-1) then  Cree_Memoire(480,80,2);
    If (Nb_Sequenceur<Max_sequenceur-1) Then
    Begin
      Cree_Sequenceur(20,370,3);
      Sequenceur[Nb_Sequenceur].etat:=1;
      Affiche_Etat_Sequenceur(Nb_Sequenceur);
    End;
    If (Nb_Alimentation<Max_Alimentation-1) then Cree_Alimentation(640,460);
    If (Nb_Alim_Pilote<Max_Alim_Pilote-1) then Cree_Alim_Pilote(640,500);
    If (Nb_Carrefour<Max_Carrefour-1) then Cree_Carrefour(680,460);
    If (Nb_Carrefour_Pilote<Max_Carrefour_Pilote-1) then Cree_Carrefour_Pilote(680,500);
    For Pour:=Vieux_Nb_Verin+1 To Nb_Verin Do Affiche_Verin(Pour,clblack,true);
    For Pour:=Vieux_Nb_Distributeur+1 To Nb_Distributeur Do Affiche_Distributeur(Pour,clblack,true);
    For Pour:=Vieux_Nb_Capteur+1 To Nb_Capteur Do Affiche_Capteur(Pour,clblack,true);
    For Pour:=Vieux_Nb_Alim+1 To Nb_Alimentation Do Affiche_Alimentation(Pour,clred,false);
    For Pour:=Vieux_Nb_Alim_Pilote+1 To Nb_Alim_Pilote Do Affiche_Alim_Pilote(Pour,clfuchsia,false);
    For Pour:=Vieux_Nb_Carrefour_Pilote+1 To Nb_Carrefour_Pilote Do Affiche_Carrefour_Pilote(Pour,false);
    For Pour:=Vieux_Nb_Carrefour+1 To Nb_Carrefour Do Affiche_Carrefour(Pour,false);
    For Pour:=Vieux_Nb_Memoire+1 To Nb_Memoire Do Affiche_Memoire(Pour,15,true);
    For Pour:=Vieux_Nb_Sequenceur+1 To Nb_Sequenceur Do Affiche_Sequenceur(Pour,true);
    Couleur(clred);
    otxy(635,470,'Puissance');
    Couleur(clfuchsia);
    otxy(635,510,'Commande');
    Couleur(clblack);
    otxy(200,490,'Les carrefours doivent étre créés AVANT les canaux les alimentant');
    otxy(150,420,'Placer la roulette des capteurs de position DANS l''extrémité des tiges de vérins');
    otxy(360,130,'Les mémoires doivent étre alimentées');
    Pointe_Objet(Objet,Celui_La,clblue);
    immonde_rustine_double_v:=false;
    immonde_rustine_galet_v:=false;
    if objet=Un_V then if verin[celui_la].modele=double_V then immonde_rustine_double_v:=true;
    if objet=Un_Cap then if capteur[celui_la].modele=a_galet_V then immonde_rustine_galet_v:=true;
    feuille:=form1.image1.canvas;
    Nb_Verin:=Vieux_Nb_Verin;
    nb_Distributeur:=Vieux_Nb_Distributeur;
    Nb_Capteur:=Vieux_Nb_Capteur;
    Nb_Alimentation:=Vieux_Nb_Alim;
    Nb_Alim_Pilote:=Vieux_Nb_Alim_Pilote;
    Nb_Carrefour_Pilote:=Vieux_Nb_Carrefour_Pilote;
    Nb_Carrefour:=Vieux_Nb_Carrefour;
    Nb_Commande:=Vieux_Nb_Commande;
    Nb_Memoire:=Vieux_Nb_Memoire;
    Nb_Sequenceur:=Vieux_Nb_Sequenceur;
    Nb_Texte:=Vieux_Nb_Texte;
    Raz_Vieux;
    facteur:=vieux_facteur;
    ClearDevice;
    If Objet=Rien then
    Begin
      Redess(False);
      PetitMenu(clwhite,'Pfff');
      Exit;
    End;
    Lax:=150;LaY:=150;
    Redess(False);
    PetitMenu(clSkyblue,'<Nouveau Composant>   Position du composant ?');
    If (Objet=Un_Cap) And (Celui_La-Nb_Capteur in [4,5,6]) then
    Begin
      Quoi_donc:=Une_Cellule;
      Ou_Que(Lax,Lay,False,Quoi_Donc);
    End Else
    Begin
      Quoi_Donc:=Objet;
      Ou_Que(Lax,Lay,False,Quoi_Donc);
    End;
    immonde_rustine_double_v:=false;
    immonde_rustine_galet_v:=false;
    If Quoi_Donc=Ouste Then Exit;
    Case Objet Of
      Un_V:Cree_Verin(Lax,Lay,verin[celui_la].modele);
      Un_D:Begin
              Celui_La:=Celui_La-Nb_Distributeur;
              Case Celui_La Of
                1:Cree_Distributeur(Lax,Lay,_3_2,Poussoir_Gauche,Scie_Droite,1);
                2:Cree_Distributeur(Lax,Lay,_3_2,Pilote_Gauche,Ressort_Droit,1);
                3:Cree_Distributeur(Lax,Lay,_3_2,Pilote_Gauche,Pilote_Droit,1);
                4:Cree_Distributeur(Lax,Lay,_4_2,Poussoir_Gauche,Scie_Droite,1);
                5:Cree_Distributeur(Lax,Lay,_4_2,Pilote_Gauche,Ressort_Droit,1);
                6:Cree_Distributeur(Lax,Lay,_4_2,Pilote_Gauche,Pilote_Droit,1);
                7:Cree_Distributeur(Lax,Lay,_5_2,Poussoir_Gauche,Scie_Droite,1);
                8:Cree_Distributeur(Lax,Lay,_5_2,Pilote_Gauche,Ressort_Droit,1);
                9:Cree_Distributeur(Lax,Lay,_5_2,Pilote_Gauche,Pilote_Droit,1);
               10:Cree_Distributeur(Lax,Lay,_2_2,Poussoir_Gauche,Scie_Droite,1);
               11:Cree_Distributeur(Lax,Lay,_2_2_,Poussoir_Gauche,Scie_Droite,1);
               12:Cree_Distributeur(Lax,Lay,_2_2,Poussoir_Gauche,Ressort_Droit,1);
               13:Cree_Distributeur(Lax,Lay,_4_3,Pilote_Gauche,Pilote_Droit,1);
               14:Cree_Distributeur(Lax,Lay,_5_3,Pilote_Gauche,Pilote_Droit,1);
              End;
            End;
      Un_Cap:Begin
                Celui_La:=Celui_La-Nb_Capteur;
                Case Celui_La Of
                  1:Cree_Capteur(Lax,Lay,A_Poussoir,1);
                  2:Cree_Capteur(Lax,Lay,A_Poussoir_Bistable,1);
                  3:begin
                       Cree_Capteur(Lax,Lay,A_Galet,1);
                       pasbon:=true;
                       for pour3:=1 to nb_verin do if (Lax> verin[pour3].X+(0)*L_Bout+VL_Tige+2*L_Bout- 13) and
                                                      (Lax< verin[pour3].X+(9)*L_Bout+VL_Tige+2*L_Bout+ 13) and ((verin[pour3].y-Lay)<0) and
                                                      (abs(verin[pour3].y-Lay)<40)then pasbon:=false;
                        if pasbon then
                        begin
                          Affiche_Capteur(Nb_Capteur,clred,true);
                          Application.MessageBox('Ce capteur fin de course ne semble pas pouvoir être actionné par un vérin existant  !', '(pas) Pfff', MB_OK+MB_ICONEXCLAMATION+MB_DEFBUTTON1+MB_APPLMODAL);
                        end;
                    end;
                  4:Cree_Capteur(Lax,Lay,Et,1);
                  5:Cree_Capteur(Lax,Lay,Ou,1);
                  6:Cree_Capteur(Lax,Lay,Inhibition,1);
                  7:begin
                       Cree_Capteur(Lax,Lay,A_Galet_V,1);
                       pasbon:=true;
                       for pour3:=1 to nb_verin do if (    abs(    (verin[pour3].X-( capteur[Nb_Capteur].x-DLargeur/3-Dlargeur/8  )  )     )< 15   )
                        and (capteur[Nb_Capteur].y> verin[pour3].y-(Maxtige-1)*L_Bout-VL_Tige-1.5*L_Bout-15)
                        and (capteur[Nb_Capteur].y<( verin[pour3].y-(Mintige-1)*L_Bout-VL_Tige-1.5*L_Bout)+10) then pasbon:=false;
                        if pasbon then
                        begin
                          Affiche_Capteur(Nb_Capteur,clred,true);
                          Application.MessageBox('Ce capteur fin de course ne semble pas pouvoir être actionné par un vérin existant  !', '(pas) Pfff', MB_OK+MB_ICONEXCLAMATION+MB_DEFBUTTON1+MB_APPLMODAL);
                        end;
                    end;
                End;
              End;
      Une_Alim:Cree_Alimentation(Lax,Lay);
      Une_Alim_Pilote:Cree_Alim_Pilote(Lax,Lay);
      Un_Carrefour_Pilote:Cree_Carrefour_Pilote(Lax,Lay);
      Un_Carrefour:Cree_Carrefour(Lax,Lay);
      Une_Memoire: Cree_Memoire(Lax,Lay,1);
      Un_Sequenceur:Begin
                      requete:='9';
                      while (length(requete)<>1) or not (requete[1] in ['2'..'8']) do
                      requete:=InputBox('Pfff', 'Entrez le nombre d''étapes (2 à 8)',requete);
                      Cree_Sequenceur(Lax,Lay,strtoint(requete));
                    End;
    End;
End;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  X_s:=x;y_s:=y;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   x_s:=x;y_s:=y;
   Droite:=(button=mbRight);
   Gauche:=(button=mbLeft);
   compteursouris:=0;
end;

procedure TForm1.Composant1Click(Sender: TObject);
begin
    fichiermodifie:=true;
    cacommence;
    Ajoute_Objet;
    feuille:=form1.image1.canvas;
    cestfini;
end;

procedure TForm1.Texte1Click(Sender: TObject);
begin
  cacommence;
  If Nb_Texte<Max_Texte Then
  begin
    fichiermodifie:=true;
    Cree_Texte;
  end;
  cestfini;
end;

procedure TForm1.Efface(Sender: TObject);
begin
  cacommence;
  fichiermodifie:=true;
  Effacer;
  cestfini;
end;

procedure TForm1.Puissance1Click(Sender: TObject);
begin
   cacommence;
   If Nb_Alimentation>0 Then
   begin
    fichiermodifie:=true;
    Cree_Canal;
   end                  else  Application.MessageBox('Il n''y a pas d''alimentation de puissance (rouge)', ' (pas) Pfff', MB_OK+MB_ICONEXCLAMATION+MB_DEFBUTTON1+MB_APPLMODAL);
   cestfini;
end;

procedure TForm1.Commande1Click(Sender: TObject);
begin
  cacommence;
  If Nb_Alim_Pilote>0 Then
  begin
    fichiermodifie:=true;
    Cree_Canal_Pilote;
  end   else  Application.MessageBox('Il n''y a pas d''alimentation de commande (violet)', ' (pas) Pfff', MB_OK+MB_ICONEXCLAMATION+MB_DEFBUTTON1+MB_APPLMODAL);
  cestfini;
end;

procedure TForm1.Anime1Click(Sender: TObject);
begin
  cacommence;
  pasapas:=true;
  Anime;
  cestfini;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  if button=mbright then droite:=false else gauche:=false;
  compteursouris:=0;
end;

procedure TForm1.Ouvrir1Click(Sender: TObject);
begin
  if fichiermodifie then
  begin
     Dialogvaleur:=MessageDlg('Sauver le fichier ?', mtConfirmation,[mbYes,mbno,mbcancel], 0);
     Case dialogvaleur of
       id_yes:Enregregistersous1Click(Self);
       id_Cancel:exit
     end;
  end;
  if openDialog1.execute then
  Begin
    fichiermodifie:=false;
    nomdefichier:=OpenDialog1.Filename;
    Lecturede(nomdefichier);facteur:=1;
  end;
  redess(false);
end;

procedure TForm1.Enregregistersous1Click(Sender: TObject);
Var Pour:Smallint;
    F:File;
Begin
  If SaveDialog1.execute then
  Begin
    nomdefichier:=SaveDialog1.Filename;
    assignfile(F,nomdefichier);
    Pour:=0;
    ReWrite(f,1);
    try
      BlockWrite(f,Nb_Verin,2);
      BlockWrite(f,Nb_Distributeur,2);
      BlockWrite(f,Nb_Commande,2);
      BlockWrite(f,NB_Canal,2);
      BlockWrite(f,NB_Canal_Pilote,2);
      BlockWrite(f,Nb_Alimentation,2);
      BlockWrite(f,Nb_Capteur,2);
      BlockWrite(f,Nb_Alim_Pilote,2);
      BlockWrite(f,Nb_Carrefour,2);
      BlockWrite(f,Nb_Carrefour_Pilote,2);
      BlockWrite(f,Nb_Memoire,2);
      BlockWrite(f,Nb_Sequenceur,2);
      BlockWrite(f,Nb_Texte,2);
      BlockWrite(f,Pour,2);            {R‚serve}
      BlockWrite(f,Pour,2);
      BlockWrite(f,Verin[1],Nb_Verin*SizeOf(Verin[1]));
      BlockWrite(f,Distributeur[1],Nb_Distributeur*SizeOf(Distributeur[1]));
      BlockWrite(f,Commande[1],Nb_Commande*SizeOf(Commande[1]));
      BlockWrite(f,Canal[1],NB_Canal*SizeOf(Canal[1]));
      BlockWrite(f,Canal_Pilote[1],Nb_Canal_Pilote*SizeOf(Canal_Pilote[1]));
      BlockWrite(f,Alimentation[1],Nb_Alimentation*SizeOf(Alimentation[1]));
      BlockWrite(f,Capteur[1],Nb_Capteur*SizeOf(Capteur[1]));
      BlockWrite(f,Alim_Pilote[1],Nb_Alim_Pilote*SizeOf(Alim_Pilote[1]));
      BlockWrite(f,Carrefour[1],Nb_Carrefour*SizeOf(Carrefour[1]));
      BlockWrite(f,Carrefour_Pilote[1],Nb_Carrefour_Pilote*SizeOf(Carrefour_Pilote[1]));
      BlockWrite(f,memoire[1],Nb_Memoire*SizeOf(memoire[1]));
      BlockWrite(f,Sequenceur[1],Nb_Sequenceur*SizeOf(Sequenceur[1]));
      For Pour:=1 to Nb_Texte Do BlockWrite(f,Texte[Pour],SizeOf(Texte[Pour]));
      finally
        Closefile(f);
      end;
      fichiermodifie:=false;
  end;
end;

procedure TForm1.Nouveau1Click(Sender: TObject);
begin
   super_raz; facteur:=1;
   redess(false);
   fichiermodifie:=false;
end;

procedure TForm1.Pressepapier1Click(Sender: TObject);
begin
   ClipBoard.Assign(form1.Image1.picture);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  droite:=true;
  If fichiermodifie then
  begin
    Dialogvaleur:=MessageDlg('Sauver le fichier ?', mtConfirmation,[mbYes,mbno,mbcancel], 0);
    Case dialogvaleur of
      id_yes:Enregregistersous1Click(Self);
      id_Cancel:Canclose:=false;
    end;
  end;
end;

procedure TForm1.Quitter1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Imprimer1Click(Sender: TObject);
Var rect:Trect;
    coef,nbx,nby:Double;
    margex,margey,largeur:Integer;
begin
  nbx:=GetDeviceCaps(Printer.Handle,logpixelsX);
  nby:=GetDeviceCaps(Printer.Handle,logpixelsY);
  Margex:=round(Nbx*10/25.4);
  MargeY:=Round(Nby*10/25.4);
  Printer.Orientation := poPortrait;
  If PrintDialog1.execute Then
  Begin
    With printer Do
    begin
      Printer.Orientation := {poPortrait; }
      poLandscape  ;
      coef:=form1.Image1.height/form1.Image1.Width;
      rect.left:=margex;
      Rect.top:=margey;
      if pagewidth*form1.Image1.height/form1.Image1.Width>pageheight then largeur:=pagewidth
                                                                     else largeur:=round(pageheight*form1.Image1.Width/form1.Image1.height);
      rect.right:=largeur-MargeX;
      rect.bottom:=round(largeur*coef)-MargeY;
      PrintScale:=poproportional;
      BeginDoc;
        Canvas.StretchDraw(rect,form1.Image1.Picture.Graphic);
      EndDoc;
    end;
  end;
end;

procedure TForm1.Apropos1Click(Sender: TObject);
begin
  Aboutbox.copyright.caption:='Montero-Ribas';
  Aboutbox.showmodal
end;

procedure TForm1.Noiretblanc1Click(Sender: TObject);
begin
   redess(true);
end;

procedure TForm1.Sauverlimage1Click(Sender: TObject);
 var JpegImg: TJpegImage;
begin
   If SavePictureDialog1.execute then
   begin
     Nomdefichier:=SavepictureDialog1.Filename;
     nomdefichier:=changefileext(nomdefichier,'.jpg');
     JpegImg := TJpegImage.Create;
   try
   JpegImg.Assign(Form1.image1.picture.Bitmap);
   JpegImg.SaveToFile(nomdefichier);
  finally
    JpegImg.Free
  end;
  end;
end;

procedure TForm1.Couleur1Click(Sender: TObject);
begin
  redess(false);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
   if Key = vk_escape  then droite:=true;
   If (key = 107) then if ssCtrl in Shift then If loupe1.Enabled then loupe1Click(self);
   If (key = 109) then if ssCtrl in Shift then If loupe2.Enabled then Loupe2Click(self);
end;

procedure TForm1.MsPaintBmp1Click(Sender: TObject);
var s1,s3,result:string;
    DossierTemp: array[0..255] of Char;
begin
	result:='C:\';
	if GetTempPath(255, @DossierTemp)<>0 then Result := StrPas(DossierTemp);
  s1:='Mspaint';s3:='';
  Nomdefichier:=result+'Temporaire.bmp';
  try
    Form1.image1.picture.SaveToFile(nomdefichier);
    ShellExecute (handle,'Open', PChar(s1)  ,PChar(Nomdefichier),PChar(s3),SW_SHOWNORMAL);
  finally
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  If compteursouris<10 then inc(compteursouris);
  If compteursouris>4 then If heure then if (GetAsyncKeyState(VK_LBUTTON)And $8000)<>0 Then gauche:=true;
end;

procedure TForm1.SauverlimageEMF1Click(Sender: TObject);
var MetaFileCanvas : TMetaFileCanvas;
begin
  Metafile.height:=form1.Image1.height+1;
  Metafile.width:=form1.Image1.Width;
  SavepictureDialog2.Filename:=changefileext(nomdefichier,'.EMF');
  If SavePictureDialog2.execute then
  begin
    Nomdefichier:=SavepictureDialog2.Filename;
    nomdefichier:=changefileext(nomdefichier,'.EMF');
    MetaFileCanvas := TMetaFileCanvas.Create(MetaFile, 0);
    Feuille:= MetaFileCanvas;
    redessprinc(true);
    MetaFileCanvas.free;
    try
      MetaFile.SaveToFile(Nomdefichier);
    finally
    end;
  end;
  feuille:=Form1.Image1.Canvas;
end;

procedure TForm1.Loupe1Click(Sender: TObject);
begin
   If facteur>3.5 then exit;
   Facteur:=Facteur*1.1;
   redess(false);
end;

procedure TForm1.Loupe2Click(Sender: TObject);
begin
  If facteur<0.9 then exit;
  Facteur:=Facteur/1.1;
  Redess(False);
end;

procedure TForm1.sortir1Click(Sender: TObject);
begin
  droite:=true;
end;

Function minimumh:Single;
Var Pour:Smallint;
    mini:single;
begin
  mini:=10000;
  For Pour :=1 To Nb_Capteur Do If Capteur[Pour].x<mini then mini:=Capteur[Pour].x;
  For Pour :=1 To Nb_Alimentation  Do If Alimentation[Pour].x<mini then mini:=Alimentation[Pour].x;
  For Pour :=1 To Nb_Alim_pilote Do If Alim_pilote[Pour].x<mini then mini:=Alim_pilote[Pour].x;
  For Pour :=1 To Nb_Carrefour Do If Carrefour[Pour].x<mini then mini:=Carrefour[Pour].x;
  For Pour :=1 To Nb_Carrefour_pilote Do If Carrefour_pilote[Pour].x<mini then mini:=Carrefour_pilote[Pour].x;
  For Pour :=1 To Nb_verin  Do If verin[Pour].x<mini then mini:=verin[Pour].x;
  For Pour :=1 To Nb_Distributeur  Do If Distributeur[Pour].x<mini then mini:=Distributeur[Pour].x;
  For Pour :=1 To Nb_Memoire  Do If Memoire[Pour].x<mini then mini:=Memoire[Pour].x;
  For Pour :=1 To Nb_Sequenceur  Do If Sequenceur[Pour].x<mini then mini:=Sequenceur[Pour].x;
  For Pour:=1 to Nb_Texte Do If Texte[Pour].x<mini then mini:=Texte[Pour].x;
  minimumh:=mini;
end;

Function minimumv:Single;
Var Pour:Smallint;
    mini:single;
begin
  mini:=10000;
  For Pour :=1 To Nb_Capteur Do If Capteur[Pour].y<mini then mini:=Capteur[Pour].y;
  For Pour :=1 To Nb_Alimentation  Do If Alimentation[Pour].y<mini then mini:=Alimentation[Pour].y;
  For Pour :=1 To Nb_Alim_pilote Do If Alim_pilote[Pour].y<mini then mini:=Alim_pilote[Pour].y;
  For Pour :=1 To Nb_Carrefour Do If Carrefour[Pour].y<mini then mini:=Carrefour[Pour].y;
  For Pour :=1 To Nb_Carrefour_pilote Do If Carrefour_pilote[Pour].y<mini then mini:=Carrefour_pilote[Pour].y;
  For Pour :=1 To Nb_verin  Do If verin[Pour].y<mini then mini:=verin[Pour].y;
  For Pour :=1 To Nb_Distributeur  Do If Distributeur[Pour].y<mini then mini:=Distributeur[Pour].y;
  For Pour :=1 To Nb_Memoire  Do If Memoire[Pour].y<mini then mini:=Memoire[Pour].y;
  For Pour :=1 To Nb_Sequenceur  Do If Sequenceur[Pour].y<mini then mini:=Sequenceur[Pour].y;
  For Pour:=1 to Nb_Texte Do If Texte[Pour].y<mini then mini:=Texte[Pour].y;
  minimumv:=mini;
end;

Procedure Decah(combien:single);
Var Pour,pour2:Smallint;
begin
  For Pour :=1 To Nb_Canal Do For pour2:=1 to 11 do Canal[Pour].parcoursx[pour2]:=Canal[Pour].parcoursx[pour2]+combien;
  For Pour :=1 To Nb_Canal_pilote Do For pour2:=1 to 11 do Canal_pilote[Pour].parcoursx[pour2]:=Canal_pilote[Pour].parcoursx[pour2]+combien;
  For Pour :=1 To Nb_Capteur Do
  begin
    Capteur[Pour].x:=Capteur[Pour].x+combien;
    For pour2:=1 to 3 do Capteur[Pour].extx[pour2]:= Capteur[Pour].extx[pour2]+combien;
  end;
  For Pour :=1 To Nb_Alimentation  Do  Alimentation[Pour].x:=Alimentation[Pour].x+combien;
  For Pour :=1 To Nb_Alim_pilote  Do  Alim_pilote[Pour].x:=Alim_pilote[Pour].x+combien;
  For Pour :=1 To Nb_Carrefour Do  Carrefour[Pour].x:=Carrefour[Pour].x+combien;
  For Pour :=1 To Nb_Carrefour_pilote Do  Carrefour_pilote[Pour].x:=Carrefour_pilote[Pour].x+combien;
  For Pour :=1 To Nb_verin  Do
  begin
    verin[Pour].x:=verin[Pour].x+combien;
    For pour2:=1 to 2 do verin[Pour].entreex[pour2]:= verin[Pour].entreex[pour2]+combien;
  end;
  For Pour :=1 To Nb_sequenceur  Do
  begin
    sequenceur[Pour].x:=sequenceur[Pour].x+combien;
    For pour2:=1 to 22 do sequenceur[Pour].extx[pour2]:= sequenceur[Pour].extx[pour2]+combien;
  end;
  For Pour :=1 To Nb_memoire  Do
  begin
    memoire[Pour].x:=memoire[Pour].x+combien;
    For pour2:=1 to 4 do memoire[Pour].extx[pour2]:= memoire[Pour].extx[pour2]+combien;
  end;
   For Pour :=1 To Nb_distributeur  Do
  begin
    distributeur[Pour].x:=distributeur[Pour].x+combien;
    For pour2:=-1 to 5 do distributeur[Pour].extx[pour2]:= distributeur[Pour].extx[pour2]+combien;
  end;
  For Pour :=1 To Nb_commande  Do  commande[Pour].x:=commande[Pour].x+combien;
  For Pour :=1 To Nb_texte  Do  texte[Pour].x:=texte[Pour].x+combien;
end;

Procedure Decav(combien:single);
Var Pour,pour2:Smallint;
begin
  For Pour :=1 To Nb_Canal Do For pour2:=1 to 11 do Canal[Pour].parcoursy[pour2]:=Canal[Pour].parcoursy[pour2]+combien;
  For Pour :=1 To Nb_Canal_pilote Do For pour2:=1 to 11 do Canal_pilote[Pour].parcoursy[pour2]:=Canal_pilote[Pour].parcoursy[pour2]+combien;
  For Pour :=1 To Nb_Capteur Do
  begin
    Capteur[Pour].y:=Capteur[Pour].y+combien;
    For pour2:=1 to 3 do Capteur[Pour].exty[pour2]:= Capteur[Pour].exty[pour2]+combien;
  end;
  For Pour :=1 To Nb_Alimentation  Do  Alimentation[Pour].y:=Alimentation[Pour].y+combien;
  For Pour :=1 To Nb_Alim_pilote  Do  Alim_pilote[Pour].y:=Alim_pilote[Pour].y+combien;
  For Pour :=1 To Nb_Carrefour Do  Carrefour[Pour].y:=Carrefour[Pour].y+combien;
  For Pour :=1 To Nb_Carrefour_pilote Do  Carrefour_pilote[Pour].y:=Carrefour_pilote[Pour].y+combien;
  For Pour :=1 To Nb_verin  Do
  begin
    verin[Pour].y:=verin[Pour].y+combien;
    For pour2:=1 to 2 do verin[Pour].entreey[pour2]:= verin[Pour].entreey[pour2]+combien;
  end;
  For Pour :=1 To Nb_sequenceur  Do
  begin
    sequenceur[Pour].y:=sequenceur[Pour].y+combien;
    For pour2:=1 to 22 do sequenceur[Pour].exty[pour2]:= sequenceur[Pour].exty[pour2]+combien;
  end;
  For Pour :=1 To Nb_memoire  Do
  begin
    memoire[Pour].y:=memoire[Pour].y+combien;
    For pour2:=1 to 4 do memoire[Pour].exty[pour2]:= memoire[Pour].exty[pour2]+combien;
  end;
     For Pour :=1 To Nb_distributeur  Do
  begin
    distributeur[Pour].y:=distributeur[Pour].y+combien;
    For pour2:=-1 to 5 do distributeur[Pour].exty[pour2]:= distributeur[Pour].exty[pour2]+combien;
  end;
     For Pour :=1 To Nb_commande  Do  commande[Pour].y:=commande[Pour].y+combien;
     For Pour :=1 To Nb_texte  Do  texte[Pour].y:=texte[Pour].y+combien;
end;

procedure TForm1.Gauche1Click(Sender: TObject);
begin
  If minimumh>30 then  decah(-15);
  redess(false);
end;

procedure TForm1.Droite1Click(Sender: TObject);
begin
  If minimumh<300 then  decah(15);
  redess(false);
end;

procedure TForm1.Dessus1Click(Sender: TObject);
begin
  If minimumv>30 then  decav(-15);
  redess(false);
end;

procedure TForm1.Dessous1Click(Sender: TObject);
begin
  If minimumv<300 then  decav(15);
  redess(false);
end;

procedure TForm1.SauverlcranSVG1Click(Sender: TObject);
var s1,s2:string;
begin
  SVG:=false;
  vieux_facteur:=facteur;
  facteur:=1;
  Form1.Memo1.Lines.Clear;
  Form1.Memo1.Lines.Add('<?xml version ="1.0" encoding="ISO-8859-1" standalone="no" ?>');
  Form1.Memo1.Lines.Add('<!-- SVG  genere par Pfff : ADMR');
  Form1.Memo1.Lines.Add(Format(' Date       : %s',[DateToStr(Now)]));
  Form1.Memo1.Lines.Add('-->');
  s1:=strint(800);
  s2:=strint(600);
  Form1.Memo1.Lines.Add('<svg width="'+s1+'" height="'+s2+'" viewbox="0 0 '+s1+' '+s2+'" xmlns="http://www.w3.org/2000/svg">');
  SaveDialog2.Filename:=changefileext(nomdefichier,'.svg');
  If SaveDialog2.execute then
   begin
     Nomdefichier:=SaveDialog2.Filename;
     nomdefichier:=changefileext(nomdefichier,'.svg');
     SVG:=true;     redessprinc(true);    SVG:=false;
     Form1.Memo1.Lines.Add('</svg>');
     try
       Form1.Memo1.Lines.SaveToFile(Nomdefichier);
     finally
     end;
  end;
  facteur:=vieux_facteur;
end;

Procedure Deplace_Objet;
Var Objet:Type_;
    Pour,pour2,pour3:Smallint;
    Lax,Lay:Smallint;
    dx,dy:single;
    mypoint:Tpoint;
Begin
  Objet:=Toutsaufcanal;
  PetitMenu(clSkyblue,'<Déplacer>  Choix du composant ?');
  Pointe_Objet(Objet,pour,clblue);
  If Objet=Rien then
  Begin
    Redess(False);
    Exit;
  End;
  Lax:=150;LaY:=150;
  If (Objet=Un_Cap) then if Capteur[pour].modele in [Et,Ou,Inhibition] then Objet:=Une_Cellule;
  PetitMenu(clSkyblue,'<Déplacer>  Pointer la nouvelle position ?');
  GetCursorPos(MyPoint);
  SetCursorPos(round((mypoint.X)/facteur), round((mypoint.Y)/facteur));
  immonde_rustine_double_v:=false;
  immonde_rustine_galet_v:=false;
  if objet=Un_V then if verin[pour].modele=double_V then immonde_rustine_double_v:=true;
  If objet=Un_Cap then if capteur[pour].modele=A_Galet_V then immonde_rustine_galet_v:=true;
  Ou_Que(Lax,Lay,   false   ,Objet) ;
  immonde_rustine_double_v:=false;
  immonde_rustine_galet_v:=false;
  if objet=ouste then exit;
  dx:=0;dy:=0;
  Case Objet of
    Un_Cap,une_cellule:with Capteur[pour] do
    begin
    Objet:=Un_Cap;
      dx:=lax-x;dy:=lay-y;   x:=x+dx;  y:=y+dy;
      For pour2:=1 to 3 do
      begin
        extx[pour2]:= extx[pour2]+dx;
        exty[pour2]:= exty[pour2]+dy;
      end;
    end;
    Un_Sequenceur:with Sequenceur[pour] do
    begin
      dx:=lax-x;dy:=lay-y;   x:=x+dx;  y:=y+dy;
      For pour2:=1 to 22 do
      begin
        extx[pour2]:= extx[pour2]+dx;
        exty[pour2]:= exty[pour2]+dy;
      end;
    end;
    Un_V:with Verin[pour] do
    begin
      dx:=lax-x;dy:=lay-y;   x:=x+dx;  y:=y+dy;
      For pour2:=1 to 2 do
      begin
        entreex[pour2]:= entreex[pour2]+dx;
        entreey[pour2]:= entreey[pour2]+dy;
      end;
    end;
    Un_D:with Distributeur[pour] do
    begin
      dx:=lax-x;dy:=lay-y;   x:=x+dx;  y:=y+dy;
      For pour2:=-1 to 5 do
      begin
        extx[pour2]:= extx[pour2]+dx;
        exty[pour2]:= exty[pour2]+dy;
      end;
       Commande[Com[1].Laquelle].X:=Commande[Com[1].Laquelle].X+dx;
       Commande[Com[1].Laquelle].y:=Commande[Com[1].Laquelle].y+dy;
       Commande[Com[2].Laquelle].X:=Commande[Com[2].Laquelle].X+dx;
       Commande[Com[2].Laquelle].y:=Commande[Com[2].Laquelle].y+dy;
    end;
    Un_texte:with Texte[pour] do
    begin
      dx:=lax-round(x);dy:=lay-round(y);   x:=x+dx;  y:=y+dy;
    end;
    Une_Alim:with Alimentation[pour] do
    begin
      dx:=lax-round(x);dy:=lay-round(y);   x:=x+dx;  y:=y+dy;
    end;
    Une_Alim_pilote:with Alim_pilote[pour] do
    begin
      dx:=lax-round(x);dy:=lay-round(y);   x:=x+dx;  y:=y+dy;
    end;
    Un_Carrefour:with carrefour[pour] do
    begin
      dx:=lax-round(x);dy:=lay-round(y);   x:=x+dx;  y:=y+dy;
    end;
    Un_Carrefour_pilote:with carrefour_pilote[pour] do
    begin
      dx:=lax-round(x);dy:=lay-round(y);   x:=x+dx;  y:=y+dy;
    end;
    Une_memoire:with memoire[pour] do
    begin
      dx:=lax-x;dy:=lay-y;   x:=x+dx;  y:=y+dy;
      For pour2:=1 to 4 do
      begin
        extx[pour2]:= extx[pour2]+dx;
        exty[pour2]:= exty[pour2]+dy;
      end;
    end;
  end;
  For Pour2:=1 To Nb_Canal Do With Canal[Pour2] Do For Pour3:=1 To 2 Do If (Bout[Pour3].Quoi=objet) Then if Bout[Pour3].Lequel=pour then
  If pour3=2 then
  begin
    If nbpoint=2 then
    begin
       NbPoint:=3;
       parcoursx[3]:=parcoursx[2];
       Parcoursy[3]:=Parcoursy[2];
       parcoursx[2]:=(parcoursx[1]+parcoursx[3])/2;
       parcoursy[2]:=(parcoursy[1]+parcoursy[3])/2;
    end;
    If ((round(parcoursy[nbPoint])=round(Parcoursy[NbPoint-1])) and (round(parcoursx[nbPoint-1])=round(Parcoursx[NbPoint-2])))  { Cas C  } then
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursy[Nbpoint-1]:= Parcoursy[Nbpoint];
    end else if ((round(parcoursx[nbPoint])=round(Parcoursx[NbPoint-1])) and (round(parcoursx[nbPoint-1])=round(Parcoursx[NbPoint-2]))) {c'} then
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
      Parcoursy[Nbpoint-1]:= Parcoursy[Nbpoint-2];
    end else
    If ((round(parcoursx[nbPoint])=round(Parcoursx[NbPoint-1])) and (round(parcoursy[nbPoint-1])=round(Parcoursy[NbPoint-2]))) then   { D}
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
    end else
    if   ((round(parcoursy[nbPoint])=round(Parcoursy[NbPoint-1])) and (round(parcoursy[nbPoint-1])=round(Parcoursy[NbPoint-2]))) then   {d'}  {horiz}
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
    end;
  end else
  If pour3=1  then
  begin
    if nbpoint=2 then
     begin
       NbPoint:=3;
       parcoursx[3]:=parcoursx[2];
       Parcoursy[3]:=Parcoursy[2];
       parcoursx[2]:=(parcoursx[1]+parcoursx[3])/2;
       parcoursy[2]:=(parcoursy[1]+parcoursy[3])/2;
     end;
     If ((round(parcoursy[1])=round(Parcoursy[2])) and (round(parcoursx[2])=round(Parcoursx[3]))) then    {a}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursy[2]:= Parcoursy[1];
     end else
     If ((round(parcoursx[1])=round(Parcoursx[2])) and (round(parcoursx[2])=round(Parcoursx[3]))) then  {a'}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursy[2]:= Parcoursy[3];
       Parcoursx[2]:= Parcoursx[1];
     end else
     If ((round(parcoursx[1])=round(Parcoursx[2])) and (round(parcoursy[2])=round(Parcoursy[3]))) then

     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursx[2]:= Parcoursx[1];
     end else
     if  ((round(parcoursy[1])=round(Parcoursy[2])) and (round(parcoursy[2])=round(Parcoursy[3]))) then     {b'}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursx[2]:= Parcoursx[1];
     end;
  end;
  For Pour2:=1 To Nb_Canal_pilote Do With Canal_pilote[Pour2] Do For Pour3:=1 To 2 Do If (Bout[Pour3].Quoi=objet) Then if Bout[Pour3].Lequel=pour then
  If pour3=2 then
  begin
    If nbpoint=2 then
    begin
       NbPoint:=3;
       parcoursx[3]:=parcoursx[2];
       Parcoursy[3]:=Parcoursy[2];
       parcoursx[2]:=(parcoursx[1]+parcoursx[3])/2;
       parcoursy[2]:=(parcoursy[1]+parcoursy[3])/2;
    end;
    If ((round(parcoursy[nbPoint])=round(Parcoursy[NbPoint-1])) and (round(parcoursx[nbPoint-1])=round(Parcoursx[NbPoint-2])))  { Cas C  } then
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursy[Nbpoint-1]:= Parcoursy[Nbpoint];
    end else if ((round(parcoursx[nbPoint])=round(Parcoursx[NbPoint-1])) and (round(parcoursx[nbPoint-1])=round(Parcoursx[NbPoint-2]))) {c'} then
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
      Parcoursy[Nbpoint-1]:= Parcoursy[Nbpoint-2];
    end else
    If ((round(parcoursx[nbPoint])=round(Parcoursx[NbPoint-1])) and (round(parcoursy[nbPoint-1])=round(Parcoursy[NbPoint-2]))) then   { D}
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
    end else
    if   ((round(parcoursy[nbPoint])=round(Parcoursy[NbPoint-1])) and (round(parcoursy[nbPoint-1])=round(Parcoursy[NbPoint-2]))) then   {d'}  {horiz}
    begin
      parcoursx[Nbpoint]:=parcoursx[Nbpoint]+dx;Parcoursy[Nbpoint]:=Parcoursy[Nbpoint]+dy;
      Parcoursx[Nbpoint-1]:= Parcoursx[Nbpoint];
    end;
  end else
  If pour3=1  then
  begin
    if nbpoint=2 then
     begin
       NbPoint:=3;
       parcoursx[3]:=parcoursx[2];
       Parcoursy[3]:=Parcoursy[2];
       parcoursx[2]:=(parcoursx[1]+parcoursx[3])/2;
       parcoursy[2]:=(parcoursy[1]+parcoursy[3])/2;
     end;
     If ((round(parcoursy[1])=round(Parcoursy[2])) and (round(parcoursx[2])=round(Parcoursx[3]))) then    {a}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursy[2]:= Parcoursy[1];
     end else
     If ((round(parcoursx[1])=round(Parcoursx[2])) and (round(parcoursx[2])=round(Parcoursx[3]))) then  {a'}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursy[2]:= Parcoursy[3];
       Parcoursx[2]:= Parcoursx[1];
     end else
     If ((round(parcoursx[1])=round(Parcoursx[2])) and (round(parcoursy[2])=round(Parcoursy[3]))) then
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursx[2]:= Parcoursx[1];
     end else
     if  ((round(parcoursy[1])=round(Parcoursy[2])) and (round(parcoursy[2])=round(Parcoursy[3]))) then     {b'}
     begin
       parcoursx[1]:=parcoursx[1]+dx;Parcoursy[1]:=Parcoursy[1]+dy;
       Parcoursx[2]:= Parcoursx[1];
     end;
  end;
  Redess(False);
End;

procedure TForm1.Dplacer1Click(Sender: TObject);
begin
  cacommence;
  droite:=false;
  while not droite do deplace_Objet;
  cestfini;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  x_S:=round(20*facteur);Y_S:=round(30*facteur);
  gauche:=true;
end;

procedure TForm1.Continu1Click(Sender: TObject);
begin
  cacommence;
  pasapas:=false;
  Anime;
  pasapas:=false;
  cestfini;
end;

procedure TForm1.RAZ1Click(Sender: TObject);
var pour:smallint;
    Objet:Type_;
begin
  cacommence;
  while true do
  begin
    Objet:=Toutsaufcanal;
    PetitMenu(25343,'<Manoeuvrer>  Choix du composant ?');
    Pointe_Objet(Objet,pour,25343);
    Case Objet of
      Rien,ouste:Begin
             Redess(False);
             cestfini;
             Exit;
           End;
      Un_V:with Verin[pour] do tige := max((tige +1) mod 10,2);
      Un_D:with Distributeur[pour] do
           case modele of
               _3_2,_4_2,_5_2,_2_2,_2_2_:etat:=max((etat+1 ) mod 3,1);
               _4_3,_5_3:etat:=max((etat+1 ) mod 4,1);
           end;
       Un_Cap:with Capteur[pour] do if not (Capteur[pour].modele in [Et,Ou,Inhibition]) then etat:=max((etat+1 ) mod 3,1);
       Une_memoire:with memoire[pour] do etat:=max((etat+1 ) mod 3,1);
       Un_Sequenceur:with Sequenceur[pour] do  etat:=(etat+1 ) mod (combien+1);
    end;
    Redess(False);
  end;
  cestfini;
end;

end.


