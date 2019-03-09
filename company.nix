{
  compose = { requires, provides }: {
    requires.emacs-package = epkgs: epkgs.company;

    requires.emacs-config =
      "(add-hook 'after-init-hook 'global-company-mode)";
  };
}
