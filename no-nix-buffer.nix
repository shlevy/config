{ pkgs, ... }: let
  headers = pkgs.buildEnv {
    name = "development-headers";
    paths = with pkgs; [
      stduuid
      nlohmann_json
      btrfs-progs
      crc32c
    ];
    pathsToLink = [ "/include" ];
  };

  ghc = pkgs.haskellPackages.ghcWithPackages (p: with p; [
    base
    aeson
    async
    binary
    bytestring
    case-insensitive
    containers
    exceptions
    http-types
    monad-control
    mtl
    network
    resourcet
    semigroupoids
    servant-client
    text
    time
    transformers-base
    uuid
    http-media
    wai
    warp
  ]);
in {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [
      gcc
      cmake
      ghc
    ];

    home.extraOutputsToInstall = [ "dev" ];
  };

  environment.variables.C_INCLUDE_PATH = "${headers}/include";
  environment.variables.CPLUS_INCLUDE_PATH = "${headers}/include";
}
