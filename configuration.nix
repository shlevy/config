{ config, pkgs, lib, ... }:
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

  environment = {
    variables = {
      GNUPGHOME = "/home/shlevy/creds/gnupg";
      PASSWORD_STORE_DIR = "/home/shlevy/creds/password-store";
    };
    systemPackages = let
      gnupg = pkgs.gnupg.override { guiSupport = true; };
    in [
      pkgs.gitFull
      gnupg
      (pkgs.pass.override { inherit gnupg; })
      pkgs.firefox
      pkgs.slack
      pkgs.wl-clipboard
    ];
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
  nix = {
    maxJobs = 8;
    buildCores = 0;
    useSandbox = true;
    binaryCaches = [ "https://cache.iog.io" ];
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    trustedUsers = [ "shlevy" ];
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
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
