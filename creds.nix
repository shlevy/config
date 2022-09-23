{ pkgs, ... }: let
  creds = pkgs.runCommand "creds" {} ''
    ln -sv /home/shlevy/creds $out
  '';
in {
  home-manager.users.shlevy.home.file ={
    ".aws" = {
      source = "${creds}/aws";
    };
    ".ssh" = {
      source = "${creds}/ssh";
    };
    ".netrc" = {
      source = "${creds}/netrc";
    };
  };
}
