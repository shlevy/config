{
  home-manager.users.shlevy = {
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.org-roam ];

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
                ("p" "project" plain
                 "%?"
                 :if-new (file+head "main/''${slug}.org"
                                    "#+FILETAGS: :project:\n#+title: ''${title}\n* Folgezettel/Changelog\n- %u ::\n")
                 :immediate-finish t
                 :unnarrowed t)
                ("s" "source" plain "%?"
                 :if-new
                 (file+head "source/''${title}.org" "#+title: ''${title}\n")
                 :immediate-finish t
                 :unnarrowed t)))

        (org-link-set-parameters "maybe-elaborable-by" :follow #'org-roam-id-open)
        (org-link-set-parameters "maybe-aspect-of" :follow #'org-roam-id-open)
        (org-link-set-parameters "maybe-specified-by" :follow #'org-roam-id-open)
        (org-link-set-parameters "accomplishment" :follow #'org-roam-id-open)
      '';

      extraCustomize = ''
        (customize-set-variable 'org-roam-directory "~/Documents/roam")
      '';
    };
  };
}
