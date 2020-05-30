program GiantZiP;

uses
  Forms,
  GZPMain in 'GZPMain.pas' {GZPMainWindow},
  Unit2 in 'Unit2.pas' {AboutWindow},
  Unit1 in 'Unit1.pas' {HelpScreen},
  Unit3 in 'Unit3.pas' {ExtractForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGZPMainWindow, GZPMainWindow);
  Application.CreateForm(TAboutWindow, AboutWindow);
  Application.CreateForm(THelpScreen, HelpScreen);
  Application.CreateForm(TExtractForm, ExtractForm);
  if ParamCount>0 then
    GZPMainWindow.GZPOpenMain(ParamStr(1),ParamStr(1));
//    GZPMainWindow.StatusBar1.SimpleText := ParamStr(1);

  Application.Run;
end.
