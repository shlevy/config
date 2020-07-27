{ xhost }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.exwm;

    requires.emacs-config = ''
      (setq ediff-window-setup-function 'ediff-setup-windows-plain) ; default ediff mode conflicts with exwm

      (require 'exwm)
      (require 'exwm-config)
      (require 'exwm-randr)
      ;(setq exwm-randr-workspace-monitor-plist '(0 "eDP-1" 1 "HDMI-2" 2 "eDP-1" 3 "HDMI-2"))
      (setq exwm-randr-workspace-monitor-plist '(0 "eDP-1" 1 "DP-1" 2 "eDP-1" 3 "DP-1"))
      (add-hook 'exwm-randr-screen-change-hook
        (lambda ()
          (start-process-shell-command
            ;"xrandr" nil "xrandr --output eDP-1 --primary --auto --output HDMI-2 --right-of eDP-1 --auto")))
            "xrandr" nil "xrandr --output eDP-1 --primary --auto --output DP-1 --right-of eDP-1 --auto")))
      (exwm-randr-enable)
      (exwm-config-default)

      (display-time-mode)
      (display-battery-mode)
    '';

    # TODO namespacing?
    requires.oneshot = "${xhost}/bin/xhost +SI:localuser:$USER";
    requires.wmcmd = "emacs";
  };
}
