{
  compose = { requires, provides }: {
    requires.emacs-packages = epkgs: [ epkgs.flycheck epkgs.flycheck-inline ];

    requires.emacs-config = ''
      (require 'flycheck)
      (require 'flycheck-inline)
      (customize-set-variable 'flycheck-global-modes '(not org-mode))
      (global-flycheck-mode)
      (global-flycheck-inline-mode)
    '';
  };
}
