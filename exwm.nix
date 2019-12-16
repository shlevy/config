{ xhost }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.exwm;

    requires.emacs-config = ''
      (require 'exwm)
      (require 'exwm-config)
      (require 'exwm-randr)
      (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "DP1" 2 "eDP1" 3 "DP1"))
      (add-hook 'exwm-randr-screen-change-hook
        (lambda ()
          (start-process-shell-command
            "xrandr" nil "xrandr --output eDP1 --primary --auto --output DP1 --right-of eDP1 --auto")))
      (exwm-randr-enable)
      (exwm-config-default)
    '';

    # TODO namespacing?
    requires.oneshot = "${xhost}/bin/xhost +SI:localuser:$USER";
    requires.wmcmd = "emacs";
  };
}
