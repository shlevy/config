{
  compose = { requires, provides }: {
    requires.emacs-packages = epkgs: [ epkgs.flycheck epkgs.flycheck-inline ];

    requires.emacs-config = ''
      (require 'flycheck)
      (require 'flycheck-inline)
      (global-flycheck-mode)
      (global-flycheck-inline-mode)
    '';
  };
}
