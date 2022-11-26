{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.shlevy = {
      home.stateVersion = "22.11";
    };
  };
}
