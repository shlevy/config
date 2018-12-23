{ runCommand }:
{
  compose = { provides, requires }: {
    requires.links.".config/systemd/user" = let
      snippets = [ "mkdir $out" ] ++ (map (name: ''
        mkdir $out/${name}.d
        ln -sv ${provides.overrides.${name}} $out/${name}.d/overrides.conf
      '') (builtins.attrNames provides.overrides));
    in runCommand "systemd-user" {} (builtins.concatStringsSep "\n" snippets);
  };
}
