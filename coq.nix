{ coq }:
{
  compose = { provides, requires }: {
    requires.emacs-package = epkgs: epkgs.proof-general;

    requires.package = coq;
  };
}
