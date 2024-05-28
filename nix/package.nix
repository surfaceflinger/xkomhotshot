{ lib
, buildPythonPackage
, pysocks
, python-telegram-bot
, cloudscraper
}:
buildPythonPackage {
  name = "xkomhotshot";
  src = ../.;

  propagatedBuildInputs = [ cloudscraper pysocks python-telegram-bot ];

  meta = with lib; {
    changelog = "https://github.com/surfaceflinger/xkomhotshot/commits/master";
    description = "Receive notifications on Telegram about new promotions on x-kom.pl";
    homepage = "https://github.com/surfaceflinger/xkomhotshot";
    mainProgram = "xkomhotshot";
  };
}
