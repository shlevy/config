{ pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [ yamllint ];
    programs.emacs = {
      extraPackages = epkgs: with epkgs; [
        flycheck
        yaml-mode
        markdown-mode
      ];

      extraConfig = ''
        (global-flycheck-mode)
      '';
    };
  };
}
