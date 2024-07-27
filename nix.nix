{ pkgs, config, ... }: {
  nix.settings = {
    max-jobs = 8;
    cores = 0;
    sandbox = true;
    substituters = pkgs.lib.mkAfter [ "https://cache.iog.io" "https://shlevy.cachix.org" ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "shlevy.cachix.org-1:m0i9ZqalXsWjEkdJT8+hX+Ev7sGnYOPA+DHAS9B6mPo="
    ];
    trusted-users = [ "root" config.users.me ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" "fetch-closure" ];
    bash-prompt = ''\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w \[\033[01;31m\](dev-shell)\[\033[01;32m\]]\$ \[\033[0m\]'';
    netrc-file = "/home/${config.users.me}/.netrc";
  };

  nix.nixPath = [ "nixpkgs=/home/${config.users.me}/.nix-defexpr/channels/nixos" ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.${config.users.me} = {
    home.packages = [ pkgs.nix-prefetch-git ];

    programs = {
      command-not-found.dbPath = "/home/${config.users.me}/.nix-defexpr/channels/nixos/programs.sqlite";

      emacs.extraPackages = epkgs: [
        epkgs.nix-mode
      ];
    };
  };
}
