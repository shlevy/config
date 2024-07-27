{ pkgs, config, ... }: {
  home-manager.users.${config.users.me} = {
    home.packages = with pkgs; [ rustc cargo clippy rustfmt ];
    programs.emacs.extraPackages = epkgs: with epkgs; [ rust-mode ];
  };
}
