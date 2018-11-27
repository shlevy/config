{ nix }:
{
  compose = { requires, provides }: {
    requires.links.".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";

    requires.links.".cache/nix" = "/home-persistent/shlevy/xdg/cache/nix";

    requires.emacs-package = epkgs: epkgs.nix-mode;

    requires.emacs-config = "(setq nix-indent-function 'nix-indent-line)";

    requires.package = nix;
  };
}
