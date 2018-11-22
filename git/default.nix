{ git }:
{
  compose = { requires, provides}: {
    requires = {
      package = git;

      emacs-package = epkgs: epkgs.magit;

      emacs-config = ''(global-set-key (kbd "C-x g") #'magit-status)'';

      links.".gitconfig" = ./gitconfig;
    };
  };
}
