{ pkgs, lib, ... }: let
  inherit (pkgs) notmuch coreutils gnused gnugrep;

  move-mail = pkgs.writeShellScriptBin "move-mail" ''
    set -eEuo pipefail

    export PATH="${lib.makeBinPath [ coreutils gnused gnugrep ]}"

    if [ "$#" -lt 1 ]; then
      echo "USAGE: $0 DEST FILE..." >&2
      exit 1
    fi

    readonly dest_base="$1"
    shift

    for file do
      if [ ! -e "$file" ]; then
        echo "$file already removed, probably need notmuch new" >&2
        continue
      fi
      dest_basename="$(basename "$file" | (grep -E '[[:digit:]]+\.[a-zA-Z0-9_]+\.' || true) | sed 's|,U=[^,:]*||')"
      if [ -z "$dest_basename" ]; then
        echo "$file is not a maildir file?" >&2
        continue
      fi
      mv --verbose --no-clobber "$file" "$dest_base/cur/$dest_basename"
    done
  '';
in {
  home-manager.users.shlevy = { config, ... }: let
    email = config.accounts.email;
  in {
    home.packages = [ move-mail ];
    accounts.email.accounts."shea@shealevy.com" = {
      address = "shea@shealevy.com";

      folders.sent = "Sent Items";

      imap = {
        host = "mail.hover.com";
        tls.enable = true;
      };

      smtp = {
        host = "mail.hover.com";
        tls.enable = true;
      };

      passwordCommand = "pass shea@shealevy.com";

      primary = true;

      realName = "Shea Levy";

      userName = "shea@shealevy.com";

      imapnotify = {
        enable = true;

        boxes = [ "Inbox" "Spam" ];

        onNotify = "systemctl --user start mbsync";
      };

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        # patterns = [ "*" "INBOX" ];
        remove = "both";
      };

      msmtp.enable = true;

      notmuch.enable = true;
    };

    programs.mbsync.enable = true;

    services.imapnotify.enable = true;

    services.mbsync = {
      enable = true;
      frequency = "*:0/9";
    };
    services.mbsync.preExec = (pkgs.writeShellScript "mbsync-pre-exec" ''
      set -eEuo pipefail

      export PATH="$PATH:${lib.makeBinPath [ move-mail notmuch ]}"

      readonly mail_base="${email.maildirBasePath}/${email.accounts."shea@shealevy.com".maildir.path}"

      notmuch search --output=files --format=text0 folder:shea@shealevy.com/Inbox '(not is:inbox)' |
        xargs --null --no-run-if-empty \
        move-mail "$mail_base/Archives"

      notmuch search --exclude=false --output=files --format=text0 is:spam '(not is:deleted)' '(not folder:shea@shealevy.com/Spam)' |
        xargs --null --no-run-if-empty \
        move-mail "$mail_base/Spam"

      notmuch search --exclude=false --output=files --format=text0 is:deleted '(not folder:shea@shealevy.com/Trash)' |
        xargs --null --no-run-if-empty \
        move-mail "$mail_base/Trash"
    '').outPath;
    services.mbsync.postExec = "${notmuch}/bin/notmuch new";

    programs.msmtp.enable = true;

    programs.notmuch.enable = true;
    programs.notmuch.hooks.postNew = ''
      notmuch tag +spam -inbox is:inbox folder:shea@shealevy.com/Spam
      notmuch tag +deleted -inbox is:inbox folder:shea@shealevy.com/Trash
    '';

    programs.emacs = {
      extraPackages = _: [ notmuch.emacs ];
      extraConfig = ''
        (require 'notmuch)
        (setq notmuch-fcc-dirs "shea@shealevy.com/Archives")
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
          message-forward-as-mime t
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
    };
  };
}
