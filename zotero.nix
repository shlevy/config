{
  home-manager.users.shlevy = { pkgs, ... }: {
    home.packages = [ pkgs.zotero ];
  };
}
