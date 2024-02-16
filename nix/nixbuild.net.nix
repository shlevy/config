{ lib, ... }: {
  nix.buildMachines = [
    { hostName = "eu.nixbuild.net";
      system = "x86_64-linux";
      maxJobs = 100;
      supportedFeatures = [ "benchmark" "big-parallel" ];
    }
  ];

  nix.settings = {
#    substituters = lib.mkAfter [ "ssh://eu.nixbuild.net" ];
    trusted-public-keys = [ "nixbuild.net/smart.contracts@iohk.io-1:s2PhQXWwsZo1y5IxFcx2D/i2yfvgtEnRBOZavlA8Bog=" ];
  };

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      PreferredAuthentications none
      User authtoken
      SendEnv token
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "/etc/nix/daemon-environment";
}
