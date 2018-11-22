{ xhost }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.exwm;

    requires.emacs-config = ''
      (require 'exwm)
      (require 'exwm-config)
      (exwm-config-default)
    '';

    # TODO namespacing?
    requires.oneshot = "${xhost}/bin/xhost +SI:localuser:$USER";
    requires.wmcmd = "emacs";
  };
}
