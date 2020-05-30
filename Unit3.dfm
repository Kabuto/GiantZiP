object ExtractForm: TExtractForm
  Left = 42
  Top = 385
  Width = 508
  Height = 289
  Caption = 'Extract to...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ShellTreeView1: TShellTreeView
    Left = 265
    Top = 0
    Width = 235
    Height = 262
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Align = alClient
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
    OnClick = ShellTreeView1Click
    OnChange = ShellTreeView1Change
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 265
    Height = 262
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 48
      Height = 13
      Caption = 'Extract to:'
    end
    object Edit1: TEdit
      Left = 8
      Top = 32
      Width = 249
      Height = 21
      TabOrder = 0
    end
    object AllFilesRadio: TRadioButton
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = 'all files'
      TabOrder = 1
    end
    object SelectedFilesRadio: TRadioButton
      Left = 16
      Top = 96
      Width = 113
      Height = 17
      Caption = 'selected files'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object OverwriteCheckbox: TCheckBox
      Left = 8
      Top = 152
      Width = 129
      Height = 17
      Caption = 'Overwrite existing files'
      TabOrder = 3
    end
    object Extract: TButton
      Left = 32
      Top = 200
      Width = 75
      Height = 25
      Caption = 'Extract'
      ModalResult = 1
      TabOrder = 4
      OnClick = ExtractClick
    end
    object Cancel: TButton
      Left = 152
      Top = 200
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
    end
  end
end
