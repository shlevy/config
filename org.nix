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

        (setq org-agenda-custom-commands '(
          ("n" "Agenda and active TODOs" (
            (agenda "")
            (todo "TODO" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
          ))
          ("d" "Scheduiled today" (
            (agenda "" ((org-agenda-span 'day) (org-agenda-entry-types '(:scheduled))))
          ))
        ))
        (add-hook 'org-agenda-mode-hook (lambda () (visual-line-mode -1) (setq truncate-lines 1)))
      '';

      extraCustomize = ''
        (customize-set-variable 'org-agenda-files '("~/Documents/roam/systems" "~/Documents/roam/project/income-yielding-portfolio" "~/Documents/roam/project/income-yielding-portfolio/nomia-minimum-viable-incarnation" "~/Documents/roam/project/income-yielding-portfolio/initial-prospectuses" "~/Documents/roam/project/energy-maximization" "~/Documents/roam/project/philosophically-objective-parenting-perfection" "~/Documents/roam/project/philosophically-objective-parenting-perfection/elementary-education-secured" "~/Documents/roam/project/IOG" "~/Documents/roam/project/ARU" "~/Documents/roam/project" "~/Documents/roam/project/to-clean"))
        (customize-set-variable 'org-log-into-drawer t)
        (customize-set-variable 'org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM %CLOCKSUM_T")
      '';
    };
  };
}
