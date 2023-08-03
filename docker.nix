{ pkgsUnstable, ... }: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  home-manager.users.shlevy.home.packages = [ pkgsUnstable.docker_24 ];
}
