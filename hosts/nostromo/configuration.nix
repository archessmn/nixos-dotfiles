{ inputs
, config
, lib
, pkgs
, username
, unstablePkgs
, ...
}:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.blacklistedKernelModules = [ "elan_i2c" ];

  archessmn = {
    desktop = {
      enable = true;
      virtualBox = true;
    };

    home.home-manager.desktop = {
      activate-linux.enable = true;
      gnome.gsconnect.enable = true;
    };

    system = {
      bootloader = "grub";
      efiPath = "/boot/efi";
      graphics.brand = "intel";
      thinkpad.enable = true;
    };
  };

  security.sudo.extraRules = [{
    users = [ "${username}" ];
    runAs = "ALL:ALL";
    commands = [{
      command = "/run/current-system/sw/bin/systemctl restart unfuck-trackpad.service";
      options = [ "NOPASSWD" ];
    }];
  }];

  home-manager.users.${username}.programs.fish.shellAliases = {
    unfuck-trackpad = "sudo systemctl restart unfuck-trackpad.service";
  };

  systemd.services.unfuck-trackpad = {
    enable = true;
    description = "Unfucks the trackpad";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c '/run/current-system/sw/bin/echo -n \"elantech\" | /run/current-system/sw/bin/tee /sys/bus/serio/devices/serio1/protocol'";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking.hostName = "nostromo"; # Define your hostname.

  system.stateVersion = "24.05"; # Did you read the comment?

}

