{ pkgs, ... }:
{
  home-manager.users.shlevy.programs = {
    git = {
      enable = true;

      package = pkgs.gitAndTools.gitFull;

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
}
