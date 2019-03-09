{ direnv }:
{
  compose = { provides, requires }: {
    requires.package = direnv;

    requires.bashrc = "eval \"$(direnv hook bash)\"";

    requires.links.".config/direnv" = "/home-persistent/shlevy/xdg/config/direnv";

    requires.emacs-package = epkgs: epkgs.direnv;

    requires.emacs-config = "(direnv-mode)";
  };
}
