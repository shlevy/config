{ cargo, rustc, rustfmt, rustracer, rustcSrc }:
{
  compose = { requires, provides }: {
    requires.emacs-packages = epkgs: [
      epkgs.rust-mode epkgs.flycheck-rust epkgs.racer epkgs.cargo

    ];
    requires.emacs-config = ''
      (setq racer-rust-src-path "${rustcSrc}")
      (with-eval-after-load 'rust-mode
        (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
      (add-hook 'rust-mode-hook #'racer-mode)
      (add-hook 'racer-mode-hook #'eldoc-mode)
      (add-hook 'racer-mode-hook #'company-mode)
      (require 'rust-mode)
      (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
      (setq company-tooltip-align-annotations t)
      (add-hook 'rust-mode-hook 'cargo-minor-mode)
      (setq rust-format-on-save t)
    '';
    requires.packages = [ cargo rustc rustfmt rustracer ];
    requires.links.".cargo" = "/home-persistent/shlevy/xdg/config/cargo";
  };
}
