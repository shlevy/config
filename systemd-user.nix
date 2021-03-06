{ runCommand }:
{
  compose = { provides, requires }: {
    requires.links.".config/systemd/user" = let
      snippets = [ "mkdir $out" ] ++ (map (name: ''
        mkdir $out/${name}.d
        ln -sv ${provides.systemd-user-overrides.${name}} $out/${name}.d/overrides.conf
      '') (builtins.attrNames provides.systemd-user-overrides));
    in runCommand "systemd-user" {} (builtins.concatStringsSep "\n" snippets);
  };
}
