{
  home-manager.users.shlevy = { pkgs, ... }: {
    home.packages = [ pkgs.ledger pkgs.ledger-autosync pkgs.python3Packages.ofxtools ];
    programs.emacs.extraPackages = epkgs: [ epkgs.ledger-mode ];
  };

  environment.variables.LEDGER_FILE = "/home/shlevy/Documents/financial/ledger";
}
