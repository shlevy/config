let
  org-agenda-files = [
    "~/documents/org-roam/20220816064337-anniversary_2022.org"
    "~/documents/org-roam/20220816063511-year_1_objectivism_seminar_q4_work.org"
    "~/documents/org-roam/20220816062805-financial_planning.org"
    "~/documents/org-roam/20220816065933-conscient_guitar_study.org"
    "~/documents/org-roam/20220816070820-parenting_philosophy.org"
    "~/documents/org-roam/20220816065157-2022_austin_trip.org"
    "~/documents/org-roam/20220824182251-conscient_colleagues.org"
    "~/documents/org-roam/20220828114951-jasper_birth_preparation.org"
    "~/documents/org-roam/20220828114832-estate_planning.org"
    "~/documents/org-roam/agenda.org"
    "~/documents/org-roam/20220905121446-certification_progress_tracking.org"
    "~/documents/org-roam/20220822095740-marlowe_flake_migration.org"
    "~/documents/org-roam/20220818064242-marlowe_runtime_observability.org"
    "~/documents/org-roam/20220307094455-eventuo11y_0_1_0_0.org"
    "~/documents/org-roam/20220818070449-nomia_used_by_iog.org"
    "~/documents/org-roam/20220818063729-certification_handoff.org"
  ];
in rec {
  agenda-line = "(setq org-agenda-files '(${builtins.concatStringsSep " " (map (f: "\"${f}\"") org-agenda-files)}))";

  compose = { provides, requires }: {
    requires.emacs-packages = epkgs: [ epkgs.org epkgs.org-contrib epkgs.org-bullets ];

    requires.emacs-config = ''
      ${agenda-line}
      (setq org-todo-keywords
        '((sequence "BACKLOG(b@)" "TODO(t!)" "IN PROGRESS(p)" "|" "DONE(d!)")))
      (setq org-enforce-todo-dependencies t)
      (setq org-log-into-drawer t)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (setq org-agenda-custom-commands '(("n" "Agenda and active TODOs" ((agenda "") (todo "TODO|IN PROGRESS" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))))))

      (require 'org-bullets)
      (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    '';
  };
}
