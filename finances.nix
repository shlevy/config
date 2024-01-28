{
  home-manager.users.shlevy = { pkgs, ... }: let
    ofxPython = pkgs.python3.withPackages (ps: [ ps.ofxtools ]);
  in {
    home.packages = [ pkgs.ledger pkgs.ledger-autosync ofxPython ];
    programs.emacs.extraPackages = epkgs: [ epkgs.ledger-mode ];
  };

  environment.variables.LEDGER_FILE = "/home/shlevy/Documents/financial/ledger";
}
