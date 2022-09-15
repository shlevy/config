{ gimp }: {
  compose = { provides, requires }: {
    requires.package = gimp;
    requires.links.".config/GIMP" = "/home-persistent/shlevy/xdg/config/GIMP";
  };
}
