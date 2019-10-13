{ cask }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.flycheck-cask;

    requires.package = cask;

    requires.emacs-config = ''
      (eval-after-load 'flycheck
        '(add-hook 'flycheck-mode-hook #'flycheck-cask-setup))
    '';
  };
}
