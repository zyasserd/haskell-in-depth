{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # TODO: what is the best practise for this?

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          # Errors:
          # - ghc810
          #     - `cabal build` -> requires GHC2021 which is not supported
          # - pkgs.haskell.packages.ghc810.ghcWithPackages
          #     - nix error -> build failed semaphore
          # - pkgs.haskell.packages.ghc{947,982,964}
          #     - nix error -> build from scratch

          (pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [
            cabal-install
            haskell-language-server
            stylish-haskell
          ]))
          
          # FIXME: figure out a way to automate this
          # required for some package (which?) in `executable suntimes`
          pkgs.zlib          
        ];

        # Change the prompt to show that you are in a devShell
        shellHook = "export PS1='\\e[1;34mHASK ❯ \\e[0m'";
      };
    };
}
