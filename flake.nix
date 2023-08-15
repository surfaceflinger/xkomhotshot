{
  description = "Flake with module and a package for running xkom hotshot bot";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlays.default = final: prev: rec {
        python3 = prev.python3.override {
          packageOverrides = final: prev: {
            xkomhotshot = final.callPackage ./nix/package.nix { };
          };
        };
        python3Packages = python3.pkgs;
      };

      packages = forAllSystems (system: {
        default = (import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }).python3Packages.xkomhotshot;
      });

      checks = forAllSystems (system: {
        build = self.packages.${system}.default;
      });

      nixosModules.default = import ./nix/service.nix { overlay = self.overlays.default; };
    };
}
