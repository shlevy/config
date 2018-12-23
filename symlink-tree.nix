{ runCommand }:
{
  compose = { provides, requires }: {
    provides.run = let
      snippets = map (name: ''
        link_name="$out/${name}"
        mkdir --parents "$(dirname "$link_name")"
        ln --symbolic --no-target-directory ${provides.links.${name}} "$link_name"
      '') (builtins.attrNames provides.links);
    in runCommand provides.name {} (builtins.concatStringsSep "\n" snippets);
  };
}
