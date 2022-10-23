{
  home-manager.users.shlevy = {
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.org-pomodoro ];

      extraConfig = ''
        (with-eval-after-load 'org-agenda
          (org-defkey org-agenda-mode-map "P" #'org-pomodoro))
      '';

      extraCustomize = ''
        (customize-set-variable 'org-pomodoro-ticking-sound-p t)
        (customize-set-variable 'org-pomodoro-length 55)
      '';
    };
  };
}
