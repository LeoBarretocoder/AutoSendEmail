unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage, uDmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, System.DateUtils, Registry,
  Vcl.DBCtrls, IdSSLOpenSSL, uLybrary, System.SyncObjs;

type
  TFormMain = class(TForm)
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    Panel2: TPanel;
    Edt_subject: TEdit;
    Btn_send: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edt_body: TMemo;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    FDQuerySale: TFDQuery;
    FDTransactionSale: TFDTransaction;
    DS_Sale: TDataSource;
    FDQuerySaleEMAIL: TWideStringField;
    Edt_to: TEdit;
    procedure Btn_sendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure autoSend;
    procedure Email(totarget, subject, body: string);
    procedure LastDay(date: TDate);
    //function getEmail: string;
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
procedure TFormMain.FormActivate(Sender: TObject);
begin
  lastDay(Date);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  lastDay(Date);
end;

procedure TFormMain.Btn_sendClick(Sender: TObject);
begin
  autoSend;
end;

procedure TFormMain.LastDay(date: TDate);
var
  lastDay: TDateTime;
begin
  lastDay := EndOfTheMonth(Date);
  if date = strToDate('17/06/21') then
  begin
    try
      autoSend;
    finally
      ShowMessage('E-mais enviados aos devedores!');
    end;
  end;
end;

procedure TFormMain.autoSend;
var
mailBill: array of string;
begin
  mail_subject := Edt_subject.Text;
  mail_body := Edt_body.Text;

  FDQuerySale.Close;
  FDQuerySale.SQL.Clear;
  FDQuerySale.SQL.Add('SELECT C.email FROM sales S JOIN clients C on C.id_clients = S.id_clients WHERE S.billed = ''N'' AND C.id_clients > 0');
  FDQuerySale.Open;
  FDQuerySale.First;
  while not (FDQuerySale.Eof) do
  begin
    SetLength(mailBill, Succ(Length(mailBill)));
    mailBill[High(mailBill)] := FDQuerySale.FieldByName('email').AsString;
    mail_to :=  mailBill[High(mailBill)];
    try
      Email(mail_to, mail_subject, mail_body);
    except
      ShowMessage('Nao foi possivel enviar o email');
    end;
    FDQuerySale.Next;
  end;
end;

procedure TFormMain.Email(totarget, subject, body: string);
var
  Data: TIdmessage;
  SMTP: TIdSMTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  DATA := TIdMessage.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  SSL.SSLOptions.Method := sslvTLSv1;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyMode := [];
  SSL.SSLOptions.VerifyDepth := 0;

  DATA.From.Address := 'USERNAME';
  DATA.Recipients.EMailAddresses := totarget;
  DATA.subject := subject;
  DATA.body.text := body;

  SMTP.IOHandler := SSL;
  SMTP.Host := 'smtp.gmail.com';
  SMTP.Port := 587;
  SMTP.username := 'EMAIL';
  SMTP.password := 'SENHA';
  SMTP.UseTLS := utUseExplicitTLS;

  SMTP.Connect;
  try
    SMTP.Send(DATA);
  finally
    SMTP.Disconnect;
  end;

  SMTP.Free;
  DATA.Free;
  SSL.Free;
end;

end.
