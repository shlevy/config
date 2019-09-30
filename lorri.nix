{ pkgs }: let
  lorri-src = builtins.extraBuiltins.fetch-git {
    url = "git://github.com/target/lorri";
    revision = "3beec759deee8b95b4febed03df0ef3c1b8ffff6";
    branch = "master";
  };
in {
  compose = { provides, requires }: {
    requires.package = import lorri-src { inherit pkgs; src = lorri-src; };

    requires.links.".cache/lorri" = "/home-persistent/shlevy/xdg/cache/lorri";
  };
}
