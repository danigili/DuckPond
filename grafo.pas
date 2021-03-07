unit grafo;

{$mode objfpc}{$H+}

interface

uses
  Classes,vectores, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls, math;

type

TFactores=record
  Fsep,Fali,Fcoh,Fatra,radio:extended;
  tamx,tamy,T1X,T1Y:integer;
  raton,paredes:boolean;
end;

tgrafo=class(tlist)
  tabla:array of array of boolean;
  procedure vecindario1(radio:extended);
  function listarvecinos(puntero:pointer):tlist;
  procedure simulacion(F:TFactores);
  function mascercano(posx,posy:integer):pointer;
end;

tpunter = ^tNodo;

tNodo =  class
              pos: tvector;
              vel:tvector;
              acel:tvector;
              fuerza:tvector;
              vmax:extended;
              peso:extended;
              atra:tvector;
              sep:tvector;
              coh:tvector;
              ali:tvector;
              wall:tvector;
              vecinos:tlist;
              color:Tcolor;
              nombre:string;
              constructor crear(x,y:integer);
              procedure separacion(factor:extended);
              procedure cohesion(factor:extended);
              procedure alineacion (factor:extended);
              procedure atraccion();
              procedure paredes();
              procedure calculoposicion(F:TFactores);
              procedure limites(tamx,tamy:integer);
              procedure calculovelocidad(F:TFactores);
              procedure calculoaceleracion(F:TFactores);
              end;

var
  F:TFactores;

implementation

constructor tnodo.crear(x,y:integer);
begin
   randomize;
   pos:=tvector.create;
   pos.x:=x;
   pos.y:=y;
   vel:=tvector.create;
   vel.x:=random(4)-2;
   vel.y:=random(4)-2;
   acel:=tvector.create;
   acel.x:=0;
   acel.y:=0;
   atra:=tvector.create;
   atra.x:=0;
   atra.y:=0;
   sep:=tvector.create;
   sep.x:=0;
   sep.y:=0;
   coh:=tvector.create;
   coh.x:=0;
   coh.y:=0;
   ali:=tvector.create;
   ali.x:=0;
   ali.y:=0;
   wall:=tvector.create;
   fuerza:=tvector.create;
   fuerza.x:=0;
   fuerza.y:=0;
   peso:=4;
   color:=random(10000000);
   vmax:=4;
   vecinos:=tlist.create;
   nombre:='sinNombre';
end;

function tgrafo.mascercano(posx,posy:integer):pointer;
var
  i:integer;
  punteri:tpunter;
  minim,distancia:extended;
begin
   minim:=10000000;
   for i:=0 to count-1 do
    begin
       punteri:=Items[i];
       distancia:=sqrt(sqr(posx-punteri^.pos.x)+sqr(posy-punteri^.pos.y));
       if distancia<minim then begin
         minim:=distancia;
         result:=punteri;
       end;
    end;
end;

procedure tgrafo.vecindario1(radio:extended);
var
  punteri,punterj:tpunter;
  i,j:integer;
  distancia:extended;
begin
  setlength(tabla, 0, 0);
  setlength(tabla, count, count);
  for j:=0 to count-1 do
      for i:=j+1 to count-1 do
          begin
             punterj:=Items[j];
             punteri:=items[i];
             distancia:=sqrt(sqr(punterj^.pos.x-punteri^.pos.x)+sqr(punterj^.pos.y-punteri^.pos.y));
             if distancia<=radio then
             begin
                  tabla[i,j]:=true;
                  tabla[j,i]:=true;
             end;
          end;
end;

function tgrafo.listarvecinos(puntero:pointer):tlist;
var
  i:integer;
begin
  result:=tlist.create;
  for i:=0 to count-1 do
      if tabla[i,indexof(puntero)]=true then
         result.add(items[i]);
end;

procedure tnodo.separacion(factor:extended);
var  i:integer;
     a:tvector;
     modul:extended;
     puntero:tpunter;
begin
     a:=tvector.create;
     modul:=vecinos.count;
     sep.x:=0;
     sep.y:=0;
     for i:=0 to vecinos.Count-1 do
     begin
        a.x:=0;
        a.y:=0;
        puntero:=vecinos.Items[i];
        a.resta(puntero^.pos,pos);
        if a.modulo()<>0 then
           a.limitar(-factor/a.modulo());
        sep.sumar(sep,a);
     end;
     a.destroy;
end;

