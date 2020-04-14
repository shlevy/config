{ runCommand, writeShellScriptBin, jq }: let
  homectl = writeShellScriptBin "homectl" ''
    set -euo pipefail
    if [ $# -ne 3 ]; then
      echo "Usage: $0 TARGET HOME STATE" >&2
      exit 1
    fi

    declare -r jq="${jq}/bin/jq"
    declare -r target="$1"
    declare -r home="$2"
    declare -r state="$3"

    for link in $("$jq" -r 'map(@base64) | .[]' < "$target/v1/manifest")
    do
      real_link="$(echo "$link" | base64 --decode)"
      mkdir --parents "$(dirname "$home/$real_link")"
      ln --symbolic --force --no-target-directory "$state/active/v1/links/$real_link" "$home/$real_link"
    done

    ln --symbolic --force --no-target-directory "$state/active/v1/env" "$home/env"

    ln --symbolic --force --no-target-directory "$target" "$state/active"
  '';
in {
  compose = { provides, requires }: {
    provides.run = let
      link-names = builtins.attrNames provides.links;
      snippets = map (name: ''
        link_name="$out/v1/links/${name}"
        mkdir --parents "$(dirname "$link_name")"
        ln --symbolic --no-target-directory ${provides.links.${name}} "$link_name"
      '') link-names;
    in runCommand provides.name {
      manifest = builtins.toJSON link-names;
      passAsFile = [ "manifest" ];
    } (''
    mkdir --parents $out/v1
    mv $manifestPath $out/v1/manifest
    mkdir -p $out/bin
    ln -sv ${homectl}/bin/homectl $out/bin/homectl
    ln -sv ${provides.env} $out/v1/env
    '' + (builtins.concatStringsSep "\n" snippets));
  };
}
