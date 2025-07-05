{
  buildPythonPackage,
  cloudscraper,
  lib,
  pysocks,
  python-telegram-bot,
  setuptools,
}:
buildPythonPackage {
  name = "xkomhotshot";
  src = ../.;

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    cloudscraper
    pysocks
    python-telegram-bot
  ];

  meta = with lib; {
    changelog = "https://github.com/surfaceflinger/xkomhotshot/commits/master";
    description = "Receive notifications on Telegram about new promotions on x-kom.pl";
    homepage = "https://github.com/surfaceflinger/xkomhotshot";
    mainProgram = "xkomhotshot";
  };
}
