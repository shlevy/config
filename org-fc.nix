{ fetchFromGitHub }: let
  src = fetchFromGitHub {
    owner = "l3kn";
    repo = "org-fc";
    rev = "f1a872b53b173b3c319e982084f333987ba81261";
    sha256 = "14vjpjcmg4s1a5nzn17yv82fihh3f4znzr30qlrbhmhqzv56wq5k";
  };
in {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.org-fc;
    requires.emacs-config = ''
      (add-to-list 'load-path "${src}")
      (customize-set-variable 'org-fc-directories '("~/documents/org-roam"))
      (require 'org-fc)
    '';
  };
}
