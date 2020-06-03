{ coq }:
{
  compose = { provides, requires }: {
    requires.emacs-packages = epkgs: [ epkgs.proof-general epkgs.agda-input ];

    requires.emacs-config = "(require 'agda-input)";

    requires.package = coq;
  };
}
