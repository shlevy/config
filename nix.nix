{ nix, fetchFromGitHub, callPackage, writeText, nix-plugins }: let
  nix-mode-src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-mode";
    rev = "80a1e96c7133925797a748cf9bc097ca6483baeb";
    sha256 = "165g8ga1yhibhabh6n689hdk525j00xw73qnsdc98pqzsc2d2ipa";
  };

  nix-fetchers = fetchFromGitHub {
    owner = "target";
    repo = "nix-fetchers";
    rev = "c58604cc871ef5f19efe490c4c06c95bc519ef9b"; # 1.2.2
    sha256 = "0d7acqmzy15251zwa4agw7vwbq86f71dmnizkj31p0cpq43dfx4a";
  };

  make-extra-builtins = callPackage (nix-fetchers + "/make-extra-builtins.nix") {};

  all-fetchers = import (nix-fetchers + "/all-fetchers.nix");

  extra-builtins = make-extra-builtins { fetchers = all-fetchers; };

  config = writeText "nix.conf" ''
    plugin-files = ${nix-plugins.override { inherit nix; }}/lib/nix/plugins
    extra-builtins-file = ${extra-builtins}/extra-builtins.nix
  '';
in {
  compose = { requires, provides }: {
    requires.links.".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";

    requires.links.".cache/nix" = "/home-persistent/shlevy/xdg/cache/nix";

    requires.links.".cache/nix-fetchers" = "/home-persistent/shlevy/xdg/cache/nix-fetchers";

    requires.links.".config/nix/nix.conf" = config;

    requires.emacs-package = epkgs: epkgs.nix-mode.overrideAttrs (_: {
      src = nix-mode-src;
    });

    requires.emacs-config = "(setq nix-indent-function 'nix-indent-line)";

    requires.package = nix;
  };
}
