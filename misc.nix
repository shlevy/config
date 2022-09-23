{ pkgs, ... }: {
  home-manager.users.shlevy.home.packages = with pkgs; [
    discord
    zoom-us
    jq
    firefox
    slack
  ];

  environment.variables.MOZ_ENABLE_WAYLAND = "1";
}
