{ pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [
      gcc
      cmake
      haskell.packages.ghc910.ghc
      pkg-config
    ];

    home.extraOutputsToInstall = [ "dev" ];
  };
}
