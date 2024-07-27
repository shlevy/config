{ config, pkgs, ... }: {
  services = {
    avahi = {
      enable = true;
      inherit (config.networking) hostName;
      nssmdns4 = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
  };
}
