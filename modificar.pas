unit modificar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn, grafo;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ColorButton1: TColorButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
    patos:tgrafo;
    p:tpunter;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
 begin

   p^.nombre:=form2.edit3.text;
   if strtofloat(form2.edit1.text)>0 then
      p^.vmax:=strtofloat(form2.edit1.Text);
   if strtofloat(form2.edit2.text)>0 then
      p^.peso:=strtofloat(form2.edit2.Text);
   p^.color:=form2.colorbutton1.ButtonColor;

   form2.Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
    form2.Close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 p:=(patos.mascercano(mouse.CursorPos.x -F.T1X-8,
                        mouse.CursorPos.y-F.T1Y-20));

 form2.Edit3.Text:=p^.nombre;
 form2.Edit1.Text:=floattostr(p^.vmax);
 form2.Edit2.Text:=floattostr(p^.peso);
 form2.colorbutton1.ButtonColor :=p^.color;

end;


end.

