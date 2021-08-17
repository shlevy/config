{ fetchFromGitHub }: let
  rev = "ca4bcc91e37a4b7406d3b50df8e08dfe2ab54d40";
  short-rev = builtins.substring 0 7 rev;
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "phaer";
    repo = "cue-mode.el";
    inherit rev;
    sha256 = "0kjxxdznzhwa9pfc4gw1hmqg0rw90vkl2k9z2lzw7ps9k3rq1x7i";
  };
in {
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.trivialBuild {
      pname = "cue-mode";
      inherit src;
      version = "${version}-pre${short-rev}";
    };
  };
}
