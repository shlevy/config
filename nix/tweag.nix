{
  nix.buildMachines = [
    {
      hostName = "build01.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/home/shlevy/creds/ssh/id-tweag-builder";
      system = "x86_64-linux";
      supportedFeatures = [ "big-parallel" "kvm" "nixos-test" ];
    }
    {
      hostName = "build02.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/home/shlevy/creds/ssh/id-tweag-builder";
      systems = ["aarch64-darwin" "x86_64-darwin"];
      supportedFeatures = [ "big-parallel" ];
    }
  ];
}
