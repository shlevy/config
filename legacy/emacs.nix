{ emacs, emacsPackagesNgFor, imagemagick, writeText }: let
  inherit (emacsPackagesNgFor (emacs.override {
    inherit imagemagick;
  })) emacsWithPackages;
in {
  compose = { provides, requires }: let
    emacs = emacsWithPackages provides.emacs-packages;
  in {
    requires.package = emacs;
    requires.links.".emacs" = writeText "emacs" (provides.emacs-config + "\n" + ''
      (global-visual-line-mode)
      (server-start)
      (setq
         message-forward-as-mime t
         backup-by-copying t
         backup-directory-alist
          '(("." . "/home-persistent/shlevy/xdg/cache/emacs/saves")) ; TODO find a nicer way to specify this
         delete-old-versions t
         kept-new-versions 6
         kept-old-versions 2
         version-control t
         auth-source-save-behavior nil)
         (add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))
    '');
    requires.links.".emacs.d" = "/home-persistent/shlevy/xdg/config/emacs";
  };
}
