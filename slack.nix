{ slack }: {
  compose = { provides, requires }: {
    requires.package = slack;
    requires.links.".config/Slack" = "/home-persistent/shlevy/xdg/config/Slack";
  };
}
