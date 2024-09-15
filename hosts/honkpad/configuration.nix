{ inputs
, config
, pkgs
, username
, hostname
, ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  
  archessmn = {
    desktop = {
      enable = true;
    };

    home.home-manager.desktop = {
      activate-linux.enable = true;
    };

    system = {
      battery.tlp.enable = true;
      bootloader = "systemd";
      fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = pkgs.libfprint-2-tod1-vfs0090;
        };
      };
      graphics.brand = "nvidia-special";
    };
  };

  networking.hostName = "honkpad"; # Define your hostname.

  system.stateVersion = "23.11";
}
