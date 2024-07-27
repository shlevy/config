{ pkgs, ... }: {
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
          SCRIPT_FILENAME = "${pkgs.gitAndTools.gitFull}/libexec/git-core/git-http-backend";
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
