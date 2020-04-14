{ buildEnv }: {
  compose = { provides, requires }: let
    env = buildEnv {
      name = "home-env";
      paths = provides.packages;
      pathsToLink = [ "/bin" "/share/man" ];
    };
  in {
    requires.env.PATH = "${env}/bin:$PATH";
  };
}
