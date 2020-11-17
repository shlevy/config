{ agdaPackages, fetchFromGitHub }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.agda2-mode;

    requires.emacs-config = "(require 'agda2)";

    requires.package = agdaPackages.agda.withPackages [
      (agdaPackages.cubical.override (orig: {
        mkDerivation = args: orig.mkDerivation (args // {
          prePatch = ''
            sed -i 's/AGDA_EXEC=.*$/AGDA_EXEC=agda/' GNUmakefile
          '';
          version = "0.3-pre21cf7a1";
          src = fetchFromGitHub {
            repo = "cubical";
            owner = "agda";
            rev = "21cf7a1c292ea39dac1a0151b70088c36e7f9143";
            sha256 = "0y4vilrijc3vihh2zxgp5kj06iv5hg69a6p4p7z7h9kp47sdd00d";
          };
        });
      }))
    ];
  };
}
