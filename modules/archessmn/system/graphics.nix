{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  theLocale,
  theTimezone,
  ...
}:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    graphics = {
      enable = mkOption {
        type = types.bool;
        default = desktopEnabled;
      };
      brand = mkOption {
        type = types.enum [
          "nvidia"
          "amd"
          "nvidia-special"
          "intel"
          "intel-old"
        ];
      };
    };
  };

  config = mkIf cfg.graphics.enable (mkMerge [
    # AMD Specific stuff
    (mkIf (cfg.graphics.brand == "amd") {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
    })

    # NVIDIA Specific stuff
    (mkIf (cfg.graphics.brand == "nvidia") {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.libvdpau-va-gl ];
      };

      environment.variables.VDPAU_DRIVER = "va_gl";
      environment.variables.LIBVA_DRIVER_NAME = "nvidia";
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
        # package =
        #   let
        #     rcu_patch = pkgs.fetchpatch {
        #       url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
        #       hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
        #     };
        #   in
        #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #     version = "535.154.05";
        #     sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
        #     sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
        #     openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
        #     settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
        #     persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
        #     patches = [ rcu_patch ];
        #   };
      };
    })

    # Nvidia specialisation for honkpad
    (mkIf (cfg.graphics.brand == "nvidia-special") {
      specialisation = {
        nvidia.configuration = {
          # Nvidia Configuration
          services.xserver.videoDrivers = [ "nvidia" ];
          hardware.graphics.enable = true;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
          hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

          # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
          hardware.nvidia.modesetting.enable = true;

          hardware.nvidia.open = true;

          hardware.nvidia.prime = {
            sync.enable = true;

            # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
            nvidiaBusId = "PCI:06:00:0";

            # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
            intelBusId = "PCI:00:02:0";
          };
        };
      };
    })

    (mkIf (cfg.graphics.brand == "intel") {
      hardware.opengl = {
        enable = true;
        extraPackages = [
          pkgs.onevpl-intel-gpu
        ];
      };
    })

    (mkIf (cfg.graphics.brand == "av-imposter") {
      hardware.opengl = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-sdk
        ];
      };
    })

  ]);
}
