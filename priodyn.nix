{
  home-manager.users.shlevy = { pkgs, ... }: {
    programs.emacs = {
      extraPackages = epkgs: [
        (epkgs.trivialBuild rec {
          pname = "priodyn";
          version = "1.0.0-pre20231120";
          src = pkgs.fetchFromGitHub {
            owner = "shlevy";
            repo = "priodyn";
            rev = "77b55e840dc8e7caa61cf2702cfe6abacd2a4323";
            hash = "sha256-wABdjJ2quDVm/9+TzTSzevZyszszMnipVRFQ4MPS9A4=";
          };
          packageRequires = [ epkgs.org-roam ];
        })
      ];

      extraConfig = ''
        (require 'priodyn)
        (add-to-list 'org-tags-exclude-from-inheritance "project")
        (priodyn-manage-agenda)
      '';

      extraCustomize = ''
        (customize-set-variable 'priodyn-extra-agenda-files '("~/Documents/roam/main/validated_temporal_integration_system.org" "~/Documents/roam/main/queryable_finances.org" "~/Documents/roam/main/iog_handoff.org" "~/Documents/roam/main/how_to_think_about_current_events.org" "~/Documents/roam/main/introduction_to_writing.org" "~/Documents/roam/main/jasper_birthday_2023.org" "~/Documents/roam/main/household_maintenance.org" "~/Documents/roam/main/administrivia.org" "~/Documents/roam/main/social.org" "~/Documents/roam/main/uncategorized_tasks.org" "~/Documents/roam/main/nomia.org" "~/Documents/roam/main/parenting_articulation.org" "~/Documents/roam/main/objective_articulation_of_philosophy_incarnation.org" "~/Documents/roam/main/trademark_as_a_property_right.org" "~/Documents/roam/main/philosophy_incarnation_as_primary_claimant.org" "~/Documents/roam/main/philosophy_incarnation.org" "~/Documents/roam/main/paid_philosophy_incarnation.org" "~/Documents/roam/main/objectivism_seminar_y2q4_capitalism_and_aesthetics.org" "~/Documents/roam/main/itoe-course.org" "~/Documents/roam/project" "~/Documents/roam/main/tickler.org"  "~/Documents/roam/project/to-clean/income-yielding-portfolio" "~/Documents/roam/project/to-clean/income-yielding-portfolio/nomia-minimum-viable-incarnation" "~/Documents/roam/project/to-clean/income-yielding-portfolio/initial-prospectuses" "~/Documents/roam/project/to-clean/energy-maximization" "~/Documents/roam/project/to-clean/philosophically-objective-parenting-perfection" "~/Documents/roam/project/to-clean/philosophically-objective-parenting-perfection/elementary-education-secured" "~/Documents/roam/project/to-clean/IOG" "~/Documents/roam/project/to-clean/ARU" "~/Documents/roam/project/to-clean" "~/Documents/roam/project/to-clean/older"))
      '';
    };
  };
}
