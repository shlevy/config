{ pkgs, lib, config, ... }:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "btrfs"
      ];
    };
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

  fileSystems = let
    subvols = {
      "/" = "rootfs";
      "/etc" = "etc";
      "/home" = "home";
      "/tmp" = "tmp";
      "/root" = "root";
      "/nix" = "nix";
    };
  in (lib.mapAttrs (_: subvol: {
    fsType = "btrfs";
    label = "NixOS";
    options = [ "defaults" "noatime" "compress=zstd" "subvol=${subvol}" ];
  }) subvols) // {
    "/boot" = {
      label = "boot";
      fsType = "vfat";
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = { enable = true; package = pkgs.pulseaudioFull; };
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
    hostName = config.systemSpecific.machineName;
    domain = "shealevy.com";
  };
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;
  services = {
    avahi = {
      enable = true;
      hostName = config.systemSpecific.machineName;
      nssmdns4 = true;
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
    };
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };
  };
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
