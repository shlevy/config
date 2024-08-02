{
  inputs = {
    # Check default version for emacs when upgrading
    nixpkgs.url = "github:shlevy/nixpkgs/ipu6-upstream-backport";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosModules.default = ./nixos-common.nix;
    nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager; };
      modules = [
        ./carbon.nix
        ./nixos-common.nix
        {
          system.configurationRevision = self.rev or null;
          system.extraSystemBuilderCmds = ''
            ln -sv ${self} $out/config${if self ? rev then "-${self.rev}" else ""}
          '';
        }
      ];
    };
  };
}
