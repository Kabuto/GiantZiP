unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  THelpScreen = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    TabSheet7: TTabSheet;
    Label6: TLabel;
    TabSheet8: TTabSheet;
    Label7: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpScreen: THelpScreen;

implementation

{$R *.dfm}

end.
