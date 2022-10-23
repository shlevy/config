{ pkgs, ... }: let
  headers = pkgs.buildEnv {
    name = "development-headers";
    paths = with pkgs; [
      stduuid
      nlohmann_json
      btrfs-progs
      crc32c
      libsodium.dev
      secp256k1
      systemd.dev
    ];
    pathsToLink = [ "/include" "/lib" ];
  };

  ghc = pkgs.haskell.packages.ghc924.ghcWithPackages (p: with p; [
    zlib
    digest
    temporary
    postgresql-libpq
    secp256k1-haskell
  ]);
in {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [
      gcc
      cmake
      ghc
      pkg-config
    ];

    home.extraOutputsToInstall = [ "dev" ];
  };

  environment.variables.C_INCLUDE_PATH = "${headers}/include";
  environment.variables.CPLUS_INCLUDE_PATH = "${headers}/include";
  environment.variables.PKG_CONFIG_PATH = "${headers}/lib/pkgconfig";
}
