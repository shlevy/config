{
  users = {
    mutableUsers = false;
    users.shlevy = {
      description = "Shea Levy";
      extraGroups = [ "wheel" "input" "scanner" "lp" "docker" "dialout" "networkmanager" ];
      hashedPassword = "$6$NLWzl6guBhE.jNG$N9gwNDVLXFs5DcVZAalktWYNfYYad9zWpN4ngKJdTMiSEhfIQ0cPfExk5xLJnDApTK0EqvYcIeaNkAl./aAJx1";
      isNormalUser = true;
      uid = 1000;
    };
  };
}
