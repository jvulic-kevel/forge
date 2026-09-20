{
  description = "Tailored Darwin system configuration for Apple host.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, nixpkgs, nix-darwin, home-manager, nixpkgs-unstable, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.just
          ];
        };
      };

      flake = {
        darwinConfigurations = {
          apple =
            let
              system = "aarch64-darwin";
              pkgs = import nixpkgs { inherit system; };
              unstablepkgs = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              mypkgs = pkgs.callPackage ./pkgs { };
            in
            import ./hosts/apple {
              inherit nix-darwin home-manager system pkgs unstablepkgs mypkgs;
            };
        };
      };
    };
}
