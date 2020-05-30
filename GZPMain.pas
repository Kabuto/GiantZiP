unit GZPMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls, ComCtrls, Menus,
  ActnList;

type
  TGZPMainWindow = class(TForm)
    StatusBar1: TStatusBar;
    Bevel1: TBevel;
    NewGZP: TBitBtn;
    OpenGZP: TBitBtn;
    AddGZP: TBitBtn;
    ExtractGZP: TBitBtn;
    MultiGZP: TBitBtn;
    HelpGZP: TBitBtn;
    AboutGZP: TBitBtn;
    CompressionSlider: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Filelist: TListView;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Extract1: TMenuItem;
    N1: TMenuItem;
    Selectall1: TMenuItem;
    Deselectall1: TMenuItem;
    ActionList1: TActionList;
    GZPNew: TAction;
    GZPOpen: TAction;
    GZPAdd: TAction;
    GZPExtract: TAction;
    GZPMultiSource: TAction;
    GZPHelp: TAction;
    GZPAbout: TAction;
    GZPCompression: TAction;
    GZPDelete: TAction;
    GZPSelectAll: TAction;
    GZPDeselectAll: TAction;
    SortByName: TAction;
    SortByType: TAction;
    SortBySize: TAction;
    SortByPacked: TAction;
    SortByCompression: TAction;
    SortByDate: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MultisourceOpenDialog: TOpenDialog;
    AddDialog: TOpenDialog;
    procedure GZPOpenClick(Sender: TObject);
    procedure GZPAboutExecute(Sender: TObject);
    procedure GZPExtractExecute(Sender: TObject);
    procedure FilelistClick(Sender: TObject);
    procedure FilelistColumnClick(Sender: TObject; Column: TListColumn);
    procedure CompressionSliderChange(Sender: TObject);
    procedure GZPNewExecute(Sender: TObject);
    procedure GZPMultiSourceExecute(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Deselectall1Click(Sender: TObject);
    procedure HelpGZPClick(Sender: TObject);
    procedure GZPOpenMain(farchivename_,farchivepath :string);
    procedure GZPAddExecute(Sender: TObject);
    procedure Compress(var buf,comprbuf :array of byte; size :integer; var cmpsize :integer);  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GZPMainWindow: TGZPMainWindow;
  farchive: file;
  farchivename :string;
  lastsortedby :integer;
  farchivepath :string;
// Hinweis: farchive ist nur dann zu öffnen, wenn es gerade gebraucht wird

implementation

uses Unit1,Unit2,Unit3;

{$R *.dfm}

procedure TGZPMainWindow.GZPOpenClick(Sender: TObject);
  begin
    if OpenDialog.Execute then
      GZPOpenMain(OpenDialog.Filename,OpenDialog.InitialDir);
  end;

procedure TGZPMainWindow.GZPOpenMain(farchivename_,farchivepath :string);
  var
    header,indexheader :array[0..1] of longint;
    fileindex :record
      size :longint;
      size_uncmp :longint;
      u1 :longint;
      start :longint;
      compr :byte;
      namelength :byte
    end;
    i,j,k :longint;
    filename :string;
    filename2 :array[0..254] of char;
    tli :TListItem;
    s :string;

  begin
      // try to open file; clear old list
      Filelist.Items.Clear;
      AddGZP.Enabled := true;
      CompressionSlider.Enabled := true;

      AssignFile(farchive,farchivename_);

      FileMode := 2;
      {$I-}
      Reset(farchive,1);
      if IOResult<>0 then begin
        FileMode := 0;
        Reset(farchive,1);
        if IOResult<>0 then begin
      {$I+}
          StatusBar1.SimpleText := 'Unable to open archive "'+farchivename_+'"';
          exit;
        end;
        StatusBar1.SimpleText := farchivename_+' (read only)';
      end
      else begin
        StatusBar1.SimpleText := '"'+farchivename_+'"';
      end;
      farchivename := farchivename_;

      // check whether file is valid; if yes read index list

      BlockRead(farchive,header,8);
      if header[0]<>$6608F101 then begin
        StatusBar1.SimpleText := 'Error: invalid signature in file';
        CloseFile(farchive);
        exit;
      end;
      Seek(farchive,header[1]);
      BlockRead(farchive,indexheader,8);

      for k := 0 to indexheader[1]-1 do begin
        BlockRead(farchive,fileindex,18);
        BlockRead(farchive,filename2,longint(fileindex.namelength));
        filename := '';
        for j := 0 to longint(fileindex.namelength)-2 do
          filename := filename+filename2[j];

        // create a list entry

        tli := Filelist.Items.Add;
        tli.Caption := filename;

        tli.SubItems.Clear;
        tli.SubItems.Add(copy(filename,length(filename)-2,3));

        s := farchivename;
        i := length(s);
        while (i>0) and (s[i]<>'\') do
          dec(i);
        if (i>0) then
          s := copy(s,i+1,length(s)-i);

        tli.SubItems.Add(s);

        Str(fileindex.size_uncmp,s);
        tli.SubItems.Add(s);

        Str(fileindex.size,s);
        tli.SubItems.Add(s);

        if (fileindex.compr=2) or (fileindex.size_uncmp=0) then
          tli.SubItems.Add('none')
        else begin
          Str(fileindex.size/fileindex.size_uncmp*100:5:2,s);
          tli.SubItems.Add(s+' %');
        end;

        try
          tli.SubItems.Add(DateTimeToStr(FileDateToDateTime(fileindex.u1)));
        except
          on EConvertError do tli.SubItems.Add('unknown');
        end;




        tli.SubItems.Add(farchivename);

        Str(fileindex.start,s);
        tli.SubItems.Add(s);
      end;
      CloseFile(farchive);
  end;


procedure TGZPMainWindow.GZPAboutExecute(Sender: TObject);
  begin
  with TAboutWindow.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  end;

procedure TGZPMainWindow.GZPExtractExecute(Sender: TObject);
begin
  with TExtractForm.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TGZPMainWindow.FilelistClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Clicked into filelist';
end;

function upcases(s :string):string;
  var
    s2 :string;
    i :longint;
  begin
    s2 := '';
    for i := 1 to length(s) do
      s2 := s2+upcase(s[i]);
    upcases  := s2;
  end;


function CSbySomething(it1,it2 :integer;lp :integer):integer stdcall;
  var
    item1 :TListItem absolute it1;
    item2 :TListItem absolute it2;
    v1,v2 :integer;
    code :integer;
    res :integer;
    i :integer;
    s1,s2 :string;
  begin
    case lp div 2 of
      1:begin
        if upcases(item1.Caption)=upcases(item2.Caption) then
          res := 0
        else if upcases(item1.Caption)<upcases(item2.Caption) then
          res := -1
        else
          res := 1
      end;
      2,3,7,8:begin
        i := lp div 2-2;
        if upcases(item1.SubItems.Strings[i])=upcases(item2.SubItems.Strings[i]) then
          res := 0
        else if upcases(item1.SubItems.Strings[i])<upcases(item2.SubItems.Strings[i]) then
          res := -1
        else
          res := 1
      end;
      4,5,9:begin
        i := lp div 2-2;
        val(item1.SubItems.Strings[i],v1,code);
        val(item2.SubItems.Strings[i],v2,code);
        if v1=v2 then
          res := 0
        else if v1<v2 then
          res := -1
        else
          res := 1;
      end;
      6:begin
        i := lp div 2-2;
        s1 := item1.SubItems.Strings[i];
        s2 := item2.SubItems.Strings[i];
        if s1='none' then
          if s2='none' then
            res := 0
          else
            res := -1
        else
          if s2='none' then
            res := 1
          else begin
            val(copy(s1,1,length(s1)-2),v1,code);
            val(copy(s2,1,length(s2)-2),v2,code);
            if v1=v2 then
              res := 0
            else if v1<v2 then
              res := -1
            else
              res := 1;
          end
      end;
      else
        res := 0;
    end;
    if odd(lp) then
      CSbySomething := -res
    else
      CSbySomething := res
  end;

procedure TGZPMainWindow.FilelistColumnClick(Sender: TObject;
  Column: TListColumn);
var
  s :string;
  b :boolean;
begin
  Str(Column.index,s);
  StatusBar1.SimpleText := 'Clicked into filelist column header '+s;

  if LastSortedBy=Column.index*2+2 then
    LastSortedBy := Column.index*2+3
  else
    LastSortedBy := Column.index*2+2;

  b := Filelist.CustomSort(CSbySomething,LastSortedBy)
end;

procedure TGZPMainWindow.CompressionSliderChange(Sender: TObject);
begin
  case CompressionSlider.Position of
    0: StatusBar1.SimpleText := 'Best compression';
    1: StatusBar1.SimpleText := 'Medium compression';
    2: StatusBar1.SimpleText := 'Fast compression';
    3: StatusBar1.SimpleText := 'No compression';
    else StatusBar1.SimpleText := 'What the *@#$';
  end;
end;

procedure TGZPMainWindow.GZPNewExecute(Sender: TObject);
  var
    header,indexheader :array[0..1] of longint;
  begin
    if SaveDialog.Execute then begin
      StatusBar1.SimpleText := 'New archive created';
      AddGZP.Enabled := true;
      CompressionSlider.Enabled := true;
      Filelist.Items.Clear;
      AddGZP.Enabled := true;
      CompressionSlider.Enabled := true;

      farchivepath := SaveDialog.InitialDir;

      farchivename := SaveDialog.Filename;
      AssignFile(farchive,farchivename);
      {$I-}
      Rewrite(farchive,1);
      if IOResult<>0 then begin
      {$I+}
        StatusBar1.SimpleText := 'Unable to create archive "'+farchivename+'"';
        exit;
      end;
      StatusBar1.SimpleText := farchivename+' (read only)';
      // fill file with basic information so new files can be added
      header[0] := $6608F101;
      header[1] := 8;
      indexheader[0] := 0;
      indexheader[1] := 0;
      BlockWrite(farchive,header,8);
      BlockWrite(farchive,indexheader,8);
    end
    else
      StatusBar1.SimpleText := 'No new archive created'
  end;

procedure TGZPMainWindow.GZPMultiSourceExecute(Sender: TObject);
  var
    i,j,k,l,m :longint;
    tsl :TStringList;
    header,indexheader :array[0..1] of longint;
    fileindex :record
      size :longint;
      size_uncmp :longint;
      u1 :longint;
      start :longint;
      compr :byte;
      namelength :byte
    end;
    filename :string;
    filename2 :array[0..254] of char;
    tli :TListItem;
    s :string;

  begin
    if MultisourceOpenDialog.Execute then begin
      StatusBar1.SimpleText := 'Multiple Sources selected';
      AddGZP.Enabled := false;
      CompressionSlider.Enabled := false;
      Filelist.Items.Clear;

      farchivepath := MultisourceOpenDialog.InitialDir;

      // sortieren, damit später alles so funktioniert wie es sollte
      tsl := TStringList.Create;
      tsl.AddStrings(MultisourceOpenDialog.Files);
      tsl.Sort;


      Filelist.Items.BeginUpdate;
      for i := 0 to tsl.Count-1 do begin

        farchivename := tsl.Strings[i];
        AssignFile(farchive,farchivename);

        FileMode := 0;
        Reset(farchive,1);

        StatusBar1.SimpleText := farchivename;

        // check whether file is valid; if yes read index list

        BlockRead(farchive,header,8);
        if header[0]<>$6608F101 then begin
          StatusBar1.SimpleText := 'Error: invalid signature in file';
          CloseFile(farchive);
          exit;
        end;
        Seek(farchive,header[1]);
        BlockRead(farchive,indexheader,8);

        for k := 0 to indexheader[1]-1 do begin
          BlockRead(farchive,fileindex,18);
          BlockRead(farchive,filename2,longint(fileindex.namelength));
          filename := '';
          for j := 0 to longint(fileindex.namelength)-2 do
            filename := filename+filename2[j];

          // if file does not already exist create a list entry

          l := -1;

          for j := 0 to Filelist.Items.Count-1 do
            if upcases(Filelist.Items.Item[j].Caption)=upcases(filename) then
              l := j;

          if l<>-1 then begin
            s := farchivename;
            m := length(s);
            while (m>0) and (s[m]<>'\') do
              dec(m);
            if (m>0) then
              s := copy(s,m+1,length(s)-m);
            Filelist.Items.Item[l].SubItems.Strings[1] :=
             Filelist.Items.Item[l].SubItems.Strings[1]+' '+s
          end
          else begin
            tli := Filelist.Items.Add;
            tli.Caption := filename;

            tli.SubItems.Clear;
            tli.SubItems.Add(copy(filename,length(filename)-2,3));

            s := farchivename;
            m := length(s);
            while (m>0) and (s[m]<>'\') do
              dec(m);
            if (m>0) then
              s := copy(s,m+1,length(s)-m);

            tli.SubItems.Add(s);

            Str(fileindex.size_uncmp,s);
            tli.SubItems.Add(s);

            Str(fileindex.size,s);
            tli.SubItems.Add(s);

            if (fileindex.compr=2) or (fileindex.size_uncmp=0) then
              tli.SubItems.Add('none')
            else begin
              Str(fileindex.size/fileindex.size_uncmp*100:5:2,s);
              tli.SubItems.Add(s+' %');
            end;
            tli.SubItems.Add(DateTimeToStr(FileDateToDateTime(fileindex.u1)));
            tli.SubItems.Add(farchivename);

            Str(fileindex.start,s);
            tli.SubItems.Add(s);
          end;
        end
      end;
      Filelist.Items.EndUpdate;
    end
    else
      StatusBar1.SimpleText := 'No multiple sources selected'
  end;

procedure TGZPMainWindow.Delete1Click(Sender: TObject);
  type
    tFileIndex2=record
      size,size_uncmp,u1,start :longint;
      compr :byte;
      name :string;
      delete :boolean;
      newstart :longint;
    end;

  var
    i,j,k,n :integer;
    f :file;
    header,header2,indexheader,indexheader2 :array[0..1] of longint;
    fileindex :record
      size :longint;
      size_uncmp :longint;
      u1 :longint;
      start :longint;
      compr :byte;
      namelength :byte
    end;
    fileindex2 :array of tFileIndex2;
    s :string;
    buffer :array of byte;
    filename :string;
    filename2 :array[0..255] of char;
    archname :string;

  begin
    j := -1;
    for i := 0 to Filelist.Items.Count-1 do
      if Filelist.Items.Item[i].Selected then
        j := i;
    if j=-1 then
      exit; // nix zu tun
    FileMode := 2;
    archname := Filelist.Items.Item[j].SubItems.Strings[6];
    AssignFile(f,archname);
    Reset(f,1);

    BlockRead(f,header,8);
    if header[0]<>$6608F101 then begin
      StatusBar1.SimpleText := 'Error: invalid signature in file';
      CloseFile(f);
      exit;
    end;
    Seek(f,header[1]);
    BlockRead(f,indexheader,8);

    // Indizes lesen

    SetLength(fileindex2,indexheader[1]);
    for k := 0 to indexheader[1]-1 do begin
      BlockRead(f,fileindex,18);
      BlockRead(f,filename2,longint(fileindex.namelength));
      filename := '';
      for j := 0 to longint(fileindex.namelength)-2 do
        filename := filename+filename2[j];
      with fileindex2[k] do begin
        size := fileindex.size;
        size_uncmp := fileindex.size_uncmp;
        u1 := fileindex.u1;
        start := fileindex.start;
        compr := fileindex.compr;
        name := filename;
        delete := false;
        newstart := 0;
      end;
    end;

    // Liste aller markierten Einträge erstellen

    for i := 0 to Filelist.Items.Count-1 do
      if Filelist.Items[i].Selected then begin
        s := Filelist.Items[i].Caption;
        for k := 0 to indexheader[1]-1 do
          if fileindex2[k].name=s then
            fileindex2[k].delete := true;
      end;

    // ...und löschen

    n := 0;
    Seek(f,8);
    for  k := 0 to indexheader[1]-1 do
      if not fileindex2[k].delete then begin
        fileindex2[k].newstart := FilePos(f);
        SetLength(buffer,fileindex2[k].size);
        Seek(f,fileindex2[k].start);
        BlockRead(f,buffer[0],fileindex2[k].size);
        Seek(f,fileindex2[k].newstart);
        BlockWrite(f,buffer[0],fileindex2[k].size);
        inc(n)
      end;

    // Indexliste neu erstellen

    header2[0] := header[0];
    header2[1] := FilePos(f);
    indexheader2[0] := indexheader[0];
    indexheader2[1] := n;

    BlockWrite(f,indexheader2,8);
    for  k := 0 to indexheader[1]-1 do
      if not fileindex2[k].delete then begin
        with fileindex do begin
          size := fileindex2[k].size;
          size_uncmp := fileindex2[k].size_uncmp;
          u1 := fileindex2[k].u1;
          start := fileindex2[k].newstart;
          compr := fileindex2[k].compr;
          namelength := length(fileindex2[k].name)+1;

          s := '';
          for i := 0 to namelength-2 do
            filename2[i] := fileindex2[k].name[i+1];
          filename2[namelength-1] := #0;
        end;
        BlockWrite(f,fileindex,18);
        BlockWrite(f,filename2,longint(fileindex.namelength));
      end;
    Truncate(f);
    Seek(f,0);
    BlockWrite(f,header2,8);
    CloseFile(f);

    // zur Kontrolle neu laden

    GZPOpenMain(archname,'');
  end;

procedure TGZPMainWindow.Selectall1Click(Sender: TObject);
  var
    i :integer;
  begin
    for i := 0 to Filelist.Items.Count-1 do
      Filelist.Items.Item[i].Selected := true;
  end;

procedure TGZPMainWindow.Deselectall1Click(Sender: TObject);
  var
    i :integer;
  begin
    for i := 0 to Filelist.Items.Count-1 do
      Filelist.Items.Item[i].Selected := false;
  end;

procedure TGZPMainWindow.HelpGZPClick(Sender: TObject);
  begin
    with THelpScreen.Create(Self) do
      try
        ShowModal;
      finally
        Free;
    end
  end;


procedure TGZPMainWindow.Compress(var buf,comprbuf :array of byte; size :integer; var cmpsize :integer);
  var
    j :longint;
    comprpos :longint;
    comprbufpos :longint;
    comprtype :byte;
    comprtypepos :longint;
    comprbits :longint;
    cseek, cbestseek, cbestlen, clen :longint;

  begin
    comprpos := 0;
    comprbufpos := 1;
    comprbits := 0;
    comprtype := 0;
    comprtypepos := 0;
    while (comprpos<size) and (comprbufpos<size) do begin
      if CompressionSlider.Position=0 then
        cseek := comprpos-4095
      else
        if CompressionSlider.Position=1 then
          cseek := comprpos-512
        else
          cseek := comprpos-64;
      cbestlen := 2;
      if cseek<0 then
        cseek := 0;
      while cseek<comprpos do begin
        clen := 0;
        while (clen<18) and (comprpos+clen<size) and (buf[comprpos+clen]=buf[cseek+clen]) do
          inc(clen);
        if clen>cbestlen then begin
          cbestlen := clen;
          cbestseek := cseek;
          if clen=18 then
            break;  // weil nichts mehr zu verbessern
        end;
        inc(cseek);
      end;
      if cbestlen=2 then begin
        comprtype := comprtype or (1 shl comprbits);
        comprbuf[comprbufpos] := buf[comprpos];
        inc(comprbufpos);
        inc(comprpos);
      end
      else begin
        // comprtype... unn”tig da standardm„áig = 0
        j := (cbestseek + $FEE) and $FFF;
        comprbuf[comprbufpos] := j and $FF;
        comprbuf[comprbufpos+1] := j and $F00 shr 4+(cbestlen-3);
        inc(comprbufpos,2);
        inc(comprpos,cbestlen);
      end;
      inc(comprbits);
      if comprbits=8 then begin
        comprbuf[comprtypepos] := comprtype;
        comprtype := 0;
        comprbits := 0;
        comprtypepos := comprbufpos;
        inc(comprbufpos);
      end;
    end;
    {Ende Kompression}
    comprbuf[comprtypepos] := comprtype;
    cmpsize := comprbufpos;
  end;

procedure TGZPMainWindow.GZPAddExecute(Sender: TObject);
  type
    tFileIndex2=record
      size,size_uncmp,u1,start :longint;
      compr :byte;
      name :string;
    end;

  var
    i,j,k :integer;
    f,f2 :file;
    header,header2,indexheader,indexheader2 :array[0..1] of longint;
    fileindex :record
      size :longint;
      size_uncmp :longint;
      u1 :longint;
      start :longint;
      compr :byte;
      namelength :byte
    end;
    fileindex2 :array of tFileIndex2;
    s :string;
    buffer,buffer2 :array of byte;
    filename :string;
    filename2 :array[0..255] of char;
    tsl :TStringList;
    fileparam :record
      size_cmp,
      size_uncmp,
      date,
      compr :longint;
    end;
    compressed :boolean;

  begin
    if not AddDialog.Execute then
      exit;

    FileMode := 2;
    AssignFile(f,farchivename);
    Reset(f,1);

    tsl := TStringList.Create;
    tsl.AddStrings(AddDialog.Files);

    BlockRead(f,header,8);
    if header[0]<>$6608F101 then begin
      StatusBar1.SimpleText := 'Error: invalid signature in file';
      CloseFile(f);
      exit;
    end;
    Seek(f,header[1]);
    BlockRead(f,indexheader,8);

    // Indizes lesen

    SetLength(fileindex2,indexheader[1]+tsl.Count);
    for k := 0 to indexheader[1]-1 do begin
      BlockRead(f,fileindex,18);
      BlockRead(f,filename2,longint(fileindex.namelength));
      filename := '';
      for j := 0 to longint(fileindex.namelength)-2 do
        filename := filename+filename2[j];
      with fileindex2[k] do begin
        size := fileindex.size;
        size_uncmp := fileindex.size_uncmp;
        u1 := fileindex.u1;
        start := fileindex.start;
        compr := fileindex.compr;
        name := filename;
      end;
    end;

    // Dateien hinzufügen

    Seek(f,header[1]);

    for i := 0 to tsl.Count-1 do begin
      FileMode := 0;
      AssignFile(f2,tsl.Strings[i]);
      Reset(f2,1);
      SetLength(buffer,FileSize(f2));
      BlockRead(f2,buffer[0],FileSize(f2));

      k := indexheader[1]+i;

      compressed := false;
      if CompressionSlider.Position<>3 then begin
        SetLength(buffer2,FileSize(f2)+20);
        Compress(buffer,buffer2,FileSize(f2),j);
        if j<FileSize(f2) then begin
          compressed := true;

          fileparam.size_cmp := j+16;
          fileparam.size_uncmp := FileSize(f2);
          fileparam.date := 0;
          fileparam.compr := 1;

          fileindex2[k].start := FilePos(f);

          BlockWrite(f,fileparam,16);
          BlockWrite(f,buffer2[0],j);
        end;
      end;
      if not compressed then begin
        fileparam.size_cmp := FileSize(f2)+16;
        fileparam.size_uncmp := FileSize(f2);
        fileparam.date := 0;
        fileparam.compr := 2;

        fileindex2[k].start := FilePos(f);

        BlockWrite(f,fileparam,16);
        BlockWrite(f,buffer[0],FileSize(f2));
      end;

      fileindex2[k].size := fileparam.size_cmp;
      fileindex2[k].size_uncmp := fileparam.size_uncmp;
      fileindex2[k].u1 := fileparam.date;
      fileindex2[k].compr := fileparam.compr;

      s := tsl.Strings[i];
      j := length(s);
      while (j>0) and (s[j]<>'\') do
        dec(j);
      s := copy(s,j+1,length(s)-j);
      fileindex2[k].name := s;

      CloseFile(f2);
    end;


    // Indexliste neu erstellen

    header2[0] := header[0];
    header2[1] := FilePos(f);
    indexheader2[0] := indexheader[0];
    indexheader2[1] := indexheader[1]+tsl.Count;

    BlockWrite(f,indexheader2,8);
    for  k := 0 to indexheader2[1]-1 do begin
        with fileindex do begin
          size := fileindex2[k].size;
          size_uncmp := fileindex2[k].size_uncmp;
          u1 := fileindex2[k].u1;
          start := fileindex2[k].start;
          compr := fileindex2[k].compr;
          namelength := length(fileindex2[k].name)+1;

          s := '';
          for i := 0 to namelength-2 do
            filename2[i] := fileindex2[k].name[i+1];
          filename2[namelength-1] := #0;
        end;
        BlockWrite(f,fileindex,18);
        BlockWrite(f,filename2,longint(fileindex.namelength));
      end;
    Truncate(f);
    Seek(f,0);
    BlockWrite(f,header2,8);
    CloseFile(f);

    // zur Kontrolle neu laden

    GZPOpenMain(farchivename,'');
  end;

begin
  lastsortedby := 0;
end.
