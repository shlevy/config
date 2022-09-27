{
  home-manager.users.shlevy = {
    programs.emacs = {
      enable = true;

      extraPackages = epkgs: with epkgs; [
        solaire-mode
        doom-themes
        vlf
        company
      ];

      extraConfig = ''
        (solaire-global-mode +1)

        (load-theme 'doom-vibrant t)
        (doom-themes-visual-bell-config)
        (doom-themes-org-config)

        (require 'vlf-setup)

        (add-hook 'after-init-hook 'global-company-mode)

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
