{ direnv }:
{
  compose = { provides, requires }: {
    requires.package = direnv;

    requires.bashrc = "eval \"$(direnv hook bash)\"";

    requires.links.".local/share/direnv" = "/home-persistent/shlevy/xdg/share/direnv";

    requires.emacs-package = epkgs: epkgs.direnv;

    requires.emacs-config = "(add-hook 'after-init-hook 'direnv-mode)";
  };
}