procedure tnodo.cohesion(factor:extended);
 var
   i:integer;
   centro:tvector;
   puntero:tpunter;
 begin
      centro:=tvector.create;
      coh.x:=0;
      coh.y:=0;
      for i:=0 to vecinos.count-1 do
      begin
           puntero:=vecinos.items[i];
           centro.sumar(centro,puntero^.pos);
      end;
      centro.dividirescalar(vecinos.count);
      if vecinos.count<>0 then begin
         coh.resta(centro,pos);
         coh.productoescalar(factor);
      end;
      centro.destroy;
end;

procedure tnodo.alineacion (factor:extended);
var i:integer;
    angulo:extended;
    puntero:tpunter;
begin
     //ponemos la variables a 0
     ali.x:=0;
     ali.y:=0;
     angulo:=0;
     //para todos los vecinos hacer
     for i:=0 to vecinos.count-1 do
      begin
          puntero:=vecinos.items[i];
          //el angulo es igual a la suma de la diferencia entre el
          //angulo del pato actual y el del vecino
           angulo:=vel.angulo()-puntero^.vel.angulo()+angulo;
      end;
     if (vecinos.count<>0) and (angulo<>0) then begin
        //se calcula la diferencia media
        angulo:=angulo/vecinos.count;
        //entonces se crea una fuerza en angulo recto respecto la velocidad
        //hacia la derecha o hacia la izquierda dependiendo de si el angulo
        //calculado anteriormente es positivo o negativo
        ali.x:=sin(vel.angulo-pi/2*angulo/abs(angulo))*factor;
        ali.y:=cos(vel.angulo-pi/2*angulo/abs(angulo))*factor;
  end;
end;

procedure tnodo.atraccion();
var vector:tvector;
begin
     atra.x:=0;
     atra.y:=0;
     vector:=tvector.create();
     vector.x:=(mouse.CursorPos.x-F.T1X-pos.x-8);
     vector.y:= (mouse.CursorPos.y-F.T1Y-pos.y-20);
     if vector.modulo()<200 then begin
        atra.x:=-(mouse.CursorPos.x-F.T1X-pos.x-8)/100;
        atra.y:=-(mouse.CursorPos.y-F.T1Y-pos.y-20)/100;

     end;
     vector.destroy;
end;

procedure tnodo.paredes();   //cambiar
var ff:extended;
begin
     ff:=vel.modulo()*peso/4;
     wall.x:=0;
     wall.y:=0;
     if (pos.y<25)then
          wall.y:=ff;
     if (pos.y>F.tamy-25)then
        wall.y:=-ff;
     if (pos.x>F.tamx-25)then
        wall.x:=-ff;
     if (pos.x<25)then
        wall.x:=ff;
end;

procedure tnodo.calculoaceleracion(F:TFactores);
var a:extended;
begin
    separacion(F.fsep);
    cohesion(F.fcoh);
    alineacion(F.Fali);
    if F.raton=True then
       atraccion();
    if F.paredes=True then
       paredes();

    fuerza.sumar(atra,sep);
    fuerza.sumar(fuerza,wall);
    fuerza.sumar(fuerza,coh);
    fuerza.sumar(fuerza,ali);
    acel.x:=fuerza.x/peso;      { TODO : hay que ponerlo con vectores, funcion dividir
    }
    acel.y:=fuerza.y/peso;
end;

procedure tnodo.limites(tamx,tamy:integer);
var x,y:integer;
begin
     x:=trunc(pos.x);
     y:=trunc(pos.y);
     if x>TamX then
       begin
            x:=0;
            y:=TamY-y;
       end;
       if x<0 then
       begin
            x:=TamX;
            y:=TamY-y;
       end;
       if y>TamY then
       begin
           y:=0;
           x:=TamX-x;
       end;
       if y<0 then
       begin
            y:=TamY;
            x:=TamX-x;
       end;
       pos.x:=x;
       pos.y:=y;
end;

procedure tnodo.calculovelocidad(F:TFactores);
begin
    calculoaceleracion(F);
    vel.sumar(vel,acel);
    vel.limitar(vmax);
end;

procedure tnodo.calculoposicion(F:TFactores);
begin

  calculovelocidad(F);
  pos.sumar(pos,vel);

end;

procedure tgrafo.simulacion(F:TFactores);
var
  i:integer;
  vecinos:tlist;
  puntero:tpunter;
begin
  for i:=0 to count-1 do  begin
      puntero:=items[i];
      puntero^.vecinos:=listarvecinos(puntero);
      puntero^.calculoposicion(F);
      puntero^.vecinos.destroy;
  end;
  for i:=0 to count-1 do  begin
      puntero:=items[i];
      puntero^.limites(F.tamx,F.tamy);
  end;
end;

end.
