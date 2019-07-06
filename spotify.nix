{ spotify }: {
  compose = { provides, requires }: {
    requires.package = spotify;
    requires.links.".config/spotify" = "/home-persistent/shlevy/xdg/config/spotify";
    requires.links.".cache/spotify" = "/home-persistent/shlevy/xdg/cache/spotify";
    requires.links.".cache/mesa_shader_cache" = "/home-persistent/shlevy/xdg/cache/mesa_shader_cache";
  };
}
