{
  nix.settings = {
    max-jobs = 8;
    cores = 0;
    sandbox = true;
    substituters = [ "https://cache.iog.io" "https://shlevy.cachix.org" ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "shlevy.cachix.org-1:m0i9ZqalXsWjEkdJT8+hX+Ev7sGnYOPA+DHAS9B6mPo="
    ];
    trusted-users = [ "root" "shlevy" ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  home-manager.users.shlevy.programs.emacs.extraPackages = epkgs: [
    epkgs.nix-mode
  ];
}
