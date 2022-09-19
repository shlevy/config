{ pkgs, inputs, ... }: let
  pkgs-discord = import inputs.nixpkgs-discord {
    inherit (pkgs) system config;
  };
in {
  home-manager.users.shlevy.home.packages = with pkgs; [
    pkgs-discord.discord
    zoom-us
  ];
}
