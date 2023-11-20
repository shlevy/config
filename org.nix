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

        (defun shlevy-long-agenda-lines ()
          (visual-line-mode -1)
          (setq truncate-lines 1))
        (add-hook 'org-agenda-mode-hook 'shlevy-long-agenda-lines)
      '';

      extraCustomize = ''
        (customize-set-variable 'org-log-into-drawer t)
        (customize-set-variable 'org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM %CLOCKSUM_T")
      '';
    };
  };
}
