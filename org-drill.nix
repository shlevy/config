{ fetchFromGitHub }: let
  src = fetchFromGitHub {
    owner = "hakanserce";
    repo = "org-drill";
    rev = "9e07edde08ce4b439bbc8baa33d3f09d28745c81";
    sha256 = "1qhp9rzqscdbhlvdf1h4jl8sjpyj1ggy7by5x1h17vlhpwlpi0hg";
  };
in {
  compose = { provides, requires }: let
    snippets = map (x: "\"${x}\"") provides.org-drill-files;
  in {
    requires.emacs-config = ''
      (require 'org-drill "${src}/org-drill.el")
      (setq org-drill-maximum-items-per-session nil)
      (setq org-drill-maximum-duration nil)
      (setq org-drill-scope '(${builtins.concatStringsSep " " snippets}))
    '';
  };
}
