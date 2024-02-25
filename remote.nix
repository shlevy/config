{ lib, pkgs, ... }: {
  home-manager.users.shlevy = {
    home.packages = with pkgs; [ mosh gnome.gnome-remote-desktop oscclip tmux ];
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.clipetty ];
      extraConfig = ''
        (global-clipetty-mode)
      '';
    };
  };

  nixpkgs.overlays = lib.singleton (self: super: {
    gnome = super.gnome.overrideScope (self: super: {
      gnome-remote-desktop = lib.overrideDerivation super.gnome-remote-desktop (drv: {
        buildInputs = drv.buildInputs ++ [
          pkgs.libvncserver.dev
        ];
        mesonFlags = drv.mesonFlags ++ [
          "-Dvnc=true"
        ];
      });
    });
  });
  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 5900 ];
  networking.firewall.allowedUDPPortRanges = lib.singleton {
    from = 60001;
    to = 60999;
  };
  services.openssh.enable = true;
  users.users.shlevy.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCHdILXJXPGYkjB8QbX246cRT9jLNZq0P8a9+r14Xm6pjX9r0Uj0o+b0zysZR+GcupwDZ9/GkGiKm5LfB9xgP48= shlevy@avp.shealevy.com"
  ];
}
