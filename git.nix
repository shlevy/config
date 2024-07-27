{ pkgs, config, ... }: {
  home-manager.users.${config.users.me} = { config, ... }: {
    programs = {
      git = {
        enable = true;

        package = pkgs.gitAndTools.gitFull;

        extraConfig.init.defaultBranch = "master";

        signing.signByDefault = config.programs.git.signing.key != null;

        extraConfig.merge.conflictstyle = "zdiff3";

        extraConfig.rerere.enabled = true;

        lfs.enable = true;
      };

      emacs.extraPackages = epkgs: [ epkgs.magit ];
    };
  };
}
