{
  home-manager.users.shlevy.programs.bash = {
    enable = true;

    historyControl = [ "erasedups" "ignorespace" ];
  };

  programs.bash.undistractMe = {
    enable = true;

    playSound = true;
  };
}
