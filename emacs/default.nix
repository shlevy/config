{ emacsWithPackages }:
{
  compose = { provides, requires }: let
    emacs = emacsWithPackages provides.emacs-packages;
  in {
    requires.package = emacs;
    # TODO break up
    requires.links.".emacs" = ./emacs;
  };
}
