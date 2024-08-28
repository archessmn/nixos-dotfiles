{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    tailscale = mkOption {
      type = types.bool;
      default = true;
    };

    ssh = mkOption {
      type = types.bool;
      default = true;
    };

    wakeonlan = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      interface = mkOption {
        type = types.str;
        default = "";
      };
    };

    openFirewall = {
      wireguard = mkOption {
        type = types.bool;
        default = false;
      };

      tftp = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    # Networking stuff

    networking.networkmanager.enable = true;

    services.openssh = mkIf cfg.ssh {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    services.tailscale = mkIf cfg.tailscale {
      enable = true;
      package = unstablePkgs.tailscale;
    };

    networking.interfaces.${cfg.wakeonlan.interface}.wakeOnLan.enable = cfg.wakeonlan.enable;

    networking.firewall = mkMerge [
      (mkIf cfg.openFirewall.wireguard {
        logReversePathDrops = true;
        extraCommands = ''
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
        '';
        extraStopCommands = ''
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
        '';
      })
      (mkIf cfg.openFirewall.tftp {
        allowedUDPPorts = [ 69 ];
      })
    ];

    services.resolved.enable = true;

    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
  };
}
