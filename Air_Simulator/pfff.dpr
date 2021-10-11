program pfff;
// Auteur Montero-Ribas
// Logiciel sous license GNU GPL
uses
  Forms,
  pfffunit in 'pfffunit.pas' {Form1},
  pfffgen in 'pfffgen.pas',
  apUnit1 in 'apUnit1.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
