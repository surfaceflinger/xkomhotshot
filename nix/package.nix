{ lib
, buildPythonPackage
, pysocks
, python-telegram-bot
, requests
}:
buildPythonPackage {
  name = "xkomhotshot";
  src = ../.;

  propagatedBuildInputs = [ pysocks python-telegram-bot requests ];

  meta = with lib; {
    description = "Receive notifications on Telegram about new promotions on x-kom.pl";
    homepage = "https://github.com/surfaceflinger/xkomhotshot";
    changelog = "https://github.com/surfaceflinger/xkomhotshot/commits/master";
  };
}
