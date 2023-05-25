{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    # Remove when upgrading past 22.11
    nixpkgs-master.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-master, ... }@inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    pkgsMaster = nixpkgs-master.legacyPackages.x86_64-linux;
    inherit (pkgs) writeShellScript nixos-rebuild gnugrep;
  in {
    apps.x86_64-linux.default = {
      type = "app";
      program = (pkgs.writeShellScript "rebuild" ''
        set -eEuo pipefail

        readonly grep="${gnugrep}/bin/grep"
        readonly nixos_rebuild="${nixos-rebuild}/bin/nixos-rebuild"

        cmd="''${1:-switch}"

        if ! "$grep" --quiet --no-messages --fixed-strings 102363c5-6d60-477e-bf66-98b0d752e7d4 flake.nix
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

        $sudo "$nixos_rebuild" "$cmd" --flake .#spectre
      '').outPath;
    };

    nixosConfigurations.darter6 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs pkgsMaster; };
      modules = [
        ./darter6.nix
        ./nixos-common.nix
      ];
    };

    nixosConfigurations.spectre = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs pkgsMaster; };
      modules = [
        ./spectre.nix
        ./nixos-common.nix
      ];
    };
  };
}
