unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ShellCtrls;

type
  TExtractForm = class(TForm)
    ShellTreeView1: TShellTreeView;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    AllFilesRadio: TRadioButton;
    SelectedFilesRadio: TRadioButton;
    OverwriteCheckbox: TCheckBox;
    Extract: TButton;
    Cancel: TButton;
    procedure ShellTreeView1Click(Sender: TObject);
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ExtractClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExtractForm: TExtractForm;

implementation

uses GZPMain;

{$R *.dfm}

procedure TExtractForm.ShellTreeView1Click(Sender: TObject);
  begin
    Edit1.Text := ShellTreeView1.Path;
  end;

procedure TExtractForm.ShellTreeView1Change(Sender: TObject;
  Node: TTreeNode);
  begin
    Edit1.Text := ShellTreeView1.Path;
  end;

procedure Decompress(var buf,dcbuf :array of byte; start,len,finalsize:longint);
  var
    i,j,vbufstart,decbits,decpos,declen :longint;
    decbyte :byte;

  begin
    i := start;
    j := 0;
    vbufstart := $FEE;
    decbits := 8;
    while j<finalsize do begin
      if decbits=8 then begin
        decbyte := buf[i];
        inc(i);
        decbits := 0;
      end;
      if (decbyte shr decbits) and 1=0 then begin
        decpos := (buf[i]+longint(buf[i+1]) and $F0 shl 4-vbufstart-j) and $FFF-4096+j;
        declen := buf[i+1] and $F+3;
        inc(i,2);

        // if decpos+4096=j then Writeln(t,s,' ',filename,': Verweis auf sich selbst bei cpr=',i-2,' unc=',j);
        while declen>0 do begin
          if decpos>=0 then
            dcbuf[j] := dcbuf[decpos]
          else begin
            // Writeln(t,s,' ',filename,': Verweis nach ',decpos,' bei cpr=',i-2,' unc=',j)};
            dcbuf[j] := 32; //„ndern wenn's nicht stimmt, k”nnte auch 31 oder 33 sein
          end;
          inc(j);
          inc(decpos);
          dec(declen)
        end
      end
      else begin
        dcbuf[j] := buf[i];
        inc(i);
        inc(j);
      end;
      inc(decbits);
    end;
  end;


procedure TExtractForm.ExtractClick(Sender: TObject);
  var
    tli :TListItems;
    i :integer;
    f,f2 :file;
    fn :string;
    fileparam :record
      size_cmp,
      size_uncmp,
      date,
      compr :longint;
    end;
    p :longint;
    code :longint;
    buf,dcbuf :array of byte;
    path :string;

  begin
    path := Edit1.Text;
    if path[length(path)]<>'\' then
      path := path+'\';
    tli := GZPMainWindow.Filelist.Items;
    fn := '';
    for i := 0 to tli.Count-1 do if (tli.Item[i].Selected or AllFilesRadio.Checked) then begin
      if (tli.Item[i].SubItems.Strings[6]<>fn) then begin
        if fn<>'' then
          CloseFile(f);
        fn := tli.Item[i].SubItems.Strings[6];
        FileMode := 0;
        AssignFile(f,fn);
        Reset(f,1);
      end;
      Val(tli.Item[i].SubItems.Strings[7],p,code);
      Seek(f,p);
      BlockRead(f,fileparam,16);
      setLength(buf,fileparam.size_cmp-16);
      BlockRead(f,buf[0],fileparam.size_cmp-16);
      if not OverwriteCheckbox.Checked and FileExists(path+tli.Item[i].Caption) then
        continue;
      AssignFile(f2,path+tli.Item[i].Caption);
      Rewrite(f2,1);
      case fileparam.compr of
        1:begin
          SetLength(dcbuf,fileparam.size_uncmp);
          Decompress(buf,dcbuf,0,fileparam.size_cmp-16,fileparam.size_uncmp);
          BlockWrite(f2,dcbuf[0],fileparam.size_uncmp);
        end;
        2:begin
          BlockWrite(f2,buf[0],fileparam.size_uncmp);
        end;
      end;
      CloseFile(f2);
    end;
    if fn<>'' then
      CloseFile(f);
  end;

begin

end.
