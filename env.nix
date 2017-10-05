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
            "dir-locals.nix" = ./dir-locals.nix;
            ".xsession" = "${dwm}/bin/dwm";
            ".ssh" = "/home-persistent/shlevy/creds/ssh";
            ".aws/credentials" = "/home-persistent/shlevy/creds/aws/credentials";
          };
      };
    dwm = pkgs.dwm.override { patches = [ ./dwm.patch ]; };
    lean = pkgs.lib.overrideDerivation pkgs.lean (orig: { patches = [ ./lean-coe_to_sort.patch ]; });
    emacs = pkgs.emacsWithPackages (builtins.attrValues
      { inherit (pkgs.emacsPackages) notmuch;
        inherit (pkgs.emacsPackagesNg) flycheck dash dash-functional f s
          company fill-column-indicator flycheck-package modalka
          org-plus-contrib nix-buffer haskell-mode znc company-ghci
          flycheck-haskell helm idris-mode kanban lean-mode company-lean helm-lean;
      });
    ghc = pkgs.haskellPackages.ghcWithPackages (s:
      [ s.cabal-install s.cabal2nix ]);
    coq = pkgs.coq_8_6;
    linux-config-env = pkgs.buildFHSUserEnv
      {  name = "linux-config";
         targetPkgs = p: [ p.gcc p.gnumake p.ncurses p.ncurses.dev p.bashCompletion p.qt5.full p.pkgconfig p.perl p.kmod ];
      };
    openmpi-no-otfinfo = pkgs.runCommand pkgs.openmpi.name {} ''
      mkdir $out
      for file in ${pkgs.openmpi}/*; do # */
        if [ $(basename $file) != "bin" ]; then
          ln -sv $file $out
        fi
      done
      mkdir $out/bin
      for file in ${pkgs.openmpi}/bin/*; do # */
        ln -sv $file $out/bin
      done
      unlink $out/bin/otfinfo
    '';
    default-pkgs = (builtins.attrValues (desktop-tools //
      { inherit (pkgs) dmenu google-chrome gnupg isync unzip pass
                       gitFull libreoffice mosh manpages posix_man_pages
                       src rcs ledger3 xclip scrot file vlc gnumake
                       openconnect msmtp kvm gimp tmux bashCompletion evince
                       xbindkeys python2 mercurial autoconf automake
                       zip openssl cmake pkgconfig libtool lightdm terraform_0_8_5 terragrunt_0_9_8
                       awscli ansible docker nixops sqlite jq nix boehmgc docbook_xsl kindlegen libxslt
                       libxml2 pavucontrol pamixer zoom-us /*neuron-full*/ gcc ncurses patchelf kubernetes kops
		       discord;
        inherit (pkgs.emacsPackages) notmuch proofgeneral_HEAD;
        inherit (pkgs.xorg) xmodmap xbacklight xkbcomp libX11;
        inherit (pkgs.texlive.combined) scheme-full;
        inherit (coq) ocaml camlp5;
        inherit (pkgs.haskellPackages) idris;
        inherit setup-home emacs ghc coq linux-config-env openmpi-no-otfinfo lean;
      })) ++ [ pkgs.nix.dev ] ++ pkgs.nix.dev.propagatedNativeBuildInputs;
    default-env =
      { XDG_DATA_HOME = "/home-persistent/shlevy/xdg/share";
        XDG_CONFIG_HOME = "/home-persistent/shlevy/xdg/config";
        XDG_CACHE_HOME = "/home-persistent/shlevy/xdg/cache";
        HISTFILE = "/home-persistent/shlevy/bash_history";
        GNUPGHOME = "/home-persistent/shlevy/creds/gnupg";
        PASSWORD_STORE_DIR = "/home-persistent/shlevy/creds/password-store/";
        EMACSLOADPATH= "/run/current-system/sw/share/emacs/site-lisp:";
        AWS_CONFIG_FILE = "/home-persistent/shlevy/creds/aws/config";
        #NIX_PATH = "/home/shlevy/src";
      };
    envs.default = pkgs.callPackage ./user-env.nix {}
      { paths = default-pkgs; env = default-env; };
in pkgs.runCommand "envs" {} ''
  mkdir -p $out
  ${builtins.concatStringsSep "\n" (map (n:
    "ln -sv ${envs.${n}} $out/${n}"
  ) (builtins.attrNames envs))}
''
