
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program ngrok_proxy;



{$r *.res}





{$R *.dres}

uses
  windows,
  ngrokmain in 'ngrokmain.pas';

var
  myngrok_proxy :tngrok_proxy;
begin
  try
    myngrok_proxy := tngrok_proxy.create();
    myngrok_proxy.ngrok_start;
  except
    
  end;
end.
