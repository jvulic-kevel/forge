{
  nix-darwin,
  home-manager,
  determinate,
  system,
  pkgs,
  unstablepkgs,
  mypkgs,
  ...
}:
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit unstablepkgs mypkgs;
  };
  modules = [
    ../../modules
    determinate.darwinModules.default
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit unstablepkgs mypkgs;
        };
      };
    }
  ];
}
