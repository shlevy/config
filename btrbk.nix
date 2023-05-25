{ config, ... }: {
  services.btrbk.instances.btrbk.settings = {
    snapshot_preserve_min = "2d";
    snapshot_preserve = "14d";
    target_preserve_min = "no";
    target_preserve = "20d 10w *m";
    snapshot_dir = "btrbk_snapshots";
    volume."/mnt/btr_pool" = {
      target = "/run/media/shlevy/home-backup/${config.systemSpecific.machineName}";
      subvolume.home = {};
      subvolume."home/shlevy/creds" = {};
      subvolume.root = {};
      subvolume.rootfs = {};
      subvolume.etc = {};
    };
  };

  fileSystems."/mnt/btr_pool" = {
    fsType = "btrfs";
    label = "NixOS";
    options = [ "defaults" "noatime" "compress=zstd" ];
  };
}
