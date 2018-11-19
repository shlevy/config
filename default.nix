let
  pkgs = import <nixpkgs> {}; # TODO pin
  desktop-tools = import /home-persistent/shlevy/src/shlevy-desktop-tools pkgs;
  emacs = pkgs.emacsWithPackages (epkgs: [ epkgs.exwm epkgs.notmuch epkgs.znc epkgs.magit ]);
  xsession = pkgs.substituteAll {
    src = ./xsession;
    isExecutable = true;
    inherit (pkgs) bash firefox pass gnupg isync msmtp git;
    inherit (pkgs.emacsPackages) notmuch;
    inherit (pkgs.xorg) xhost;
    movemail = desktop-tools.move-mail;
    mailloop = desktop-tools.mail-loop;
    inherit emacs;
  };
in ((pkgs.callPackage ./symlink-tree.nix {}).compose {
  requires = {};
  provides.name = "shlevy-home";
  provides.links = {
    creds = "/home-persistent/shlevy/creds";
    ".xsession" = xsession;
    ".mbsyncrc" = ./dotfiles/mbsyncrc;
    ".msmtprc" = ./dotfiles/msmtprc;
    ".notmuch-config" = ./dotfiles/notmuch-config;
    ".emacs" = ./dotfiles/emacs;
    ".mozilla" = "/home-persistent/shlevy/xdg/config/mozilla";
    ".xsession-errors" = "run/xsession-errors";
    ".Xauthority" = "run/Xauthority";
    ".cache/mozilla" = "/home-persistent/shlevy/xdg/cache/mozilla";
    ".gitconfig" = ./dotfiles/gitconfig;
    run = "/run/user/1000";
    src = "/home-persistent/shlevy/src";
    config = "/home-persistent/shlevy/config";
    ".local/share/nix" = "/home-persistent/shlevy/xdg/share/nix";
  };
}).provides.run
