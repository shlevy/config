{ config, ... }:

{
  home-manager.users.shlevy = {
    programs.emacs = {
      enable = true;

      extraPackages = epkgs: [
        epkgs.solaire-mode
        epkgs.doom-themes

        epkgs.flycheck
      ];

      extraConfig = ''
        (solaire-global-mode +1)

        (load-theme 'doom-vibrant t)
        (doom-themes-visual-bell-config)
        (doom-themes-org-config)

        (global-flycheck-mode)

        (setq
          backup-by-copying t
          backup-directory-alist '(("." . "~/.cache/emacs/saves"))
          delete-old-versions t
          kept-new-versions 6
          kept-old-versions 2
          version-control t

          auth-source-save-behavior nil)
      '';
    };

    services.emacs = {
      enable = true;

      client.enable = true;

      defaultEditor = true;
    };
  };
}
