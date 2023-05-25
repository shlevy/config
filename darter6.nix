{
  systemSpecific = {
    bootDiskKernelModules = [ "nvme" "rtsx_pci_sdmmc" ];

    bootDeviceLabel = "NixOS\\\\x20encrypted";

    kvmType = "intel";

    machineName = "darter6";
  };

  hardware.system76.enableAll = true;

  system.stateVersion = "22.05";
}
