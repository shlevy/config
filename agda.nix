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
            rev = "e2601d642074094f0a7183a54ba7cea411b024eb";
            sha256 = "10q21rwjmqmwdcgwj24p2v2w25f6imywasr0f4bn6kzrs8ghq3c9";
          };
        });
      }))
    ];
  };
}
