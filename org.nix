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

        (setq org-agenda-custom-commands '(("n" "Agenda and active TODOs" ((agenda "") (todo "TODO" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))))))
      '';

      extraCustomize = ''
        (customize-set-variable 'org-agenda-files '("~/Documents/roam/planning"))
        (customize-set-variable 'org-log-into-drawer t)
      '';
    };
  };
}
