{ buildEnv, runCommand }: { paths ? [], env ? {} }:
  let env-support = runCommand "env-support" {} ''
    mkdir -p $out/etc
    cat >> $out/etc/env-support <<EOF
    ${builtins.concatStringsSep "\n" (map (var:
      "export ${var}=${env.${var}}") (builtins.attrNames env))}
    EOF
  '';
  in buildEnv
    { name = "user-env";
      paths = [ env-support ] ++ paths;
    }
