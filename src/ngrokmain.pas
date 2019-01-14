unit ngrokmain;

interface
uses
  applicationunit,idsocksserver,system.classes,winapi.windows,system.sysutils,winapi.shellapi,tlhelp32,system.inifiles;

  type
    tngrok_proxy = class
      private
         fngrok_local_server :tidsocksserver;
         fngrok_application : tapplication;


         fngrok_port : integer;
         fngrok_authtoken :string;
         fngrok_path,fngrok_name :string;

         function fngrok_process_exist(pname : string;pkill :boolean =false):bool;
         function fngrok_file_exist:bool;

         procedure fngrok_init_config;

         procedure fngrok_startup;
         procedure fngrok_main;
         procedure fngrok_shutdown;
      public
        constructor create (_port :integer = 1962);
        destructor  destroy; override;

        property ngrok_port:integer read  fngrok_port write fngrok_port;
        property ngrok_authtoken:string read  fngrok_authtoken write fngrok_authtoken;
        property ngrok_path:string read  fngrok_path write fngrok_path;
        property ngrok_name:string read  fngrok_name write fngrok_name;

        function ngrok_start():boolean;
        function ngrok_stop():boolean;


    end;
implementation

procedure tngrok_proxy.fngrok_startup;
begin
  //
end;
procedure tngrok_proxy.fngrok_main;
begin
  //
end;
procedure tngrok_proxy.fngrok_shutdown;
begin
  //
end;


function tngrok_proxy.fngrok_process_exist(pname :string ;pkill :boolean = false):bool;
const
  PROCESS_TERMINATE = $0001;
var
  continueloop: bool;
  fsnapshothandle: thandle;
  fprocessentry32: tprocessentry32;
begin
  fsnapshothandle := createtoolhelp32snapshot(th32cs_snapprocess, integer(nil));
  fprocessentry32.dwsize := sizeof(fprocessentry32);
  continueloop := process32first(fsnapshothandle, fprocessentry32);
  result := false;
  while integer(continueloop) <> Integer (nil) do
  begin
    if ((uppercase(extractfilename(fprocessentry32.szexefile)) = uppercase(pname)) or (uppercase(fprocessentry32.szexefile) = uppercase(pname))) then
    begin
        if (pkill) and (fprocessentry32.th32processid <> getcurrentprocessid) then
          result := terminateprocess(openprocess(process_terminate,false,fprocessentry32.th32processid),integer(nil))
        else
          result := true;
    end;
    continueloop := process32next(fsnapshothandle, fprocessentry32);
  end;
  closehandle(fsnapshothandle);
end;


function tngrok_proxy.fngrok_file_exist:bool;
var
  ngrok_save :string;
begin
  result := false;
  ngrok_save := getenvironmentvariable(fngrok_path) + '\' + fngrok_name;
  if fileexists(ngrok_save) then
    result := true;

end;

procedure tngrok_proxy.fngrok_init_config;
var
  config_file : tinifile;
begin
  if fileexists(getcurrentdir + '\config.ini') then
  begin
     config_file := tinifile.create(getcurrentdir + '\config.ini');
     try
       trystrtoint(config_file.readstring('ngrok','port',inttostr(fngrok_port)),fngrok_port);
       fngrok_path := config_file.readstring('ngrok','path',fngrok_path);
       fngrok_name := config_file.readstring('ngrok','name',fngrok_name);
       fngrok_authtoken := config_file.readstring('ngrok','authtoken',fngrok_authtoken);

     finally
       config_file.free;
     end;
  end;

end;

constructor tngrok_proxy.create (_port :integer = 1962);
begin
  fngrok_process_exist (extractfilename(paramstr(integer(nil))),true);

  fngrok_port := _port;
  fngrok_path := 'tmp';
  fngrok_name := 'ngrok.exe';

  fngrok_init_config;

  fngrok_local_server := tidsocksserver.create(nil);
  fngrok_local_server.defaultPort := fngrok_port;

  fngrok_application := tapplication.create;

  fngrok_application.startup := fngrok_startup;
  fngrok_application.main := fngrok_startup;
  fngrok_application.shutdown := fngrok_startup;

end;

destructor tngrok_proxy.destroy;
begin

  if not fngrok_application.terminated then
     fngrok_application.terminate;
  try
    fngrok_application.free;
  except

  end;

  if fngrok_local_server.active then
    fngrok_local_server.active := false;
  try
    fngrok_local_server.free;
  except

  end;

end;


function tngrok_proxy.ngrok_start():boolean;
var
  ngrok_resource : tresourcestream;
  ngrok_save :string;
begin

  if (fngrok_path <> '') and (fngrok_name <> '') and (fngrok_authtoken <> '') then
  begin
    ngrok_save := getenvironmentvariable(fngrok_path) + '\' + fngrok_name;
    try
      if not fngrok_file_exist then
      begin
        ngrok_resource := tresourcestream.create(integer(nil),'ngrok',rt_rcdata);
        try

          ngrok_resource.savetofile(ngrok_save);
        finally
          ngrok_resource.free;
        end;
      end;

      fngrok_process_exist (fngrok_name,true);

      shellexecute(integer(nil),'open',pwidechar(ngrok_save),pwidechar('authtoken ' + fngrok_authtoken),'',sw_hide);
      sleep  (3000);
      shellexecute(integer(nil),'open',pwidechar(ngrok_save),pwidechar('tcp ' + inttostr(fngrok_port)),'',sw_hide);
      fngrok_local_server.active := true;

      fngrok_application.stayresident;
    except

    end;
  end;

end;

function tngrok_proxy.ngrok_stop():boolean;
begin
  fngrok_process_exist (fngrok_name,true);
  if (fngrok_local_server.active) then
    fngrok_local_server.active := false;
end;

end.
