{ agda }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.agda2-mode;

    requires.emacs-config = "(require 'agda2)";

    requires.package = agda.withPackages (p : [ p.standard-library p.cubical ]);
  };
}
