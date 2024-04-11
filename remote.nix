{ lib, pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [ mosh gnome.gnome-remote-desktop oscclip ];
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.clipetty ];
      extraConfig = ''
        (global-clipetty-mode)
      '';
    };

    programs.tmux = {
      enable = true;
      extraConfig = ''
        set-option -g allow-passthrough on
        set-option -g set-clipboard on
        set-option -g terminal-features ',vscode-direct:clipboard'
      '';
      terminal = "tmux-direct";
    };
  };

  nixpkgs.overlays = lib.singleton (self: super: {
  });
  services.openssh.enable = true;
  users.users.shlevy.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCHdILXJXPGYkjB8QbX246cRT9jLNZq0P8a9+r14Xm6pjX9r0Uj0o+b0zysZR+GcupwDZ9/GkGiKm5LfB9xgP48= shlevy@avp.shealevy.com"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHAvB4QK4QciFSJBeNEw+bwXwvTMPRngi+Kl1a7COsnY4umcgd4vLEDRUFhjyUy9VpG5VoNXWPdPAwTxiqLlzZk= shlevy@ipad.shealevy.com"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNBZvFH+Km/bmaFGeB+rWjllbAFO/yLIgSKFxaVW1foRTprTWsGwQTjzZhBT9BatmOtPPBCEnTY+BCCe0P3gm58= shlevy@iphone.shealevy.com"
  ];

  services.tailscale.enable = true;
}
