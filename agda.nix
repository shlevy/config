{ agdaPackages, fetchFromGitHub }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.agda2-mode;

    requires.emacs-config = "(require 'agda2)";

    requires.package = agdaPackages.agda.withPackages [
      agdaPackages.cubical
    ];
  };
}
