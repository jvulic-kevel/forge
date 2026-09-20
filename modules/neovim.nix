{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.neovim;
in
{
  options.forge.neovim = {
    enable = lib.mkEnableOption "Neovim editor configuration and astronvim/mason requirements";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.neovim
      pkgs.vim

      # astronvim & mason requirements
      pkgs.nodejs
      pkgs.gnumake
      pkgs.gdu
      pkgs.bottom
    ];

    home-manager.users.jvulic = { ... }: {
      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}
