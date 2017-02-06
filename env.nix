let pkgs = import <nixpkgs> { config.allowUnfree = true; };
    desktop-tools = import ../src/shlevy-desktop-tools pkgs;
    setup-home = pkgs.callPackage ./setup-home.nix {}
      { dotfiles = ./dotfiles;
        other-files =
          { src = "/home-persistent/shlevy/src";
            creds = "/home-persistent/shlevy/creds";
            config = "/home-persistent/shlevy/config";
            ".xsession" = "${pkgs.dwm}/bin/dwm";
          };
      };
    default-pkgs = builtins.attrValues (desktop-tools //
      { inherit (pkgs) st dmenu google-chrome gnupg isync git;
        inherit setup-home;
      });
    default-env =
      { XDG_DATA_HOME = "/home-persistent/shlevy/xdg/share";
        XDG_CONFIG_HOME = "/home-persistent/shlevy/xdg/config";
        XDG_CACHE_HOME = "/home-persistent/shlevy/xdg/cache";
        HISTFILE = "/home-persistent/shlevy/bash_history";
        GNUPGHOME = "/home-persistent/shlevy/gnupg";
        PASSWORD_STORE_DIR = "/home/shlevy/creds/password-store";
      };
    envs.default = pkgs.callPackage ./user-env.nix {}
      { paths = default-pkgs; env = default-env; };
in pkgs.runCommand "envs" {} ''
  mkdir -p $out
  ${builtins.concatStringsSep "\n" (map (n:
    "ln -sv ${envs.${n}} $out/${n}"
  ) (builtins.attrNames envs))}
''
