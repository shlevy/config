{ config, ... }: {
  home-manager.users.${config.users.me} = { pkgs, ... }: {
    home.packages = [ pkgs.zotero ];

    programs.emacs = {
      extraPackages = epkgs: [ epkgs.citar epkgs.citar-org-roam ];

      extraConfig = ''
        (require 'citar)
        (citar-org-roam-mode)
      '';

      extraCustomize = ''
        (customize-set-variable 'org-cite-global-bibliography '("~/Documents/biblio.bib"))
        (customize-set-variable 'org-cite-insert-processor 'citar)
        (customize-set-variable 'org-cite-follow-processor 'citar)
        (customize-set-variable 'org-cite-activate-processor 'citar)
        (customize-set-variable 'citar-bibliography org-cite-global-bibliography)
        (customize-set-variable 'citar-org-roam-subdir "source")
      '';
    };
  };
}
