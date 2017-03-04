{ root }:
let inherit (import <nixpkgs> {})
      haskellPackages nixBufferBuilders lib haskell;
    # Look up from the root to find a cabal file
    found = lib.filesystem.locateDominatingFile "([^.].*)\\.cabal" root;
    # The name of the first cabal file in the directory
    cabal-name = builtins.head (builtins.head found.matches);
    # Nix expression corresponding to our cabal file
    cabal-package =
      haskell.lib.overrideCabal (haskellPackages.callCabal2nix cabal-name
        (found.path + "/${cabal-name}.cabal")
        {}) (drv: { src = null; });
in if found != null
     # We found a cabal file
     then nixBufferBuilders.withPackages [ (builtins.head cabal-package.env.nativeBuildInputs) ]
     # Currently we only support cabal projects, so if we're not editing one
     # we do nothing.
     else {}
