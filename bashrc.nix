{ writeText }: {
  compose = { provides, requires }: {
    requires.links.".bashrc" = writeText "bashrc"
      provides.bashrc;
  };
}
