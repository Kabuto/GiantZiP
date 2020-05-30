object HelpScreen: THelpScreen
  Left = 659
  Top = 9
  Width = 453
  Height = 487
  Caption = 'HelpScreen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 445
    Height = 460
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    Style = tsButtons
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 437
        Height = 405
        Align = alClient
        Caption = 
          'Welcome to GiantZiP 0.05!'#13#13'This is a editor for the GZP archive ' +
          'files which are used by the game "Giants: Citizen Kabuto" (to be' +
          ' precise: the only editor with full editing support until now).'#13 +
          #13'This program is part of the GiantsEdit 0.05 package. It was the' +
          ' first one of these tools to be released so you may have got it ' +
          'separately.'#13#13'Yep, this program looks much like the well-known zi' +
          'p archive editor WinZIP (it is not meant to be any alternative t' +
          'o WinZIP because it covers a different file format). I have chos' +
          'en this style because WinZIP is very well-known to windows users' +
          '. Well, there are other styles (as many styles as archive progra' +
          'ms ;-) ) but in my opinion for the special purpose of GZP editin' +
          'g the WinZIP style was the best one I found.'#13#13'Pleas note that GZ' +
          'P files do not support subdirecories. This is why some component' +
          's found in WinZIP are missing here.'#13#13'Please keep in mind that it' +
          ' is easy to mess around with the Giants files so that Giants wil' +
          'l not start anymore. Be careful! (If that happens it is best to ' +
          're-install Giants)'
        WordWrap = True
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'File list'
      ImageIndex = 1
      object Label8: TLabel
        Left = 0
        Top = 0
        Width = 435
        Height = 299
        Align = alClient
        Caption = 
          'This is where all the files from within GZP archives are listed.' +
          #13#13'Click on any column header to sort the file list by the proper' +
          'ty you clicked.'#13#13'Select single files by clicking on them.'#13'Select' +
          ' multiple files by dragging with the shift key held down or by.'#13 +
          'Add or remove files from the current selection by clicking on th' +
          'em with the CTRL key held down.'#13#13'Right-click on your selection f' +
          'or a list of further options.'#13#13'Name: the file name'#13'Type: the fil' +
          'e'#39's extension'#13'Source: the GZP file this file comes from. When mu' +
          'ltiple names are listed here the first one is the archive this f' +
          'ile comes from; the other archive'#39's files with the same name wer' +
          'e overridden.'#13'Size: file size after extraction.'#13'Packed Size: siz' +
          'e of the file in its archived state.'#13'Compression: a percentage w' +
          'hich shows the packed file'#39's size compared to the uncompressed s' +
          'ize.'#13'Date: ignore, is not implemented correctly yet.'#13'FullSourceP' +
          'ath: full path to the archive this file comes from.'#13'Startpos: st' +
          'art position of this file inside of the archive.'
        WordWrap = True
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'New/Open'
      ImageIndex = 2
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 431
        Height = 39
        Align = alClient
        Caption = 
          'Open lets you select an archive file and then displays a list of' +
          ' its files.'#13'New asks you to enter a new name and then creates a ' +
          'new archive which initially does not contain any file.'
        WordWrap = True
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Adding files'
      ImageIndex = 3
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 398
        Height = 39
        Align = alClient
        Caption = 
          'A dialog pops up letting you select one or multiple files to add' +
          ' to the archive which is currently open.'#13'This button is disabled' +
          ' when no archive or multiple archives are open.'
        WordWrap = True
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Extracting files'
      ImageIndex = 4
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 267
        Height = 26
        Align = alClient
        Caption = 
          'Extract the highlighted (or all) files to any place you want.'#13'Ma' +
          'ke sure that the output directory exists.'
        WordWrap = True
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Compression'
      ImageIndex = 5
      object Label5: TLabel
        Left = 0
        Top = 0
        Width = 414
        Height = 39
        Align = alClient
        Caption = 
          'Select the degree of compression.'#13'My implementation of the compr' +
          'ession algorithm is very sluggish so it is best to keep this sli' +
          'der in its default position.'
        WordWrap = True
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Multisource'
      ImageIndex = 6
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 435
        Height = 65
        Align = alClient
        Caption = 
          'Opens multiple files at once.'#13#13'When multiple files have the same' +
          ' name the files from archive names which come first in the alpha' +
          'bet are preferred.'#13'Note that you can neither add nor delete file' +
          's in this mode.'
        WordWrap = True
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Copyright'
      ImageIndex = 7
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 437
        Height = 403
        Align = alClient
        Caption = 
          '<begin of copyright notice; resize this window if you do not see' +
          ' the end>'#13#13'This program is licensed under GPL v2 or later.' +
          #13#13'The author is in no way affiliated with Pl' +
          'anet Moon Studios, Interplay or Nico Mak Computing.'#13'Planet Moon ' +
          'Studios, Digital Mayhem, Giants, Citizen Kabuto are trademarks o' +
          'f Planet Moon Studios or Interplay.'#13'WinZIP is a trademark of Nic' +
          'o Mak Computing Inc.'#13'There may other trademarks be mentioned wit' +
          'hout explicit notice.'#13#13'<end of copyright notice>'
        WordWrap = True
      end
    end
  end
end
