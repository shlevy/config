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
        (customize-set-variable 'org-pomodoro-length 30)
        (customize-set-variable 'org-pomodoro-short-break-length 3)
        (customize-set-variable 'org-pomodoro-long-break-length 10)
        (customize-set-variable 'org-pomodoro-ticking-sound-states '(:pomodoro))
        (customize-set-variable 'org-pomodoro-start-sound "~/Music/reception-bell.wav")
        (customize-set-variable 'org-pomodoro-finished-sound "~/Music/reception-bell.wav")
        (customize-set-variable 'org-pomodoro-overtime-sound "~/Music/reception-bell.wav")
        (customize-set-variable 'org-pomodoro-short-break-sound "~/Music/reception-bell.wav")
        (customize-set-variable 'org-pomodoro-long-break-sound "~/Music/reception-bell.wav")
      '';
    };
  };
}
