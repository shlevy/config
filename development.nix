{ pkgs, lib, config, ... }: {
  home-manager.users.${config.users.me} = {
    home.packages = with pkgs; [ yamllint gnumake ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.emacs = {
      extraPackages = epkgs: with epkgs; [
        flycheck
        yaml-mode
        markdown-mode
        envrc
      ];

      extraConfig = lib.mkAfter ''
        (global-flycheck-mode)
        (envrc-global-mode)
      '';
    };
  };
}
