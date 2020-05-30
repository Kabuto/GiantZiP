unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TAboutWindow = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutWindow: TAboutWindow;

implementation

{$R *.dfm}

end.
