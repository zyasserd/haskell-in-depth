{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ghcVersion = "96";
      ghc = "ghc${ghcVersion}";
      haskellPkgs = pkgs.haskell.packages.${ghc};

    in {
      devShells.${system}.default = haskellPkgs.shellFor {
        # packages is used differently here compared to other devShells.
        # Typical usage is: hpkgs: [ (hpkgs.callPackage ./my-project.nix { }) ].
        packages = hpkgs: [ ];

        nativeBuildInputs = [
          haskellPkgs.haskell-language-server
          pkgs.cabal-install
          # pkgs.cabal2nix
          pkgs.stylish-haskell
        ];
      };
    };
}
