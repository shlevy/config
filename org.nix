{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-plus-contrib;
  };
}
