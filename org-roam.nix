{ fetchFromGitHub, sqlite, graphviz }: let
  version = "1.2.3";
  src = fetchFromGitHub {
    owner = "org-roam";
    repo = "org-roam";
    rev = "v${version}";
    sha256 = "0n8c0yxqb62i39kn0d5x83s96vwc0nbg0sx5hplffnbkfbj88bba";
  };
in {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-roam.override (orig: {
      melpaBuild = args: orig.melpaBuild (args // {
        inherit src version;
      });
    });

    requires.emacs-config = ''
      (customize-set-variable 'org-roam-directory "~/documents/org-roam")
      (setq org-roam-db-update-method 'immediate) ; Temporary pending https://github.com/org-roam/org-roam/pull/1281 in release
      (require 'org-roam)
      (define-key org-roam-mode-map (kbd "C-c n l") 'org-roam)
      (define-key org-roam-mode-map (kbd "C-c n f") 'org-roam-find-file)
      (define-key org-roam-mode-map (kbd "C-c n g") 'org-roam-graph)
      (define-key org-mode-map (kbd "C-c n i") 'org-roam-insert)
      (define-key org-mode-map (kbd "C-c n I") 'org-roam-insert-immediate)
      (setq org-roam-dailies-directory "daily/")

      (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           #'org-roam-capture--get-point
           "* %?"
           :file-name "daily/%<%Y-%m-%d>"
           :head "#+title: %<%Y-%m-%d>\n\n")))
      (org-roam-mode)
    '';

    requires.packages = [ sqlite graphviz ];
  };
}
