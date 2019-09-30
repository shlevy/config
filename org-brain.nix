{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-brain;
    requires.emacs-config = ''
      (customize-set-variable 'org-brain-path "~/documents")
      (require 'org-brain)
    '';
  };
}
