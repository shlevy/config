{
  compose = { requires, provides }: {
    requires.emacs-package = epkgs: epkgs.znc;

    requires.emacs-config = ''
      (with-eval-after-load "znc"
        (let ((cmd "gpg -q --for-your-eyes-only --no-tty -d ~/creds/password-store/znc.gpg"))
          (setq znc-servers
                `(("linode.shealevy.com" 5000 t
                  ((freenode "shlevy" ,(shell-command-to-string cmd))))))))
      (setq erc-hide-list '("JOIN" "PART" "QUIT"))
    '';
  };
}
