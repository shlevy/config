{
  home-manager.users.shlevy = {
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.org-bullets ];

      extraConfig = ''
        (require 'org-bullets)
        (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
      '';
    };
  };
}
