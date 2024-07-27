{ pkgs, config, ... }:
{
  home-manager.users.${config.users.me} = {
    manual.html.enable = true;

    home.packages = [
      pkgs.man-pages
      pkgs.man-pages-posix
    ];

    programs.man.generateCaches = true;
  };

  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
}
