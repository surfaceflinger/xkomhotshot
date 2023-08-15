{ overlay }:
{ config
, lib
, pkgs
, ...
}:
with lib;

let
  cfg = config.services.xkomhotshot;
in

{
  # Interface
  options.services.xkomhotshot.enable = mkOption {
    type = types.bool;
    default = false;
  };

  # Implementation
  config = mkIf cfg.enable {

    nixpkgs.overlays = [ overlay ];

    systemd.timers.xkomhotshot = {
      wantedBy = [ "timers.target" ];
      partOf = [ "xkomhotshot.service" ];
      timerConfig.OnCalendar = [ "*-*-* 10:00:05 Europe/Warsaw" "*-*-* 22:00:05 Europe/Warsaw" ];
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
        ExecStart = "${pkgs.python3Packages.xkomhotshot}/bin/xkomhotshot";
        User = "xkomhotshot";
        Group = "xkomhotshot";
      };
    };

    users.users.xkomhotshot = {
      group = "xkomhotshot";
      isSystemUser = true;
    };
    users.groups.xkomhotshot = { };

    systemd.tmpfiles.rules = [ "d /var/lib/xkomhotshot 0700 xkomhotshot root - -" ];
  };
}
