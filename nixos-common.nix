{ config, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware.nix
    ./home-manager.nix
    ./localization.nix
    ./remote.nix
    ./X.nix
    ./printing.nix

    ./bash.nix
    ./emacs.nix
    ./git.nix
    ./man.nix

    ./org-roam.nix
    ./org.nix
    ./priodyn.nix
    ./citations.nix

    ./agda.nix
    ./nix.nix
    ./haskell.nix
    ./rust.nix
    ./development.nix
  ];

  config = {
    home-manager.users.${config.users.me} = {
      home.packages = with pkgs; [
        zoom-us
        jq
        firefox
        slack
        file
        pdftk
        unzip
        magic-wormhole
        biscuit-cli
        libreoffice
        ncdu
      ];

      programs.command-not-found.enable = true;
    };

    environment.variables.MOZ_ENABLE_WAYLAND = "1";
  };
}
