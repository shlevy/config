{
  home-manager.users.shlevy = { pkgs, ... }: {
    home.packages = [ pkgs.texlive.combined.scheme-full ];
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.org-bullets ];

      extraConfig = ''
        (require 'org-bullets)
        (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

        (define-key global-map "\C-cl" 'org-store-link)
        (define-key global-map "\C-ca" 'org-agenda)

        (with-eval-after-load 'org
          (define-key org-mode-map (kbd "C-c ,") #'org-time-stamp-inactive))

        (setq org-agenda-custom-commands '(
          ("n" "Agenda and active TODOs" (
            (todo "TODO" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            (agenda "")
          ))
        ))
        (add-hook 'org-agenda-mode-hook (lambda () (visual-line-mode -1) (setq truncate-lines 1)))
      '';

      extraCustomize = ''
        (customize-set-variable 'org-agenda-files '("~/Documents/roam/main/2023_anniversary.org" "~/Documents/roam/main/lru_project_system.org" "~/Documents/roam/main/nomia.org" "~/Documents/roam/main/parenting_articulation.org" "~/Documents/roam/main/objective_articulation_of_philosophy_incarnation.org" "~/Documents/roam/main/trademark_as_a_property_right.org" "~/Documents/roam/main/philosophy_incarnation_as_primary_claimant.org" "~/Documents/roam/main/philosophy_incarnation.org" "~/Documents/roam/main/paid_philosophy_incarnation.org" "~/Documents/roam/main/inbox_processing_equilibrium.org"
"~/Documents/roam/main/queryable_finances.org" "~/Documents/roam/main/objectivism_seminar_y2q4_capitalism_and_aesthetics.org" "~/Documents/roam/main/introduction_to_writing.org" "~/Documents/roam/main/itoe-course.org" "~/Documents/roam/main/project_musical_chairs.org" "~/Documents/roam/main/unintegrated_iog_projects.org" "~/Documents/roam/project" "~/Documents/roam/main/tickler.org" "~/Documents/roam/main/household_maintenance.org" "~/Documents/roam/main/administrivia.org" "~/Documents/roam/project/to-clean/income-yielding-portfolio" "~/Documents/roam/project/to-clean/income-yielding-portfolio/nomia-minimum-viable-incarnation" "~/Documents/roam/project/to-clean/income-yielding-portfolio/initial-prospectuses" "~/Documents/roam/project/to-clean/energy-maximization" "~/Documents/roam/project/to-clean/philosophically-objective-parenting-perfection" "~/Documents/roam/project/to-clean/philosophically-objective-parenting-perfection/elementary-education-secured" "~/Documents/roam/project/to-clean/IOG" "~/Documents/roam/project/to-clean/ARU" "~/Documents/roam/project/to-clean" "~/Documents/roam/project/to-clean/older"))
        (customize-set-variable 'org-log-into-drawer t)
        (customize-set-variable 'org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM %CLOCKSUM_T")
      '';
    };
  };
}
