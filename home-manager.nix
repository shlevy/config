{ home-manager, lib, ... }:
{
  imports = [ home-manager.nixosModules.home-manager ];

  options = {
    users.me = lib.mkOption {
      description = "The username of the human user of the system";
      type = lib.types.str;
      default = "shlevy";
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
