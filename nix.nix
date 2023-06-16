{ pkgs, ... }: {
  imports = [
    ./nix/tweag.nix
    ./nix/nixbuild.net.nix
  ];

  nix.settings = {
    max-jobs = 8;
    cores = 0;
    sandbox = true;
    substituters = [ "https://cache.iog.io" "https://cache.zw3rk.com" "https://shlevy.cachix.org" ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "shlevy.cachix.org-1:m0i9ZqalXsWjEkdJT8+hX+Ev7sGnYOPA+DHAS9B6mPo="
      "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
    ];
    trusted-users = [ "root" "shlevy" ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
    bash-prompt = ''\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w \[\033[01;31m\](dev-shell)\[\033[01;32m\]]\$ \[\033[0m\]'';
  };
  nix.package = pkgs.nixVersions.nix_2_15;

  nix.nixPath = [ "nixpkgs=/home/shlevy/.nix-defexpr/channels/nixos" ];

  home-manager.users.shlevy.programs = {
    command-not-found.dbPath = "/home/shlevy/.nix-defexpr/channels/nixos/programs.sqlite";

    emacs.extraPackages = epkgs: [
      epkgs.nix-mode
    ];
  };
}
