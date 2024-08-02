{ config, ... }: {
  home-manager.users.${config.users.me} = {
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.org-roam ];

      extraConfig = ''
        (require 'org-roam)
        (define-key global-map (kbd "C-c n l") 'org-roam-buffer-toggle)
        (define-key global-map (kbd "C-c n b") 'org-roam-buffer-display-dedicated)
        (define-key global-map (kbd "C-c n f") 'org-roam-node-find)
        (define-key global-map (kbd "C-c n t") 'org-roam-dailies-goto-today)
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
        (setq org-roam-dailies-capture-templates
               '(("d" "default" entry "* %?" :target
                 (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n| Start | End | What |\n|-------+-----+------|\n|       |     |      |"))))

        (setq shlevy-link-types
          ["maybe-elaborable-by"
           "maybe-aspect-of"
           "aspect-of"
           "maybe-specified-by"
           "accomplishment"
           "in-domain"
           "furthers"
           "maybe-furthers"
           "impedes"
           "source"
           "requirement-of"
           "violates-norm"
           "elaboration"
           "instance-of"
           "instance"
           "maybe-solution"
           "challenge-for"
           "question-for"
           "epistemic-norm-of"
           "employer"
           "former-employer"
           "outcome"
           "id"])
        (seq-doseq (ty shlevy-link-types)
          (org-link-set-parameters ty :follow #'org-roam-id-open))

        (cl-defun org-roam-backlinks-get (node &key unique)
          "Return the backlinks for NODE.

         When UNIQUE is nil, show all positions where references are found.
         When UNIQUE is t, limit to unique sources."
          (let* ((sql (if unique
                          [:select :distinct [source dest pos properties]
                           :from links
                           :where (= dest $s1)
                           :and (in type $v2)
                           :group :by source
                           :having (funcall min pos)]
                        [:select [source dest pos properties]
                         :from links
                         :where (= dest $s1)
                         :and (in type $v2)]))
                 (backlinks (org-roam-db-query sql (org-roam-node-id node) shlevy-link-types)))
            (cl-loop for backlink in backlinks
                     collect (pcase-let ((`(,source-id ,dest-id ,pos ,properties) backlink))
                               (org-roam-populate
                                (org-roam-backlink-create
                                 :source-node (org-roam-node-create :id source-id)
                                 :target-node (org-roam-node-create :id dest-id)
                                 :point pos
                                 :properties properties))))))

      '';

      extraCustomize = ''
        (customize-set-variable 'org-roam-directory "~/Documents/roam")
      '';
    };
  };
}
