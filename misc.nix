{ pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [
      discord
      zoom-us
      jq
      firefox
      slack
      file
      pdftk
      unzip
      signal-desktop
      element-desktop
      magic-wormhole
      biscuit-cli
      libreoffice
      whatsapp-for-linux
      wineWowPackages.waylandFull
      ncdu
    ];

    programs.command-not-found.enable = true;
  };

  environment.variables.MOZ_ENABLE_WAYLAND = "1";
}
