let
  # TODO pin/flakify external deps
  pkgs = import <nixpkgs> {};
  desktop-tools = import /home-persistent/shlevy/src/shlevy-desktop-tools pkgs;

  emacs = (pkgs.callPackage ./emacs {}).compose {
    requires = {};
    provides.emacs-packages = epkgs: [
      epkgs.exwm
      epkgs.notmuch
      epkgs.znc
      epkgs.magit
    ];
  };
  xsession = ((pkgs.callPackage ./xsession.nix {}).compose {
    requires = {};
    provides = {
      env = {
        PASSWORD_STORE_DIR = "/home-persistent/shlevy/creds/password-store/";
	GNUPGHOME = "/home-persistent/shlevy/creds/gnupg";
	GDK_SCALE = "0.8";
	GDK_DPI_SCALE = "0.8";
	PATH = ((import ./path-programs.nix).compose {
          requires = {};
          provides.packages = [
	    emacs.requires.package pkgs.firefox pkgs.pass
	    pkgs.gnupg pkgs.isync pkgs.msmtp
	    pkgs.git pkgs.emacsPackages.notmuch /* TODO notmuch duplication?? */
	    desktop-tools.move-mail desktop-tools.mail-loop
	    pkgs.wire-desktop
          ];
        }).requires.env.PATH;
      };
      oneshots = [
	"${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER"
	"xrdb -merge $HOME/config/Xresources"
	"xrandr --output eDP1 --fbmm 292x165"
      ];
      # TODO switch to i3
      wmcmd = "emacs";
    };
  }).requires.links.".xsession";
in ((pkgs.callPackage ./symlink-tree.nix {}).compose {
  requires = {};
  provides.name = "shlevy-home";
  provides.links = {
    creds = "/home-persistent/shlevy/creds";
    ".xsession" = xsession;
    ".mbsyncrc" = ./dotfiles/mbsyncrc;
    ".msmtprc" = ./dotfiles/msmtprc;
    ".notmuch-config" = ./dotfiles/notmuch-config;
    ".emacs" = emacs.requires.links.".emacs";
    ".mozilla" = "/home-persistent/shlevy/xdg/config/mozilla";
    ".xsession-errors" = "run/xsession-errors";
    ".Xauthority" = "run/Xauthority";
    ".cache/mozilla" = "/home-persistent/shlevy/xdg/cache/mozilla";
    ".gitconfig" = ./dotfiles/gitconfig;
    run = "/run/user/1000";
    src = "/home-persistent/shlevy/src";
    config = "/home-persistent/shlevy/config";
    ".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";
    ".msmtp.log" = "run/msmtp.log";
    ".config/Wire" = "/home-persistent/shlevy/xdg/config/Wire";
  };
}).provides.run
