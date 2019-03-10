{ ghc, cabal-install, cabal2nix }:
{
  compose = { requires, provides }: {
    requires.emacs-packages = epkgs: [
      epkgs.haskell-mode epkgs.company-ghci epkgs.flycheck-haskell
    ];
    requires.emacs-config = ''
      (eval-after-load 'flycheck
        '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
      (require 'haskell-interactive-mode)
      (require 'haskell-process)
      (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      (require 'company-ghci)
      (push 'company-ghci company-backends)
    '';
    requires.packages = [ ghc cabal-install cabal2nix ];
    requires.links.".cabal" = "/home-persistent/shlevy/xdg/config/cabal";
  };
}
