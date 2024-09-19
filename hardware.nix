{ pkgs, ... }: {
  services.fwupd.enable = true;
  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
  };
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
