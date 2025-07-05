{ self, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xkomhotshot;
in

{
  # Interface
  options.services.xkomhotshot = {
    enable = mkEnableOption (mdDoc "xkomhotshot");
    environmentFile = mkOption {
      type = types.path;
      default = null;
      example = "/run/secrets/xkomhotshot.env";
    };
  };

  # Implementation
  config = mkIf cfg.enable {

    systemd.timers.xkomhotshot = {
      wantedBy = [ "timers.target" ];
      partOf = [ "xkomhotshot.service" ];
      timerConfig.OnCalendar = [
        "*-*-* 10:00:05 Europe/Warsaw"
        "*-*-* 22:00:05 Europe/Warsaw"
      ];
    };

    systemd.services.xkomhotshot = {
      serviceConfig = {
        Type = "oneshot";
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        LockPersonality = true;
        RestrictRealtime = true;
        DynamicUser = true;
        EnvironmentFile = cfg.environmentFile;
        ExecStart = lib.getExe self.packages.${pkgs.system}.default;
      };
    };
  };
}
