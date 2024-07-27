{
  home-manager.users.shlevy.programs.git = {
    userName = "Shea Levy";
    userEmail = "shea@shealevy.com";
    signing.key = "5C0BD6957D86FE27";

    extraConfig.sendemail = {
      smtpencryption = "ssl";
      smtpserver = "mail.hover.com";
      smtpuser = "shea@shealevy.com";
      smtpserverport = 465;
    };
  };
}
