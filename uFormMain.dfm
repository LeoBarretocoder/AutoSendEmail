object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Email'
  ClientHeight = 249
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 192
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 258
    object Label3: TLabel
      Left = 32
      Top = 6
      Width = 12
      Height = 13
      Caption = 'To'
    end
    object Label4: TLabel
      Left = 32
      Top = 48
      Width = 3
      Height = 13
    end
    object Label5: TLabel
      Left = 32
      Top = 46
      Width = 36
      Height = 13
      Caption = 'Subject'
    end
    object Label6: TLabel
      Left = 32
      Top = 88
      Width = 24
      Height = 13
      Caption = 'Body'
    end
    object Edt_subject: TEdit
      Left = 32
      Top = 60
      Width = 193
      Height = 21
      TabOrder = 0
      Text = 'Contas a pagar'
    end
    object Edt_to: TEdit
      Left = 32
      Top = 19
      Width = 193
      Height = 21
      TabOrder = 1
      Text = 'leo.barreto11.br@gmail.com'
    end
    object Edt_body: TEdit
      Left = 32
      Top = 107
      Width = 193
      Height = 75
      TabOrder = 2
      Text = 'Por favor! entre em contato conosco para entender o transtorno'
    end
  end
  object Btn_send: TButton
    Left = 32
    Top = 208
    Width = 193
    Height = 33
    Caption = 'Send'
    TabOrder = 1
    OnClick = Btn_sendClick
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 328
    Top = 160
  end
  object IdSMTP1: TIdSMTP
    SASLMechanisms = <>
    Left = 328
    Top = 112
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 328
    Top = 64
  end
  object FDQuery: TFDQuery
    Connection = DmDados.FDConnection
    Transaction = FDTransaction
    SQL.Strings = (
      'SELECT  id_sales,'
      '        billed,'
      '        bill_date,'
      '        id_clients'
      'FROM sales'
      'WHERE id_sales =: id_sales')
    Left = 296
    Top = 8
    object FDQueryID_SALES: TIntegerField
      FieldName = 'ID_SALES'
      Origin = 'ID_SALES'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQueryBILLED: TWideStringField
      FieldName = 'BILLED'
      Origin = 'BILLED'
      Size = 1
    end
    object FDQueryEMAIL: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      ProviderFlags = []
      ReadOnly = True
      Size = 120
    end
    object FDQueryFULL_NAME: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'FULL_NAME'
      Origin = 'FULL_NAME'
      ProviderFlags = []
      ReadOnly = True
      Size = 80
    end
    object FDQueryBILL_DATE: TDateField
      FieldName = 'BILL_DATE'
      Origin = 'BILL_DATE'
    end
  end
  object FDTransaction: TFDTransaction
    Connection = DmDados.FDConnection
    Left = 368
    Top = 8
  end
end
