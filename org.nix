{
  compose = { provides, requires }: {
    requires.emacs-packages = epkgs: [ epkgs.org-plus-contrib epkgs.org-bullets ];

    requires.emacs-config = ''
      (setq org-agenda-files '("~/documents/org-roam/agenda.org" "~/documents/org-roam-old/agenda.org" "~/documents/intentions" "~/documents/todo.org" "~/documents/domains" "~/documents/watermarks"))
      (setq org-todo-keywords
        '((sequence "BACKLOG(b@)" "TODO(t!)" "IN PROGRESS(p)" "|" "DONE(d!)")))
      (setq org-enforce-todo-dependencies t)
      (setq org-log-into-drawer t)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (setq org-agenda-custom-commands '(("n" "Agenda and active TODOs" ((agenda "") (todo "TODO|IN PROGRESS")))))

      (require 'org-bullets)
      (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    '';
  };
}
