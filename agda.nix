{ pkgs, config, ... }: {
  home-manager.users.${config.users.me} = {
    home.packages = [ (pkgs.agda.withPackages (p: [ p.cubical ])) ];

    programs.emacs = {
      extraPackages = epkgs: [ epkgs.agda2-mode ];
      extraConfig = ''
        (require 'agda2-mode)
      '';
    };
  };
}
