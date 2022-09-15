{ slack }: {
  compose = { provides, requires }: {
    requires.package = slack;
  };
}
