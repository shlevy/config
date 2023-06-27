{
 systemSpecific = {
    bootDiskKernelModules = [ "nvme" ];

    kvmType = "intel";

    machineName = "carbon";
  };

  system.stateVersion = "23.05";
}
