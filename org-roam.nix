{ sqlite, graphviz }: {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.melpaStablePackages.org-roam;

    requires.emacs-config = ''
      (customize-set-variable 'org-roam-directory "~/documents/org-roam")
      (require 'org-roam)
      (define-key global-map (kbd "C-c n l") 'org-roam-buffer-toggle)
      (define-key global-map (kbd "C-c n f") 'org-roam-node-find)
      (define-key global-map (kbd "C-c n i") #'org-roam-node-insert)

      (org-roam-setup)
    '';

    requires.packages = [ sqlite graphviz ];
  };
}
