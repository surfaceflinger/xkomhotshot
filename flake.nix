{
  description = "Flake with module and a package for running xkom hotshot bot";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "armv7l-linux"
        "riscv64-linux"
        "x86_64-linux"
      ];

      imports = [ flake-parts.flakeModules.easyOverlay ];

      perSystem =
        {
          config,
          self',
          pkgs,
          ...
        }:
        {
          packages.xkomhotshot = pkgs.python3.pkgs.callPackage ./nix/package.nix { };
          packages.default = self'.packages.xkomhotshot;
          checks = config.packages;

          devShells.default = pkgs.mkShell { buildInputs = [ self'.packages.default ]; };
        };

      flake = {
        nixosModules.default = import ./nix/service.nix inputs;
      };
    };
}
