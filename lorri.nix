{ pkgs }: let
  lorri-src = builtins.extraBuiltins.fetch-git {
    url = "git@github.com:tweag/lorri";
    revision = "0ae6642c041b5b95a908186a01be6fa94d4d91c6";
    branch = "master";
  };
in {
  compose = { provides, requires }: {
    requires.package = import lorri-src { inherit pkgs; src = lorri-src; };

    requires.links.".cache/lorri" = "/home-persistent/shlevy/xdg/cache/lorri";
  };
}
