{ config, ... }: {
  home-manager.users.${config.users.me}.programs.bash = {
    enable = true;

    enableVteIntegration = true;

    historyControl = [ "erasedups" "ignorespace" ];
  };
}
