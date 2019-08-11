{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-plus-contrib;

    requires.emacs-config = ''
      (setq org-agenda-files '("~/documents/agenda.org"))
      (setq org-enforce-todo-dependencies t)
    '';
  };
}
