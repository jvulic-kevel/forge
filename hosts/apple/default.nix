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
    (
      { ... }:
      {
        forge = {
          core.enable = true;
          defaults.enable = true;
          homebrew.enable = true;
          fish.enable = true;
          git.enable = true;
          docker.enable = true;
          mcphub.enable = true;
          ghostty.enable = true;
          aerospace.enable = true;
        };
      }
    )
  ];
}
