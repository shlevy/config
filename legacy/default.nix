# TODO trace down home-persistent references.
let
  # TODO pin/flakify external deps
  pkgs = import <nixpkgs> {
    config.allowUnfree = true;
  };

  desktop-tools = import /home-persistent/shlevy/src/shlevy-desktop-tools pkgs;

  exwm = (pkgs.callPackage ./exwm.nix {}).compose {
    requires = {};
    provides = {};
  };

  notmuch = (pkgs.callPackage ./notmuch {}).compose {
    requires = {};
    provides = {};
  };

  cask = (pkgs.callPackage ./cask.nix {}).compose {
    requires = {};
    provides = {};
  };

  ledger = (pkgs.callPackage ./ledger.nix {}).compose {
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

  org = (import ./org.nix).compose {
    requires = {};
    provides = {};
  };

  intentionel = (import ./intentionel.nix).compose {
    requires = {};
    provides = {};
  };

  org-roam = (pkgs.callPackage ./org-roam.nix {}).compose {
    requires = {};
    provides = {};
  };

  org-transclusion = (pkgs.callPackage ./org-transclusion.nix {}).compose {
    requires = {};
    provides = {};
  };

  cue-mode = (pkgs.callPackage ./cue-mode.nix {}).compose {
    requires = {};
    provides = {};
  };

  coq = (pkgs.callPackage ./coq.nix { coq = pkgs.coq_8_11; }).compose {
    requires = {};
    provides = {};
  };

  agda = (pkgs.callPackage ./agda.nix {}).compose {
    requires = {};
    provides = {};
  };

  emacs = (pkgs.callPackage ./emacs.nix {}).compose {
    requires = {};
    provides.emacs-packages = epkgs: [
      (exwm.requires.emacs-package epkgs)
      (notmuch.requires.emacs-package epkgs)
      (cask.requires.emacs-package epkgs)
      (git.requires.emacs-package epkgs)
      (nix.requires.emacs-package epkgs)
      (fci.requires.emacs-package epkgs)
      (ledger.requires.emacs-package epkgs)
      (direnv.requires.emacs-package epkgs)
      (company.requires.emacs-package epkgs)
      (org-roam.requires.emacs-package epkgs)
      (org-transclusion.requires.emacs-package epkgs)
      (cue-mode.requires.emacs-package epkgs)
      (intentionel.requires.emacs-package epkgs)
      (agda.requires.emacs-package epkgs)
      epkgs.graphviz-dot-mode epkgs.bnfc epkgs.purescript-mode
      epkgs.go-mode epkgs.yaml-mode
    ] ++ (haskell.requires.emacs-packages epkgs)
      ++ (rust.requires.emacs-packages epkgs)
      ++ (flycheck.requires.emacs-packages epkgs)
      ++ (coq.requires.emacs-packages epkgs)
      ++ (org.requires.emacs-packages epkgs);
    provides.emacs-config = builtins.concatStringsSep "\n" [
      exwm.requires.emacs-config
      notmuch.requires.emacs-config
      cask.requires.emacs-config
      git.requires.emacs-config
      nix.requires.emacs-config
      fci.requires.emacs-config
      direnv.requires.emacs-config
      flycheck.requires.emacs-config
      haskell.requires.emacs-config
      rust.requires.emacs-config
      company.requires.emacs-config
      org-roam.requires.emacs-config
      org-transclusion.requires.emacs-config
      org.requires.emacs-config
      agda.requires.emacs-config
      coq.requires.emacs-config
    ];
  };

  env = (pkgs.callPackage ./env.nix {}).compose {
    requires = {};
    provides.packages = [
      emacs.requires.package
      pkgs.isync pkgs.msmtp pkgs.haskellPackages.BNFC pkgs.bison pkgs.flex pkgs.binutils
      notmuch.requires.package desktop-tools.move-mail desktop-tools.mail-loop
      pkgs.wire-desktop pkgs.signal-desktop nix.requires.package ledger.requires.package
      coq.requires.package pkgs.gnumake pkgs.texlive.combined.scheme-full
      direnv.requires.package
      vlc.requires.package pkgs.pavucontrol gimp.requires.package
      spotify.requires.package cask.requires.package
      pkgs.yubikey-manager-qt pkgs.qemu_kvm pkgs.poppler_utils
      pkgs.libreoffice pkgs.zoom-us pkgs.discord pkgs.man-pages pkgs.posix_man_pages
      pkgs.stdmanpages pkgs.graphviz pkgs.hugo # pkgs.calibre
      pkgs.lm_sensors pkgs.dmidecode pkgs.pciutils pkgs.usbutils pkgs.parted
      pkgs.inkscape pkgs.zulip agda.requires.package
      pkgs.xfce.thunar pkgs.unzip pkgs.jq pkgs.evince pkgs.webcamoid
      pkgs.chromium pkgs.scrot pkgs.magic-wormhole pkgs.element-desktop pkgs.tty-share
      # FIXME add back in LD_LIBRARY_PATH for openbci
      pkgs.file pkgs.jre pkgs.xorg.libXxf86vm pkgs.pre-commit pkgs.hunspell
      pkgs.nix-prefetch-git pkgs.ledger-autosync
    ] ++ haskell.requires.packages ++ rust.requires.packages ++ org-roam.requires.packages
      ++ git.requires.packages;
  };

  xsession = ((pkgs.callPackage ./xsession.nix {}).compose {
    requires = {};
    provides = {
      env = {
        HISTFILE = "/home-persistent/shlevy/bash_history";
        "_JAVA_AWT_WM_NONREPARENTING" = "1";
        EDITOR = "emacsclient";
        LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";
        DICPATH = "${pkgs.hunspellDicts.en-us}/share/hunspell";
        LEDGER_FILE = "/home/shlevy/documents/financial/ledger";
      };
      oneshots = [
        exwm.requires.oneshot
        "xrdb -merge $HOME/config/Xresources"
      ];
      # TODO switch to i3
      wmcmd = exwm.requires.wmcmd;
    };
  }).requires.links.".xsession";

  systemd-user = (pkgs.callPackage ./systemd-user.nix {}).compose {
    requires = {};
    provides.systemd-user-overrides = {
      "pulseaudio.service" = pulseaudio.requires.systemd-user-overrides."pulseaudio.service";
    };
  };

  pulseaudio = (import ./pulseaudio.nix).compose {
    requires = {};
    provides = {};
  };

  direnv = (pkgs.callPackage ./direnv.nix {}).compose {
    requires = {};
    provides = {};
  };

  bashrc = (pkgs.callPackage ./bashrc.nix {}).compose {
    requires = {};
    provides.bashrc = builtins.concatStringsSep "\n" [
      direnv.requires.bashrc
    ];
  };

  flycheck = (import ./flycheck.nix).compose {
    requires = {};
    provides = {};
  };

  rust = (pkgs.callPackage ./rust.nix { inherit (pkgs.rustPlatform) rustcSrc; }).compose {
    requires = {};
    provides = {};
  };

  haskell = (pkgs.callPackage ./haskell.nix {}).compose {
    requires = {};
    provides = {};
  };

  vlc = (pkgs.callPackage ./vlc.nix {}).compose {
    requires = {};
    provides = {};
  };

  gimp = (pkgs.callPackage ./gimp.nix {}).compose {
    requires = {};
    provides = {};
  };

  spotify = (pkgs.callPackage ./spotify.nix {}).compose {
    requires = {};
    provides = {};
  };

  company = (import ./company.nix).compose {
    requires = {};
    provides = {};
  };
in ((pkgs.callPackage ./profile.nix {}).compose {
  requires = {};
  provides.name = "shlevy-home";
  provides.env = env.requires.env;
  provides.links = {
    creds = "/home-persistent/shlevy/creds";
    ".xsession" = xsession;
    ".mbsyncrc" = ./dotfiles/mbsyncrc;
    ".msmtprc" = ./dotfiles/msmtprc;
    ".notmuch-config" = notmuch.requires.links.".notmuch-config";
    ".emacs" = emacs.requires.links.".emacs";
    ".emacs.d" = emacs.requires.links.".emacs.d";
    ".mozilla" = "/home-persistent/shlevy/xdg/config/mozilla";
    ".cache/mozilla" = "/home-persistent/shlevy/xdg/cache/mozilla";
    ".gitconfig" = git.requires.links.".gitconfig";
    run = "/run/user/1000";
    src = "/home-persistent/shlevy/src";
    documents = "/home-persistent/shlevy/documents";
    config = "/home-persistent/shlevy/config";
    ".local/share/nix" = nix.requires.links.".local/share/nix";
    ".cache/nix" = nix.requires.links.".cache/nix";
    ".cache/nix-fetchers" = nix.requires.links.".cache/nix-fetchers";
    ".config/nix/nix.conf" = nix.requires.links.".config/nix/nix.conf";
    ".msmtp.log" = "run/msmtp.log";
    ".config/Wire" = "/home-persistent/shlevy/xdg/config/Wire";
    ".config/Signal" = "/home-persistent/shlevy/xdg/config/Signal";
    ".local/share/direnv" = direnv.requires.links.".local/share/direnv";
    ".ssh" = "/home-persistent/shlevy/creds/ssh";
    ".config/systemd/user" = systemd-user.requires.links.".config/systemd/user";
    ".config/pulse" = pulseaudio.requires.links.".config/pulse";
    ".config/vlc" = vlc.requires.links.".config/vlc";
    ".config/GIMP" = gimp.requires.links.".config/GIMP";
    ".config/spotify" = spotify.requires.links.".config/spotify";
    ".cache/spotify" = spotify.requires.links.".cache/spotify";
    ".cache/mesa_shader_cache" = spotify.requires.links.".cache/mesa_shader_cache";
    ".bashrc" = bashrc.requires.links.".bashrc";
    ".cabal" = haskell.requires.links.".cabal";
    ".cargo" = rust.requires.links.".cargo";
  };
}).provides.run
