{
  compose = { requires, provides }: {
    requires.emacs-package = epkgs: epkgs.flycheck;

    requires.emacs-config = ''
      (require 'flycheck)
      (global-flycheck-mode)
    '';
  };
}
