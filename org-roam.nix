{ fetchFromGitHub, sqlite, graphviz }: let
  src = fetchFromGitHub {
    owner = "org-roam";
    repo = "org-roam";
    rev = "55008e3707c4960afbc6e2c0fcd6e72a1e60fc0a"; #v2 branch
    sha256 = "0kvh6fy73m7bcp2jgyvkkfbwzdr82416f1m688h5g831b0shhr8j";
  };
in {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.melpaBuild {
      pname = "org-roam";
      version = "2.0.0";
      recipe = builtins.toFile "org-roam-recipe" ''
        (org-roam :fetcher github
          :repo "org-roam/org-roam"
          :branch "v2")
      '';
      inherit src;
      packageRequires = [ epkgs.dash epkgs.f epkgs.org epkgs.emacsql epkgs.emacsql-sqlite epkgs.magit-section ];
    };

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
