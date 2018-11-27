# TODO trace down home-persistent references.
let
  # TODO pin/flakify external deps
  pkgs = import <nixpkgs> {};
  desktop-tools = import /home-persistent/shlevy/src/shlevy-desktop-tools pkgs;

  exwm = (pkgs.callPackage ./exwm.nix {}).compose {
    requires = {};
    provides = {};
  };

  notmuch = (pkgs.callPackage ./notmuch {}).compose {
    requires = {};
    provides = {};
  };

  znc = (import ./znc.nix).compose {
    requires = {};
    provides = {};
  };

  git = (pkgs.callPackage ./git {}).compose {
    requires = {};
    provides = {};
  };

  nix = (pkgs.callPackage ./nix.nix {}).compose {
    requires = {};
    provides = {};
  };

  fci = (import ./fci.nix).compose {
    requires = {};
    provides = {};
  };

  emacs = (pkgs.callPackage ./emacs.nix {}).compose {
    requires = {};
    provides.emacs-packages = epkgs: [
      (exwm.requires.emacs-package epkgs)
      (notmuch.requires.emacs-package epkgs)
      (znc.requires.emacs-package epkgs)
      (git.requires.emacs-package epkgs)
      (nix.requires.emacs-package epkgs)
      (fci.requires.emacs-package epkgs)
    ];
    provides.emacs-config = builtins.concatStringsSep "\n" [
      exwm.requires.emacs-config
      notmuch.requires.emacs-config
      znc.requires.emacs-config
      git.requires.emacs-config
      nix.requires.emacs-config
      fci.requires.emacs-config
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
	    git.requires.package notmuch.requires.package
	    desktop-tools.move-mail desktop-tools.mail-loop
	    pkgs.wire-desktop nix.requires.package
          ];
        }).requires.env.PATH;
      };
      oneshots = [
        exwm.requires.oneshot
	"xrdb -merge $HOME/config/Xresources"
	"xrandr --output eDP1 --fbmm 292x165"
      ];
      # TODO switch to i3
      wmcmd = exwm.requires.wmcmd;
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
    ".notmuch-config" = notmuch.requires.links.".notmuch-config";
    ".emacs" = emacs.requires.links.".emacs";
    ".emacs.d" = emacs.requires.links.".emacs.d";
    ".mozilla" = "/home-persistent/shlevy/xdg/config/mozilla";
    ".xsession-errors" = "run/xsession-errors";
    ".Xauthority" = "run/Xauthority";
    ".cache/mozilla" = "/home-persistent/shlevy/xdg/cache/mozilla";
    ".gitconfig" = git.requires.links.".gitconfig";
    run = "/run/user/1000";
    src = "/home-persistent/shlevy/src";
    config = "/home-persistent/shlevy/config";
    ".local/share/nix" = nix.requires.links.".local/share/nix";
    ".msmtp.log" = "run/msmtp.log";
    ".config/Wire" = "/home-persistent/shlevy/xdg/config/Wire";
    ".ssh" = "/home-persistent/shlevy/creds/ssh";
  };
}).provides.run
