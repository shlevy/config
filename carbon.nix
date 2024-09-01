{ pkgs, ... }: {
  imports = [
    ./btrfs.nix
    ./creds.nix
    ./mail.nix
    ./finances.nix
    ./single-encrypted-disk.nix
    ./shlevy.nix
    ./blink.nix
    ./git/shlevy.nix
    ./git/server.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" ];
    };

    kernelModules = [ "kvm-intel" ];
  };

  networking = {
    hostName = "carbon";
    domain = "shealevy.com";
  };

  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];

  system.stateVersion = "23.05";
  home-manager.users.shlevy.home.stateVersion = "22.11";

  home-manager.users.shlevy.home.packages = with pkgs; [
    discord
    signal-desktop
    element-desktop
    whatsapp-for-linux
    wineWowPackages.waylandFull
  ];

  hardware.ipu6 = {
    enable = false; # Not working yet...
    platform = "ipu6ep";
  };

  services.tailscale.enable = true;
}
