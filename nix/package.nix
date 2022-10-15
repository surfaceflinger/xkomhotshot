{
  pkgs,
  pythonPkgs ? pkgs.python310Packages,
  self,
}: let
  inherit pkgs;
  inherit pythonPkgs;

  f = {
    buildPythonPackage,
    python-telegram-bot,
    requests,
  }:
    buildPythonPackage rec {
      pname = "xkomhotshots";
      version = "0.0.1";

      src = ../.;

      propagatedBuildInputs = [python-telegram-bot requests];

      doCheck = false;

      meta = {
        description = ''
          Receive notifications on Telegram about new promotions on x-kom.pl
        '';
      };
    };

  drv = pythonPkgs.callPackage f {};
in
  if pkgs.lib.inNixShell
  then drv.env
  else drv
