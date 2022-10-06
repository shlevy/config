{
  home-manager.users.shlevy = {
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.melpaStablePackages.org-roam ];

      extraConfig = ''
        (require 'org-roam)
        (define-key global-map (kbd "C-c n l") 'org-roam-buffer-toggle)
        (define-key global-map (kbd "C-c n b") 'org-roam-buffer-display-dedicated)
        (define-key global-map (kbd "C-c n f") 'org-roam-node-find)
        (define-key global-map (kbd "C-c n i") #'org-roam-node-insert)
        (define-key global-map (kbd "C-c n t") #'org-roam-dailies-goto-today)
        (define-key global-map (kbd "C-c n y") #'org-roam-dailies-goto-yesterday)
        (org-roam-db-autosync-mode)
      '';

      extraCustomize = ''
        (customize-set-variable 'org-roam-directory "~/Documents/roam")
      '';
    };
  };
}
