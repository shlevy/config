{ runCommand, writeScriptBin, bash }: { dotfiles, other-files ? {} }:
  let dotfile-names = builtins.attrNames (builtins.readDir dotfiles);
      to-dotfile-spec = base:
        { name = ".${base}";
          value = dotfiles + "/${base}";
        };
      dotfile-specs =
        builtins.listToAttrs (map to-dotfile-spec dotfile-names);
      all-files = dotfile-specs // other-files;
      all-file-names = builtins.attrNames all-files;
      static = runCommand "home-static" {} ''
        mkdir $out
        ${builtins.concatStringsSep "\n" (map (source: ''
            mkdir -p $(dirname $out/${source})
            ln -svT ${all-files.${source}} $out/${source}
          '') all-file-names)}
      '';
  in writeScriptBin "setup-home" ''
    #!${bash}/bin/bash
    run=$XDG_RUNTIME_DIR/setup-home
    mkdir -p $run
    ln -sfT ${static} $run/home-static
    echo "${builtins.concatStringsSep "\n" all-file-names}" | \
      sort > $run/tmp-manifest
    if [ -e $run/manifest ]; then
      new=$(comm -23 $run/tmp-manifest $run/manifest)
      old=$(comm -13 $run/tmp-manifest $run/manifest)
    else
      new=$(cat $run/tmp-manifest)
      old=
    fi
    for file in $new; do
      mkdir -p $(dirname $HOME/$file)
      ln -sfT $run/home-static/$file $HOME/$file
    done
    for file in $old; do
      unlink $HOME/$file
    done
  ''
