{
  description = "package hfsutil";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Configuration du projet
        repoUrl = "https://github.com/targetdisk/hfsutils.git";
        repoRev = "9aeaf911d40d8f2abbfe5ca6db2d5b873bc149d2";
        src = pkgs.fetchgit {
          url = repoUrl;
          rev = repoRev;
          sha256 = "sha256-XGZRRTHhzjvfiOANzArPFnHyx6DvbT/JXaMOOgOhtGs="; # Mettre à jour après premier build
        };
        
        # Dépendances du projet
        buildInputs = with pkgs; [
          autoconf
          automake
          libtool
          gnumake
          gcc
        ];
        
        # La derivation pour notre projet
        hfsutils = pkgs.stdenv.mkDerivation {
          pname = "hfsutils";
          version = "3.2.6";
          inherit src buildInputs;
          
          configurePhase = ''
            autoreconf
            ./configure
          '';
          
          buildPhase = ''
            make install prefix=$out
            cd libhfs
            make install prefix=$out
          '';

          #installPhase = ''
          #  mkdir $out/lib
          #  cp libhfs/libhfs.a $out/lib
          #  cp libhfs/librsrc.a $out/lib
          #  mkdir $out/include
          #'';
        };
      in {
        packages.default = hfsutils;
        
        devShells.default = pkgs.mkShell {
          packages = buildInputs;
          inputsFrom = [ hfsutils ];
        };
      });
}
