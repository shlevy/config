{ pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [
      discord
      zoom-us
      jq
      firefox
      slack
    ];

    programs.command-not-found.enable = true;
  };

  environment.variables.MOZ_ENABLE_WAYLAND = "1";
}