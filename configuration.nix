{ pkgs, ... }:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "btrfs"
        "nvme"
        "rtsx_pci_sdmmc"
      ];
      luks.devices.NixOS.device = "/dev/disk/by-label/NixOS\\\\x20encrypted";
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 0;
    };
  };

  fileSystems = {
    "/" = {
      fsType = "btrfs";
      label = "NixOS";
      options = [ "defaults" "noatime" "compress=zstd" ];
    };
    "/boot" = {
      label = "boot";
      fsType = "vfat";
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = { enable = true; package = pkgs.pulseaudioFull; };
    system76.enableAll = true;
    enableRedistributableFirmware = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  networking = {
    hostName = "darter6";
    domain = "shealevy.com";
  };
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;
  services = {
    avahi = {
      enable = true;
      hostName = "darter6";
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      libinput = {
        enable = true;
        mouse.naturalScrolling = true;
        touchpad.naturalScrolling = true;
      };
    };
  };
  system.stateVersion = "22.05";
  time.timeZone = "US/Eastern";
  users = {
    mutableUsers = false;
    users.shlevy = {
      description = "Shea Levy";
      extraGroups = [ "wheel" "input" "scanner" "lp" "docker" "dialout" "networkmanager" ];
      hashedPassword = "$6$NLWzl6guBhE.jNG$N9gwNDVLXFs5DcVZAalktWYNfYYad9zWpN4ngKJdTMiSEhfIQ0cPfExk5xLJnDApTK0EqvYcIeaNkAl./aAJx1";
      isNormalUser = true;
      uid = 1000;
    };
  };
}
