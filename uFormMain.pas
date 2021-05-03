unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage, uDmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, System.DateUtils, Registry;

type
  TFormMain = class(TForm)
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Panel2: TPanel;
    Edt_subject: TEdit;
    Edt_to: TEdit;
    Btn_send: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    FDQuery: TFDQuery;
    FDTransaction: TFDTransaction;
    FDQueryID_SALES: TIntegerField;
    FDQueryBILLED: TWideStringField;
    FDQueryEMAIL: TWideStringField;
    FDQueryFULL_NAME: TWideStringField;
    FDQueryBILL_DATE: TDateField;
    Edt_body: TEdit;
    procedure Btn_sendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure autoSend;
    procedure Email(totarget, subject, body: string);
    procedure LastDay(date: TDate);
    procedure runBackground(const allUsers: boolean = False);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  mail_to: string;
  mail_subject: string;
  mail_body: string;
  Reg: TRegistry;

implementation

{$R *.dfm}

{ TForm1 }

procedure TFormMain.Email(totarget, subject, body: string);
var
  Data: TIdmessage;
  SMTP: TIdSMTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  Data := TIdmessage.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  SSL.SSLOptions.Method := sslvTLSv1;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyMode := [];
  SSL.SSLOptions.VerifyDepth := 0;

  Data.From.Address := 'leobcontato@gmail.com';
  Data.Recipients.EMailAddresses := totarget;
  Data.Subject := subject;
  Data.Body.Text := body;

  SMTP.IOHandler := SSL;
  SMTP.Host := 'smtp.gmail.com';
  SMTP.Port := 587;
  SMTP.Username := 'leobcontato@gmail.com';
  SMTP.Password := 'Leo1br115';
  SMTP.UseTLS := utUseExplicitTLS;

  SMTP.Connect;
  SMTP.Send(Data);
  SMTP.Disconnect;

  SMTP.Free;
  Data.Free;
  SSL.Free;

  try
    lastDay(Date);
  finally
    self.Close;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  runBackground(True);
end;

procedure TFormMain.Btn_sendClick(Sender: TObject);
begin
  LastDay(Date);
  autoSend;
end;

procedure TFormMain.LastDay(date: TDate);
var
  lastDay: TDateTime;
  month: Word;
begin
  lastDay := EndOfTheMonth(Date);
  month := MonthOf(Date);
  if date = lastDay then
  begin
    autoSend;
  end;
end;

procedure TFormMain.runBackground(const allUsers: boolean = False);
begin
  Reg := TRegistry.Create();
  try
    Reg.RootKey := byte(allUsers)+$80000001;
    if Reg.OpenKey('SoftwareMicrosoftWindowsCurrentVersionRun',True) then
    begin
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFormMain.autoSend;
begin
  mail_to := Edt_to.Text;
  mail_subject := Edt_subject.Text;
  mail_body := Edt_body.Text;

   try
    begin
      Email(mail_to, mail_subject, mail_body);
    end;
  except

  end;
end;

end.
