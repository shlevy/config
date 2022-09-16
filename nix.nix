{
  nix = {
    maxJobs = 8;
    buildCores = 0;
    useSandbox = true;
    binaryCaches = [ "https://cache.iog.io" ];
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    trustedUsers = [ "shlevy" ];
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
  };

  home-manager.users.shlevy.programs.emacs.extraPackages = epkgs: [
    epkgs.nix-mode
  ];
}
