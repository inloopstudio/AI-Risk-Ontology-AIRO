{pkgs}: {
  deps = [
    #pkgs.rubyPackages_3_3.railties
    pkgs.rubyPackages_3_3.puma
    pkgs.vim
    pkgs.yarn
    pkgs.libffi
    pkgs.readline
    pkgs.zlib
    pkgs.libyaml
    pkgs.openssl
    pkgs.git
    pkgs.nodejs
    pkgs.postgresql
    pkgs.sqlite
    pkgs.ruby_3_3
    pkgs.bison
    pkgs.flex
    pkgs.fontforge
    pkgs.makeWrapper
    pkgs.pkg-config
    pkgs.gnumake
    pkgs.gcc
    pkgs.libiconv
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
  ];
}