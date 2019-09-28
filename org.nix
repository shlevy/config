{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-plus-contrib;

    requires.emacs-config = ''
      (setq org-agenda-files '("~/documents/agenda.org" "~/documents/intention-tracking.org" "~/documents/financial/receipts-processing.org" "~/documents/currently-reading.org"))
      (setq org-enforce-todo-dependencies t)
    '';
  };
}
