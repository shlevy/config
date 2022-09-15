{ git, git-lfs }:
{
  compose = { requires, provides}: {
    requires = {
      packages = [ git git-lfs ];

      emacs-package = epkgs: epkgs.magit;

      emacs-config = ''
        (global-set-key (kbd "C-x g") #'magit-status)
        (setq magit-diff-refine-hunk 'all)
      '';

      links.".gitconfig" = ./gitconfig;
    };
  };
}
