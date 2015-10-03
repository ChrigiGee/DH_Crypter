program builder;

uses
  Forms,
  builder_now in 'builder_now.pas' {Form1},
  tools in 'tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
