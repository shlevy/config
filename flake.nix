{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... }@inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    apps.x86_64-linux.default = {
      type = "app";
      program = (pkgs.writeShellScript "rebuild" ''
        set -eEuo pipefail

        cmd="''${1:-switch}"

        if ! grep --quiet --no-messages --fixed-strings 102363c5-6d60-477e-bf66-98b0d752e7d4 flake.nix
        then
          echo "You must run this in the root of config!" >&2
          exit 1
        fi

        if [ "$cmd" = "build" ]
        then
          sudo=
        else
          sudo=sudo
        fi

        $sudo nixos-rebuild "$cmd" --flake .
      '').outPath;
    };
    nixosConfigurations.darter6 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./home-manager.nix

        ./bash.nix
        ./emacs.nix
        ./git.nix
        ./nix.nix
      ];
    };
  };
}
