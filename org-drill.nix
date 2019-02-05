{ fetchFromBitbucket }: let
  src = fetchFromBitbucket {
    owner = "eeeickythump";
    repo = "org-drill";
    rev = "01b05cd7561ad69e5ec9c1200414d4fa128c9a17";
    sha256 = "1w69hp2fbmq03xm10yalxrm8f7mhrbjc689k5wjnqgrqcwipi5gj";
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
