{
  nix-darwin,
  home-manager,
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
