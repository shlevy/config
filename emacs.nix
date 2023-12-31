{
  home-manager.users.shlevy = { pkgs, lib, config, ... }: {
    config = {
      programs.emacs = {
        enable = true;

        extraPackages = epkgs: with epkgs; [
          solaire-mode
          doom-themes
          vlf
          company
          agda-input
          package-lint
          pdf-tools
        ];

        package = pkgs.emacs29-pgtk;

        extraConfig = ''
          (solaire-global-mode +1)

          (load-theme 'doom-vibrant t)
          (doom-themes-visual-bell-config)
          (doom-themes-org-config)

          (require 'vlf-setup)

          (add-hook 'after-init-hook 'global-company-mode)

          (global-visual-line-mode)

          (require 'agda-input)

          (pdf-tools-install)

          (defun customize-add-to-list (variable value &optional comment)
            "Add VALUE to the custom list variable VARIABLE, and return VALUE.
          VALUE is a Lisp object.

          If VARIABLE has a `custom-set' property, that is used for setting
          VARIABLE, otherwise `set-default' is used."
            (customize-set-variable variable (if (boundp variable)
                                                (cons value (symbol-value variable))
                                            (list value)) comment))
        '' + config.programs.emacs.extraCustomize;

        extraCustomize = ''
          (customize-set-variable 'backup-by-copying t)
          (customize-set-variable 'backup-directory-alist '(("." . "~/.cache/emacs/saves")))
          (customize-set-variable 'delete-old-versions t)
          (customize-set-variable 'kept-new-versions 6)
          (customize-set-variable 'kept-old-versions 2)
          (customize-set-variable 'version-control t)

          (customize-set-variable 'auth-source-save-behavior nil)
        '';
      };

      services.emacs = {
        enable = true;

        client.enable = true;

        defaultEditor = true;

        socketActivation.enable = true;
      };
    };

    options.programs.emacs.extraCustomize = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration to include in the Emacs default init file,
          <em>after</em> custom customization functions are defined.
        '';
    };
  };
}
