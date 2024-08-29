{ lib, pkgs, config, ... }: {
  home-manager.users.${config.users.me} = {
    home.packages = with pkgs; [ mosh oscclip tmate ];
    programs.emacs = {
      extraPackages = epkgs: [ epkgs.clipetty ];
      extraConfig = ''
        (global-clipetty-mode)
      '';
    };
  };

  nixpkgs.overlays = lib.singleton (self: super: {
    mosh = self.callPackage ./remote/mosh.nix {};
  });

  services.openssh.enable = true;
}
