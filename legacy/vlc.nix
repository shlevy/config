{ vlc }: {
  compose = { provides, requires }: {
    requires.package = vlc;
    requires.links.".config/vlc" = "/home-persistent/shlevy/xdg/config/vlc";
  };
}
