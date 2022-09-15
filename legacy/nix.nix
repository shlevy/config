{ nix, callPackage, writeText, nix-plugins }: {
  compose = { requires, provides }: {
    requires.links.".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";

    requires.links.".cache/nix" = "/home-persistent/shlevy/xdg/cache/nix";

    requires.links.".cache/nix-fetchers" = "/home-persistent/shlevy/xdg/cache/nix-fetchers";

    requires.links.".config/nix/nix.conf" = builtins.toFile "nix.conf" ''
      experimental-features = nix-command flakes
    '';

    requires.emacs-package = epkgs: epkgs.nix-mode;

    requires.emacs-config = "(setq nix-indent-function 'nix-indent-line)";

    requires.package = nix;
  };
}
