let pkgs = import <nixpkgs>
      { config =
          { allowUnfree = true;
            emacsSupport = true;
          };
      };
    desktop-tools-scripts =
      import ../src/shlevy-desktop-tools/scripts.nix { inherit (pkgs) runCommand; };
    setup-home = pkgs.callPackage ./setup-home.nix {}
      { dotfiles = ./dotfiles-work;
        other-files =
          { "dir-locals.nix" = ./dir-locals.nix;
          };
      };
    emacs = pkgs.emacsWithPackages (builtins.attrValues
      { inherit (pkgs.emacsPackagesNg) flycheck dash dash-functional f s
          company fill-column-indicator flycheck-package modalka
          org-plus-contrib nix-buffer haskell-mode company-ghci
          flycheck-haskell helm;
      });
    ghc = pkgs.haskellPackages.ghcWithPackages (s:
      [ s.cabal-install s.cabal2nix ]);
    default-pkgs = builtins.attrValues (desktop-tools-scripts //
      { inherit (pkgs) gnupg unzip pass gitFull mosh file tmux
                       bashCompletion nixUnstable gcc gnumake;
        inherit (pkgs.texlive.combined) scheme-full;
        inherit setup-home emacs ghc;
      });
    default-env =
      { EMACSLOADPATH = "/run/current-system/sw/share/emacs/site-lisp:";
        XDG_RUNTIME_DIR = "\$TMPDIR/run";
      };
    envs.default = pkgs.callPackage ./user-env.nix {}
      { paths = default-pkgs; env = default-env; };
in pkgs.runCommand "envs" {} ''
  mkdir -p $out
  ${builtins.concatStringsSep "\n" (map (n:
    "ln -sv ${envs.${n}} $out/${n}"
  ) (builtins.attrNames envs))}
''
