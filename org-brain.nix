{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-brain;
    requires.emacs-config = ''
      (require 'org-brain)
      (setq org-brain-path "~/documents/brain")
    '';
  };
}
