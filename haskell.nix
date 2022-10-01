{ pkgs, ...}: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [ cabal-install ];

    programs.emacs = {
      extraPackages = epkgs: with epkgs; [
        haskell-mode company-ghci flycheck-haskell
      ];

      extraConfig = ''
        (eval-after-load 'flycheck
          '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
        (require 'haskell-interactive-mode)
        (require 'haskell-process)
        (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      '';

      extraCustomize = ''
        (require 'company-ghci)
        (customize-add-to-list 'company-backends 'company-ghci)
      '';
    };
  };
}
