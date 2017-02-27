let pkgs = import <nixpkgs>
  { config =
      { allowUnfree = true;
        emacsSupport = true;
      };
  };
    desktop-tools = import ../src/shlevy-desktop-tools pkgs;
    setup-home = pkgs.callPackage ./setup-home.nix {}
      { dotfiles = ./dotfiles;
        other-files =
          { src = "/home-persistent/shlevy/src";
            creds = "/home-persistent/shlevy/creds";
            config = "/home-persistent/shlevy/config";
            documents = "/home-persistent/shlevy/documents";
            ".xsession" = "${dwm}/bin/dwm";
            ".ssh" = "/home-persistent/shlevy/creds/ssh";
          };
      };
    st = pkgs.st.override { patches = [ ./st.patch ]; };
    dwm = pkgs.dwm.override { patches = [ ./dwm.patch ]; };
    emacs = pkgs.emacsWithPackages (builtins.attrValues
      { inherit (pkgs.emacsPackages) notmuch;
        inherit (pkgs.emacsPackagesNg) flycheck dash dash-functional f s
          company fill-column-indicator flycheck-package modalka
          org-plus-contrib nix-buffer haskell-mode znc;
      });
    ghc = pkgs.haskellPackages.ghcWithPackages (s:
      [ s.cabal-install s.cabal2nix ]);
    coq = pkgs.coq_8_6;
    linux-config-env = pkgs.buildFHSUserEnv
      {  name = "linux-config";
         targetPkgs = p: [ p.gcc p.gnumake p.ncurses p.ncurses.dev p.bashCompletion p.qt5.full p.pkgconfig p.perl p.kmod ];
      };
    default-pkgs = builtins.attrValues (desktop-tools //
      { inherit (pkgs) dmenu google-chrome gnupg isync unzip pass
                       gitFull libreoffice mosh manpages posix_man_pages
                       src rcs ledger3 xclip scrot file vlc gnumake
                       openconnect msmtp kvm gimp tmux bashCompletion evince
                       xbindkeys gcc python2 mercurial zoom-us autoconf automake
                       zip;
        inherit (pkgs.emacsPackages) notmuch proofgeneral_HEAD;
        inherit (pkgs.xorg) xmodmap xbacklight xkbcomp;
        inherit (pkgs.texlive.combined) scheme-full;
        inherit (coq) ocaml camlp5;
        inherit setup-home st emacs ghc coq linux-config-env;
      });
    default-env =
      { XDG_DATA_HOME = "/home-persistent/shlevy/xdg/share";
        XDG_CONFIG_HOME = "/home-persistent/shlevy/xdg/config";
        XDG_CACHE_HOME = "/home-persistent/shlevy/xdg/cache";
        HISTFILE = "/home-persistent/shlevy/bash_history";
        GNUPGHOME = "/home-persistent/shlevy/creds/gnupg";
        PASSWORD_STORE_DIR = "/home-persistent/shlevy/creds/password-store/";
        EMACSLOADPATH= "/run/current-system/sw/share/emacs/site-lisp:";
        # NIX_PATH = "/home/shlevy/src";
      };
    envs.default = pkgs.callPackage ./user-env.nix {}
      { paths = default-pkgs; env = default-env; };
in pkgs.runCommand "envs" {} ''
  mkdir -p $out
  ${builtins.concatStringsSep "\n" (map (n:
    "ln -sv ${envs.${n}} $out/${n}"
  ) (builtins.attrNames envs))}
''
