{ buildEnv }: {
  compose = { provides, requires }: {
    requires.env = buildEnv {
      name = "home-env";
      paths = provides.packages;
      pathsToLink = [ "/bin" "/share/man" ];
    };
  };
}
