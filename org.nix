let
  org-agenda-files = [
    "~/documents/org-roam/20220317095220-conscient_task_clarification_2022_03_16_2022_03_17.org"
    "~/documents/org-roam/20220319110207-arsps_concepts_wrap_up.org"
    "~/documents/org-roam/20220331064637-year_1_objectivism_seminar_q3_work.org"
    "~/documents/org-roam/20220309061101-19th_century_philosophy_of_science.org"
    "~/documents/org-roam/20220217071101-spring_2022_season_preparation.org"
    "~/documents/org-roam/20220217063909-plutus_certification_mvp.org"
    "~/documents/org-roam/20220307094455-eventuo11y_0_1_0_0.org"
    "~/documents/org-roam/20220223064109-physicalism_elaboration.org"
    "~/documents/org-roam/agenda.org"
    "~/documents/org-roam-old/agenda.org"
    "~/documents/org-roam/20220107053812-conscient_vision_thought_work.org"
    "~/documents/org-roam/20220107113029-higher_ground_in_nh.org"
    "~/documents/org-roam/20220107060247-year_1_objectivism_seminar_q2_work.org"
    "~/documents/org-roam/20220112053843-conscient_relationships_winter_2022.org"
    "~/documents/org-roam/20220110055111-winter_2022_season_preparation.org"
    "~/documents/org-roam/20210919092057-characterizing_stepping_back.org"
    "~/documents/org-roam/20220107055558-oac_q1_wrap.org"
    "~/documents/org-roam/20210914171054-ocon_2022.org"
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
