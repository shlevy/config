{ notmuch }:
{
  compose = { provides, requires }: {
    requires.emacs-package = _: notmuch.emacs;

    requires.package = notmuch;

    # TODO parameterize config
    requires.emacs-config = ''
      (autoload 'notmuch "notmuch" "notmuch mail" t)
      (setq notmuch-crypto-process-mime t)
      (setq notmuch-fcc-dirs "Archives")
      (setq message-kill-buffer-on-exit t)
      (require 'mml2015)
      (setq mml2015-encrypt-to-self t)
      (setq mml2015-sign-with-sender t)
      (add-hook 'message-setup-hook 'mml-secure-sign-pgpmime)
      (with-eval-after-load 'notmuch-show
        (defun notmuch-show-delete-message-then-next-or-next-thread ()
          (interactive)
          (notmuch-show-tag '("+deleted"))
          (unless (notmuch-show-next-open-message)
            (notmuch-show-next-thread t)))
        (define-key notmuch-show-mode-map "d" 'notmuch-show-delete-message-then-next-or-next-thread))
      (with-eval-after-load 'notmuch
        (defun notmuch-search-delete-thread ()
          (interactive)
          (notmuch-search-tag '("+deleted"))
          (notmuch-search-next-thread))
        (define-key notmuch-search-mode-map "d" 'notmuch-search-delete-thread))

      (setq
        mail-envelope-from 'header
        mail-specify-envelope-from t
        message-sendmail-envelope-from 'header
        mml-secure-key-preferences
          (quote
           ((OpenPGP
             (sign)
             (encrypt
              ("shea@shealevy.com" "37DC4CAB574ED7A7679ACC0BF483E15E39118520")))
            (CMS
             (sign)
             (encrypt))))
        notmuch-saved-searches
          (quote
           ((:name "inbox" :query "tag:inbox" :key "i")
            (:name "unread" :query "tag:unread" :key "u")
            (:name "flagged" :query "tag:flagged" :key "f")
            (:name "sent" :query "tag:sent" :key "t")
            (:name "drafts" :query "tag:draft" :key "d")
            (:name "all mail" :query "*" :key "a")
            (:name "spam" :query "is:spam")))
        send-mail-function (quote sendmail-send-it)
        send-mail-program "msmtp"
        sendmail-program "msmtp")
    '';

    requires.links.".notmuch-config" = ./notmuch-config;
  };
}
