{
 systemSpecific = {
    bootDiskKernelModules = [ "nvme" "rtsx_pci_sdmmc" ];

    kvmType = "intel";

    machineName = "spectre";
  };

  system.stateVersion = "22.11";
}
