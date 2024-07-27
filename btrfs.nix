{ lib, config, ... }: {
  boot.initrd.availableKernelModules = [ "btrfs" ];

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
    "/mnt/btr_pool" = {
      fsType = "btrfs";
      label = "NixOS";
      options = [ "defaults" "noatime" "compress=zstd" ];
    };
  };

  services.btrbk.instances.btrbk.settings = {
    snapshot_preserve_min = "2d";
    snapshot_preserve = "14d";
    target_preserve_min = "no";
    target_preserve = "20d 10w *m";
    snapshot_dir = "btrbk_snapshots";
    volume."/mnt/btr_pool" = {
      target = "/run/media/shlevy/home-backup/${config.networking.hostName}";
      subvolume.home = {};
      subvolume."home/shlevy/creds" = {};
      subvolume.root = {};
      subvolume.rootfs = {};
      subvolume.etc = {};
    };
  };
}
