{ fetchFromGitHub }: let
  rev = "6b349997b4953f8574eb6c8c1c7a95ddacc4ba77";
  short-rev = builtins.substring 0 7 rev;
  version = "0.0.6";
  src = fetchFromGitHub {
    owner = "nobiot";
    repo = "org-transclusion";
    inherit rev;
    sha256 = "064flqnzsqzh7szsv6z58w3l0nfwjqjv3aiqjra2ig31kfi0aqd2";
  };
in {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.trivialBuild {
      pname = "org-transclusion";
      inherit src;
      version = "${version}-pre${short-rev}";
    };

    requires.emacs-config = ''
      (require 'org-transclusion)
      (define-key org-roam-mode-map (kbd "C-c n t") 'org-transclusion-mode)
    '';
  };
}
