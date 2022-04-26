{ nix, fetchFromGitHub, callPackage, writeText, nix-plugins }: let
  nix-mode-src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-mode";
    rev = "80a1e96c7133925797a748cf9bc097ca6483baeb";
    sha256 = "165g8ga1yhibhabh6n689hdk525j00xw73qnsdc98pqzsc2d2ipa";
  };
in {
  compose = { requires, provides }: {
    requires.links.".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";

    requires.links.".cache/nix" = "/home-persistent/shlevy/xdg/cache/nix";

    requires.links.".cache/nix-fetchers" = "/home-persistent/shlevy/xdg/cache/nix-fetchers";

    requires.links.".config/nix/nix.conf" = builtins.toFile "nix.conf" ''
      experimental-features = nix-command flakes
    '';

    requires.emacs-package = epkgs: epkgs.nix-mode.overrideAttrs (_: {
      src = nix-mode-src;
    });

    requires.emacs-config = "(setq nix-indent-function 'nix-indent-line)";

    requires.package = nix;
  };
}
