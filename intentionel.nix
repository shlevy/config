{
  compose = { requires, provides }: {
    requires.emacs-package = epkgs: epkgs.elpaBuild {
      pname = "intentionel";
      version = "1.0.1";
      src = /home/shlevy/src/intentionel/intentionel.el;
      packageRequires = [
        epkgs.org
        epkgs.stream
        epkgs.org-brain
        epkgs.dash-functional
      ];
    };
  };
}
