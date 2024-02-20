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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEV4YLEr/vOvWzkp4wTZUvEiXKoxSIU1YGrSvOZYZyN6 shlevy@avp"
  ];
}
