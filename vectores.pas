unit vectores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;

type
  tvector=class
    x,y:extended;
    constructor create();
    procedure sumar(v1,v2:tvector);
    function modulo():extended;
    procedure resta(v1,v2:tvector);
    function angulo():extended;
    procedure limitar(max:extended);
    procedure ProductoEscalar(escalar:extended);
    procedure dividirescalar(escalar:extended);
  end;

implementation

constructor tvector.create();
begin
     x:=0;
     y:=0;
end;

procedure tvector.sumar(v1,v2:tvector);
var
  //a:tvector;
  b,c:extended;
begin

   x:=v1.x+v2.x;
   y:=v1.y+v2.y;

end;

function tvector.modulo():extended;
begin
     result:=sqrt(sqr(x)+sqr(y));
end;

procedure tvector.resta(v1,v2:tvector);
var
  //a:tvector;
  b,c:extended;
begin
     x:=v1.x-v2.x;
     y:=v1.y-v2.y;

end;

function tvector.angulo():extended;
begin
     result:=arctan2(x,y);
end;

procedure tvector.limitar(max:extended);
 var  m:extended;
 begin
      m:=sqrt(sqr(x)+sqr(y));
      if m>max then
      begin
           x:=x*max/m;
           y:=y*max/m;
      end;
end;

procedure tvector.ProductoEscalar(escalar:extended);
begin
     x:=x*escalar;
     y:=y*escalar;
end;

procedure tvector.dividirescalar(escalar:extended);
begin
     if escalar <> 0 then begin
        x:=x/escalar;
        y:=y/escalar;
     end;
end;
end.

