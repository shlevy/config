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
in {
  home-manager.users.shlevy = {
    # Temporary pending nix-buffer
    home.packages = with pkgs; [
      gcc
      cmake
    ];

    home.extraOutputsToInstall = [ "dev" ];

    programs.emacs = {
      extraPackages = epkgs: with epkgs; [
        flycheck
      ];

      extraConfig = ''
        (global-flycheck-mode)
      '';
    };
  };

  environment.variables.C_INCLUDE_PATH = "${headers}/include";
  environment.variables.CPLUS_INCLUDE_PATH = "${headers}/include";
}
