{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-plus-contrib;

    requires.emacs-config = ''
      (setq org-agenda-files '("~/documents/intentions"))
      (setq org-todo-keywords
        '((sequence "BACKLOG(b@)" "TODO(t!)" "IN PROGRESS(p)" "|" "DONE(d!)")))
      (setq org-enforce-todo-dependencies t)
      (setq org-log-into-drawer t)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (setq org-agenda-custom-commands '(("n" "Agenda and active TODOs" ((agenda "") (todo "TODO|IN PROGRESS")))))
    '';
  };
}
