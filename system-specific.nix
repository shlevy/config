{ lib, config, ... }: let
  inherit (lib) types mkOption;

  inherit (types) listOf str enum bool;
in {
  options.systemSpecific = {
    bootDiskKernelModules = mkOption {
      type = listOf str;
      description = "Kernel modules needed to find the boot disk";
    };

    bootDeviceLabel = mkOption {
      type = str;
      description = "Label for the boot device";
      default = "NixOS-encrypted";
    };

    kvmType = mkOption {
      type = enum [ "intel" ];
      description = "CPU type for KVM";
    };

    machineName = mkOption {
      type = str;
      description = "Name of the machine";
    };
  };

  config = let
    cfg = config.systemSpecific;
  in {
    boot = {
      initrd = {
        availableKernelModules = cfg.bootDiskKernelModules;

        luks.devices.NixOS.device = "/dev/disk/by-label/${cfg.bootDeviceLabel}";
      };

      kernelModules = [ "kvm-${cfg.kvmType}" ];
    };
  };
}
