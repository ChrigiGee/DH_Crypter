// Unit : Tools for Crypter
// Coded By Doddy Hackman in the year 2015
// Credits : Based on OP Crypter By Xash
// Thanks to Xash

unit tools;

interface

uses SysUtils, Windows;

function leer_datos(archivo, delimitador1, delimitador2: string): string;
function escribir_datos(ruta, delimitador1, delimitador2, texto: string): bool;

function leer_archivo(archivo_a_leer: String): AnsiString;
function xor_now(texto: string; clave: integer): string;

implementation

function xor_now(texto: string; clave: integer): string;
var
  numero: integer;
  contenido: string;
begin
  contenido := '';
  for numero := 1 to Length(texto) do
  begin
    contenido := contenido + Char(integer(texto[numero]) xor clave);
  end;
  Result := contenido;
end;

function leer_archivo(archivo_a_leer: String): AnsiString;
var
  archivo: File;
  tipo: Byte;
begin
  tipo := FileMode;
  try
    FileMode := 0;
    AssignFile(archivo, archivo_a_leer);
{$I-}
    Reset(archivo, 1);
{$I+}
    if IoResult = 0 then
      try
        SetLength(Result, FileSize(archivo));
        if Length(Result) > 0 then
        begin
{$I-}
          BlockRead(archivo, Result[1], Length(Result));
{$I+}
          if IoResult <> 0 then
            Result := '';
        end;
      finally
        CloseFile(archivo);
      end;
  finally
    FileMode := tipo;
  end;
end;

function leer_datos(archivo, delimitador1, delimitador2: string): string;

var
  contenido: string;
  limite: integer;
  dividiendo: integer;
  dividiendo2:integer;
  dividiendo3:integer;
  dividiendo4:integer;
  control1: integer;
  control2: integer;
  suma: integer;
  numero: integer;
  suma_inicial_1:integer;
  suma_inicial_2:integer;
  suma_casi_1:integer;
  suma_casi_2:integer;
  resultado: string;
  contenido_final:string;
  suma_final_1:integer;
  suma_final_2:integer;
  suma_final_3:integer;
begin

  if (FileExists(archivo)) then
  begin
    contenido := leer_archivo(archivo);

    suma_inicial_1 := Length(delimitador1);
    suma_inicial_2 := Length(contenido);

    suma_final_1 := Pos(delimitador1, contenido);
    suma := suma_final_1 + suma_inicial_1;

    dividiendo := suma_inicial_2 - suma;
    dividiendo2 := suma_inicial_2 - dividiendo;

    contenido := Copy(contenido, dividiendo2,
      suma_inicial_2);

    suma_casi_1 := Pos(delimitador1, contenido);
    suma_casi_2 := suma_casi_1 + suma_inicial_1;

    suma_final_2:= Pos(delimitador2, contenido);
    control1 := suma_final_2 - suma_casi_2;

    control2 := control1 - 1;

    for numero := 0 to control2 do
    begin
      dividiendo3 := suma_inicial_1 + numero;
      suma_final_3 := Pos(delimitador1, contenido);
      dividiendo4 := suma_final_3 + dividiendo3;
      contenido_final := contenido[dividiendo4];
      resultado := resultado + contenido_final;
    end;

    if resultado = '' then
    begin
      resultado := 'Error';
    end
    else
    begin
      Result := resultado;
    end;
  end
  else
  begin
    Result := 'Error';
  end;
end;

function escribir_datos(ruta, delimitador1, delimitador2, texto: string): bool;
var
  abriendo_archivo: TextFile;
begin
  if (FileExists(ruta)) then
  begin
    AssignFile(abriendo_archivo, ruta);
    Append(abriendo_archivo);
    try
      begin
        WriteLn(abriendo_archivo, delimitador1 + texto + delimitador2);
      end
    finally
      begin
        CloseFile(abriendo_archivo);
      end;
      Result := True;
    end;
  end
  else
  begin
    Result := False;
  end;

end;

end.

// The End ?
