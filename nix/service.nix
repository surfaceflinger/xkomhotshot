{
  config,
  lib,
  pkgs,
  ...
}: let
  xkomhotshot = pkgs.callPackage ./package.nix {
    inherit pkgs;
  };

  cfg = config.services.xkomhotshot;
in {
  options.services.xkomhotshot.enable = lib.mkEnableOption "xkomhotshot";

  config = lib.mkIf cfg.enable {
    systemd.timers.xkomhotshot = {
      wantedBy = ["timers.target"];
      partOf = ["xkomhotshot.service"];
      timerConfig.OnCalendar = ["*-*-* 10:00:05 Europe/Warsaw" "*-*-* 22:00:05 Europe/Warsaw"];
    };

    systemd.services.xkomhotshot = {
      serviceConfig = {
        Type = "oneshot";
        PrivateDevices = "true";
        ProtectKernelTunables = "true";
        ProtectKernelModules = "true";
        ProtectControlGroups = "true";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        LockPersonality = "true";
        RestrictRealtime = "true";
        ExecStart = "${xkomhotshot}/bin/main.py";
        User = "xkomhotshot";
        Group = "xkomhotshot";
      };
    };

    users.users.xkomhotshot = {
      group = "xkomhotshot";
      isSystemUser = true;
    };
    users.groups.xkomhotshot = {};
  };
}
