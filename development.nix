{
  home-manager.users.shlevy = {
    programs.emacs = {
      extraPackages = epkgs: with epkgs; [
        flycheck
      ];

      extraConfig = ''
        (global-flycheck-mode)
      '';
    };
  };
}
