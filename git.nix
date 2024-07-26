{ pkgs, ... }: let
  git = pkgs.gitAndTools.gitFull;
in {
  home-manager.users.shlevy.programs = {
    git = {
      enable = true;

      package = git;

      userName = "Shea Levy";
      userEmail = "shea@shealevy.com";

      extraConfig.init.defaultBranch = "master";

      signing = {
        key = "5C0BD6957D86FE27";

        signByDefault = true;
      };

      extraConfig.merge.conflictstyle = "zdiff3";

      extraConfig.rerere.enabled = true;

      extraConfig.sendemail = {
        smtpencryption = "ssl";
        smtpserver = "mail.hover.com";
        smtpuser = "shea@shealevy.com";
        smtpserverport = 465;
      };

      lfs.enable = true;
    };

    emacs.extraPackages = epkgs: [ epkgs.magit ];
  };

  services.fcgiwrap = {
    enable = true;
    user = "nginx";
    group = "nginx";
  };

  services.nginx = {
    enable = true;
    virtualHosts."git.shealevy.com" = {
      forceSSL = true;
      enableACME = true;

      root = "/var/lib/git";
      locations."/" = {
        basicAuthFile = "/var/lib/git/auth";
        fastcgiParams = {
          SCRIPT_FILENAME = "${git}/libexec/git-core/git-http-backend";
          GIT_PROJECT_ROOT = "/var/lib/git";
          PATH_INFO = "$fastcgi_path_info";
        };
        extraConfig = ''
          fastcgi_split_path_info ^()(.*)$;
          fastcgi_pass unix:/run/fcgiwrap.sock;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "shea@shealevy.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
