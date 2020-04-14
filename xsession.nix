{ writeShellScriptBin }:
{
  compose = { provides, requires }: {
    # TODO more security, systemd backend?
    requires.links.".xsession" = let
      env-snippets = map (name:
        "export ${name}=${provides.env.${name}}"
      ) (builtins.attrNames provides.env);
    in "${writeShellScriptBin "xsession" ''
      export PATH="$HOME/env/bin:$PATH"
      export MANPATH="$HOME/env/share/man:"
      ${builtins.concatStringsSep "\n" env-snippets}
      ${builtins.concatStringsSep "\n" provides.oneshots}
      exec ${provides.wmcmd}
    ''}/bin/xsession";
  };
}
