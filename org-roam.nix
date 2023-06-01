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
        (org-roam-db-autosync-mode)
        (setq org-roam-capture-templates
              '(("m" "main" plain
                 "%?"
                 :if-new (file+head "main/''${slug}.org"
                                    "#+title: ''${title}\n* Folgezettel/Changelog\n- %u ::\n")
                 :immediate-finish t
                 :unnarrowed t)
                ("t" "state" plain
                 "%?"
                 :if-new (file+head "state/''${slug}.org"
                                    "#+title: ''${title}\n")
                 :immediate-finish t
                 :unnarrowed t)
                ("s" "source" plain "%?"
                 :if-new
                 (file+head "source/''${title}.org" "#+title: ''${title}\n")
                 :immediate-finish t
                 :unnarrowed t)))
      '';

      extraCustomize = ''
        (customize-set-variable 'org-roam-directory "~/Documents/roam")
      '';
    };
  };
}
