{ root }:
let inherit (import <nixpkgs> {})
      haskellPackages nixBufferBuilders lib haskell coq_8_7;
    # Look up from the root to find a cabal file
    haskell-found = lib.filesystem.locateDominatingFile "([^.].*)\\.cabal" root;
    # The name of the first cabal file in the directory
    cabal-name = builtins.head (builtins.head haskell-found.matches);
    # Nix expression corresponding to our cabal file
    cabal-package =
      haskellPackages.callCabal2nix cabal-name haskell-found.path {};

    # Look up from the root to find a _CoqProject file
    coq-found = lib.filesystem.locateDominatingFile "_CoqProject" root;
in if haskell-found != null
     # We found a cabal file
     then nixBufferBuilders.withPackages [ (builtins.head cabal-package.env.nativeBuildInputs) ]
     else if coq-found != null
     then nixBufferBuilders.withPackages [ coq_8_7 ]
     # Otherwise we fail
     else {}
