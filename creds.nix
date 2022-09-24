{ pkgs, ... }: {
  home-manager.users.shlevy = { config, ... }: let
    creds = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/creds";
  in {
    programs.gpg = {
      enable = true;

      homedir = "${config.home.homeDirectory}/creds/gnupg";

      settings = {
        keyid-format = "long";

        require-cross-certification = true;

        keyserver = "hkp://pgp.mit.edu";
      };
    };

    services.gpg-agent = {
      enable = true;

      pinentryFlavor = "gnome3";
    };

    programs.password-store = {
      enable = true;

      package = (pkgs.pass.override {
        waylandSupport = true;
      }).overrideDerivation (orig: {
        patches = (orig.patches or []) ++ [ ./patches/pass-wayland.patch ];
      });

      settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/creds/password-store";
    };

    home.file ={
      ".aws" = {
        source = "${creds}/aws";
      };
      ".ssh" = {
        source = "${creds}/ssh";
      };
      ".netrc" = {
        source = "${creds}/netrc";
      };
    };
  };
}
