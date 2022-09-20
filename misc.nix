{ pkgs, inputs, ... }: {
  home-manager.users.shlevy.home.packages = with pkgs; [
    discord
    zoom-us
    jq
  ];
}
