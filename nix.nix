{ nix }:
{
  compose = { requires, provides }: {
    requires.links.".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";

    requires.emacs-package = epkgs: epkgs.nix-mode;

    requires.package = nix;
  };
}
