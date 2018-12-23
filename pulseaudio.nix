{
  compose = { provides, requires }: {
    # TODO factor out config somehow
    requires.systemd-user-overrides."pulseaudio.service" = builtins.toFile "overrides.conf" ''
      [Service]
      Environment="PULSE_STATE_PATH=/home-persistent/shlevy/xdg/config/pulse"
    '';

    requires.links.".config/pulse" = "/home-persistent/shlevy/xdg/config/pulse";
  };
}
