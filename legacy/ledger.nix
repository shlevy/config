{ ledger }:
{
  compose = { requires, provides }: {
    requires.package = ledger;

    requires.emacs-package = epkgs: epkgs.ledger-mode;
  };
}
