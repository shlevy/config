# Copied from nixpkgs@997cc15602d75b2ce2be08694b8b37f9b0cfc1bc, modified to use the Blink version
{ lib, stdenv, fetchgit, zlib, protobuf, ncurses, pkg-config
, makeWrapper, perl, openssl, autoreconfHook, openssh, bash-completion
, withUtempter ? stdenv.isLinux && !stdenv.hostPlatform.isMusl, libutempter, git }:

stdenv.mkDerivation rec {
  pname = "mosh";
  version = "1.4.0+blink-17.3.0";

  src = fetchgit {
    url = "https://github.com/blinksh/mosh-server";
    # Work around https://github.com/NixOS/nixpkgs/issues/303326
    # rev = "${pname}-${version}";
    rev = "53d743afacd34a194ef552a273e70d2e3f28a5db";
    hash = "sha256-2b3nHyfbCmNWvESS8zhdTlY+PDrdn/7FytWlXqiiRaY=";
    deepClone = true;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper protobuf perl git ];
  buildInputs = [ protobuf ncurses zlib openssl bash-completion perl ]
    ++ lib.optional withUtempter libutempter;

  strictDeps = true;

  enableParallelBuilding = true;

  patches = [
    ./mosh/ssh_path.patch
    ./mosh/mosh-client_path.patch
    # Fix build with bash-completion 2.10
    ./mosh/bash_completion_datadir.patch
  ];

  postPatch = ''
    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
    # Don't let our patches skew the version info
    sed -is 's|describe --dirty|describe|' Makefile.am
  '';

  configureFlags = [ "--enable-completion" ]
    ++ lib.optional withUtempter "--with-utempter";

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    homepage = "https://mosh.org/";
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}
