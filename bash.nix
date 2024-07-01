{
  home-manager.users.shlevy.programs.bash = {
    enable = true;

    enableVteIntegration = true;

    historyControl = [ "erasedups" "ignorespace" ];
  };
}
