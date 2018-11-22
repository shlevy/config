{ emacsWithPackages, writeText }:
{
  compose = { provides, requires }: let
    emacs = emacsWithPackages provides.emacs-packages;
  in {
    requires.package = emacs;
    requires.links.".emacs" = writeText "emacs" provides.emacs-config;
    requires.links.".emacs.d" = "/home-persistent/shlevy/xdg/config/emacs";
  };
}
