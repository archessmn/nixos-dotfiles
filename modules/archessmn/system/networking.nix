{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    tailscale = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      routingFeatures = mkOption {
        type = types.str;
        default = if cfg.tailscale.advertiseExitNode then "both" else "client";
      };

      advertiseExitNode = mkOption {
        type = types.bool;
        default = false;
      };

      advertiseRoutes = mkOption {
        type = types.str;
        default = "";
      };

      trustInterface = mkOption {
        type = types.bool;
        default = true;
      };
    };

    ssh = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      yubikeyRootAuth = mkOption {
        type = types.bool;
        default = true;
      };
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

    services.openssh = mkIf cfg.ssh.enable {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    users.users.root.openssh.authorizedKeys.keys = mkIf (cfg.ssh.enable && cfg.ssh.yubikeyRootAuth) [
      ''sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBB252zkVQgeI4NPUSqt0UzIxicmUspZr2SzPeb18IktFzeqsL/X6+g8AF4lBymuuiJPpMVMmDR9ux10YgW41HFMAAAAEc3NoOg==''
    ];

    services.tailscale = mkIf cfg.tailscale.enable {
      enable = true;
      package = unstable-pkgs.tailscale;
      useRoutingFeatures = cfg.tailscale.routingFeatures;
      extraSetFlags = (
        mkMerge [
          ([
            "--operator=${username}"
          ])
          (mkIf cfg.tailscale.advertiseExitNode [
            "--advertise-exit-node"
            "--advertise-routes=${cfg.tailscale.advertiseRoutes}"
          ])
        ]
      );
    };

    networking.interfaces = mkIf cfg.wakeonlan.enable {
      ${cfg.wakeonlan.interface}.wakeOnLan.enable = cfg.wakeonlan.enable;
    };

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
      (mkIf cfg.tailscale.trustInterface {
        trustedInterfaces = [ "tailscale0" ];
      })
    ];

    networking.nameservers = [
      "127.0.0.1"
    ];

    networking.search = [
      "wahoo-monster.ts.net"
    ];

    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = [
            "127.0.0.1"
            "172.30.0.1"
            "172.31.0.1"
          ];
          interface-automatic = "yes";
          access-control = [
            "127.0.0.0/8 allow"
            "172.30.0.0/16 allow"
            "172.31.0.0/16 allow"
          ];
          do-not-query-localhost = "no";
          val-permissive-mode = "yes";
          module-config = "iterator";
        };

        forward-zone = [
          {
            name = "consul";
            forward-addr = "127.0.0.1@8600";
          }
          {
            name = "ts.net.";
            forward-addr = "100.100.100.100";
          }
          {
            name = ".";
            forward-addr = "1.1.1.1";
          }
        ];
      };
    };

    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
  };
}
