{
  compose = { requires, provides }: {
    requires.emacs-package = epkgs: epkgs.fill-column-indicator;

    requires.emacs-config = "(require 'fill-column-indicator)";
  };
}
