{
  pkgs,
  pythonPkgs ? pkgs.python311Packages,
  ...
}: let
  package = {
    buildPythonPackage,
    python-telegram-bot,
    requests,
  }:
    buildPythonPackage {
      pname = "xkomhotshot";
      version = "0.0.1";
      src = ../.;
      propagatedBuildInputs = [python-telegram-bot requests];
      doCheck = false;
      meta.description = "Receive notifications on Telegram about new promotions on x-kom.pl";
    };
in
  pythonPkgs.callPackage package {}
