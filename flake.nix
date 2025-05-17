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
          src = self;
          inherit buildInputs;
          
          configurePhase = ''
            autoreconf
            ./configure
          '';
          
          buildPhase = ''
            make all_cli all_lib
          '';

          installPhase = ''
            make install_cli install_lib prefix=$out
          '';
        };
      in {
        packages.default = hfsutils;
        
        devShells.default = pkgs.mkShell {
          packages = buildInputs;
          inputsFrom = [ hfsutils ];
        };
      });
}
