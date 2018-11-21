{
  compose = { provides, requires }: {
    requires.env.PATH = builtins.concatStringsSep ":" (map (p: "${p}/bin") provides.packages);
  };
}
