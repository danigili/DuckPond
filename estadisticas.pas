unit estadisticas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, grafo;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

  Tarrext=array of extended;

 procedure VelocidadMedia(Patos:Tgrafo; out velMedia:extended);
 procedure graficoVelMedia (velocidades:Tarrext);
 procedure anadirVelocidad(vm:extended; var velocidades:Tarrext);

var
  Form3: TForm3;

implementation

{$R *.lfm}

procedure anadirVelocidad(vm:extended; var velocidades:Tarrext);
 var lon:integer;
 begin
      lon:= length(velocidades)+1;
      setlength(velocidades, lon);
      velocidades[lon-1]:=vm;
 end;

procedure maximo(valores:Tarrext; out vmax:extended);
var i:integer;
begin
     vmax:=0;
     for i:=0 to length(valores)-1 do
         if vmax<valores[i] then
            vmax:=valores[i];
end;

procedure VelocidadMedia(Patos:tgrafo; out velMedia:extended);
var
    i:integer;
    puntero:tpunter;
begin
     velMedia:=0;
     for i:=0 to patos.count-1 do begin
         puntero:=patos.items[i];
         velMedia:=velMedia+puntero^.vel.modulo;
     end;
     if patos.count <> 0 then
          velMedia:=velMedia/(patos.count);
end;

//esta accion dibuja los valores de una tabla en un grafico. Hay que entrar
//la posicion del grafico y la tabla de valores
procedure dibujargrafico(valores:Tarrext; left,top,width,height:integer);
//left y top es la posicion del grafico y width y height es el tamaño
var i,y:integer;
    vactual,vmax:extended;  //valor a dibujar
begin
     //dibujar un rectangulo en blanco para refrescar la pantalla
     form3.Canvas.Rectangle(Left,Top,Left+Width,Height+Top);
     //calcular el valor maximo
     maximo(valores,vmax);
     //dibujar lineas horiontales
     form3.Canvas.Pen.Color:=clgray;
     for y:=1 to 6 do
         begin
              form3.Canvas.MoveTo(left,trunc(top+y/6*height));
              form3.canvas.lineto(left+width,trunc(top+y/6*height));
         end;
     //preparar canvas para dibujar la primera linea
     form3.Canvas.Pen.Color:=clblack;
     form3.canvas.moveto(Left+Width,trunc(height/2)+top);
     //desde 0 hasta la amplitud x del grafico
     for i:=1 to Width do
         begin
              //se extrae el valor a dibujar de la tabla de valores
              vactual:=valores[length(valores)-i];
              //si el indice actual es superior al tamaño de la tabla de valores entonces
              if (length(valores)>i) and (vactual<>0) then begin
                 // se dibuja el valor con canvas
                 form3.Canvas.lineto(Left+Width-i,top+trunc((-vactual+vmax)*height/vmax));
                 //se prepara canvas para dibujar la siguente linea
                 form3.canvas.moveto(Left+Width-i,top+trunc((-vactual+vmax)*height/vmax));
              end;
         end;
end;

procedure graficoVelMedia (velocidades:Tarrext);
var t,i:integer;
    velmedia:extended;
begin
     dibujargrafico(velocidades,form3.image1.left,form3.image1.top,form3.image1.width,form3.image1.height);
end;

end.



