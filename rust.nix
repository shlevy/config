{ pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [ rustc cargo clippy rustfmt ];
    programs.emacs.extraPackages = epkgs: with epkgs; [ rust-mode ];
  };
}
