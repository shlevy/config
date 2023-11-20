{ inputs, ... }: let inherit (inputs) self; in {
  imports = [
    ./system-specific.nix

    ./configuration.nix
    ./docker.nix
    ./home-manager.nix
    ./btrbk.nix
    ./firmware.nix

    ./bash.nix
    ./emacs.nix
    ./git.nix
    ./man.nix
    ./mail.nix
    ./org-roam.nix
    ./org.nix
    ./org-pomodoro.nix
    ./priodyn.nix
    ./finances.nix
    ./citations.nix

    ./nix.nix
    ./haskell.nix
    ./development.nix

    ./creds.nix
    ./misc.nix
    ./no-nix-buffer.nix
  ];

  config = {
    system.configurationRevision = self.rev or null;
    system.extraSystemBuilderCmds = ''
      ln -sv ${./.} $out/config${if self ? rev then "-${self.rev}" else ""}
    '';
  };
}
