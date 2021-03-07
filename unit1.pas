unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls, grafo, modificar, estadisticas;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    IdleTimer1: TIdleTimer;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Timer1: TTimer;
    Timer2: TTimer;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;


var
  Form1: TForm1;
      vels:tarrext;

implementation
//Acciones de dibujar en formulario con canvas

procedure leerFactores(out F:TFactores);
 begin
     F.radio:=form1.Trackbar1.Position;
     F.Fsep:=form1.TrackBar2.Position;
     F.Fcoh:=form1.TrackBar3.Position/1000;
     F.Fali:=form1.TrackBar4.Position/1000;
     F.Fatra:=0.02;
     F.TamY := form1.Height;
     F.TamX := form1.Width-162;
     F.T1X:=form1.Left;
     F.T1Y:=form1.Top;
     F.raton:=form1.CheckBox2.Checked;
     F.paredes:=form1.CheckBox5.Checked;
end;

procedure refrescarPantalla(TamX,TamY:integer);
begin
     form1.canvas.Brush.color:=cldefault;
     form1.canvas.Pen.color:=cldefault;
     form1.Canvas.Rectangle(TamX,0,form1.Width,form1.Height);
     form1.canvas.Brush.color:=clblack;
     form1.canvas.pen.color:=clblack;
     form1.canvas.Rectangle(0,0,TamX,form1.Height);
end;

procedure dibujarPatos(List:Tgrafo);
var i:integer;
    puntero:tpunter;
    a,b,c:tpoint;
    d:array of tpoint;
    tam,ang:extended;
begin
     for i:=0 to list.count-1 do
     begin
          puntero:=list.items[i];
          form1.canvas.brush.color:=puntero^.color;
          form1.canvas.pen.color:=puntero^.color;

          tam:=10;
          ang:=0.6;

          a.x:=round(puntero^.pos.x+tam*sin(puntero^.vel.angulo()));
          a.y:=round(puntero^.pos.y+tam*cos(puntero^.vel.angulo()));
          b.x:=round(puntero^.pos.x-tam*sin(puntero^.vel.angulo()-ang));
          b.y:=round(puntero^.pos.y-tam*cos(puntero^.vel.angulo()-ang));
          c.x:=round(puntero^.pos.x-tam*sin(puntero^.vel.angulo()+ang));
          c.y:=round(puntero^.pos.y-tam*cos(puntero^.vel.angulo()+ang));
          setlength(d, 3);
          d[0]:=a;
          d[1]:=b;
          d[2]:=c;
          form1.Canvas.Polygon(d);
     end;
end;

procedure dibujarvecindario(patos:tgrafo);
var
    y,x:integer;
    px,py:tpunter;
begin
     form1.canvas.Brush.color:=clred;
     form1.canvas.Pen.Color:=clred;
     for y:=0 to patos.count-1 do
         for x:=y+1 to patos.count-1 do
              if patos.tabla[x,y] then begin
                px:=patos.items[x];
                py:=patos.items[y];
                form1.canvas.MoveTo(trunc(py^.pos.x),trunc(py^.pos.y));
                form1.canvas.LineTo(trunc(px^.pos.x),trunc(px^.pos.y));
         end;
end;

procedure dibujarfuerzas(patos:tgrafo);
var
  p:tpunter;
  i:integer;
begin
     for i:=0 to patos.count-1 do begin
         p:=patos.items[i];

         form1.canvas.pen.color:=clgreen;
         form1.canvas.moveto(trunc(p^.pos.x),trunc(p^.pos.y));
         form1.canvas.lineto(trunc(p^.pos.x+p^.sep.x*60),trunc(p^.pos.y+p^.sep.y*60));

         form1.canvas.pen.color:=clblue;
         form1.canvas.moveto(trunc(p^.pos.x),trunc(p^.pos.y));
         form1.canvas.lineto(trunc(p^.pos.x+p^.coh.x*60),trunc(p^.pos.y+p^.coh.y*60));

         form1.canvas.pen.color:=clyellow;
         form1.canvas.moveto(trunc(p^.pos.x),trunc(p^.pos.y));
         form1.canvas.lineto(trunc(p^.pos.x+p^.ali.x*60),trunc(p^.pos.y+p^.ali.y*60));
     end;
end;

procedure dibujarnumero(patos:tgrafo);
var
  p:tpunter;
  i:integer;
begin
     for i:=0 to patos.count-1 do begin
         p:=patos.items[i];
         form1.Canvas.Font.Color:=clwhite;
         form1.Canvas.Brush.color:=clblack;
         form1.Canvas.TextOut(trunc(p^.pos.x+5),trunc(p^.pos.y+5),inttostr(i+1));
         //form1.canvas.lineto(trunc(p^.pos.x+p^.sep.x*60),trunc(p^.pos.y+p^.sep.y*60));

     end;
end;

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);

begin
  Patos:=tgrafo.Create;
end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);
begin
  if not form2.Visible then
     form1.Timer1.interval:=(31-form1.TrackBar5.Position)*2;
end;

procedure TForm1.Timer1Timer(Sender: TObject);

begin
  leerfactores(F);
  patos.vecindario1(F.radio);
  refrescarPantalla(F.TamX,F.TamY);
  dibujarpatos(patos);
  if form1.CheckBox1.Checked then
     dibujarvecindario(patos);
  if form1.checkbox3.Checked then
     dibujarfuerzas(patos);
  if form1.CheckBox4.Checked then
     dibujarnumero(patos);
  patos.simulacion(F);
  form1.Timer2.Interval:=form1.Timer1.Interval*4;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
    vm:extended;
begin
    form1.Timer2.Interval:=form1.Timer1.Interval*4;
     // estadisticas
     velocidadmedia(patos,vm);
     anadirVelocidad(vm,vels);
     graficoVelMedia(vels);
end;

procedure TForm1.FormClick(Sender: TObject);
var punter:tpunter;
begin
  //crear pato
  if form1.RadioButton1.Checked then begin
     new(punter);
     punter^:=tnodo.crear(mouse.CursorPos.x-form1.Left-8,
                          mouse.CursorPos.y-form1.top-20);
     patos.add(punter);
  end;
  //modificar pato
  if form1.RadioButton2.Checked and (patos.count>0) then begin
     form1.Timer1.Interval:=0;
     form2.show;
  end;

  //eliminar pato
  if (form1.RadioButton3.Checked) and (patos.count>0) then begin
     patos.Delete(patos.indexof(patos.mascercano(mouse.CursorPos.x-form1.Left-8,
                          mouse.CursorPos.y-form1.top-20)));
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if form1.Timer1.Interval>0 then begin
     form1.Timer1.Interval:=0;
     form1.idleTimer1.Interval:=0;
     form1.Button2.Caption:='Iniciar';
     form1.Button3.enabled:=true;
  end
  else begin
     form1.Timer1.Interval:=form1.TrackBar5.Position;
     form1.idleTimer1.Interval:=40;
     form1.Button2.Caption:='Detener';
     form1.Button3.enabled:=false;
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form1.Timer1Timer(Sender);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  form3.show;
end;


end.

