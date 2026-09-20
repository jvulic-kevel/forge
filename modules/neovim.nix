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
    enable = lib.mkEnableOption "Neovim configuration.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.neovim
      pkgs.vim

      # astronvim & mason requirements
      pkgs.nodejs
      pkgs.gnumake
      pkgs.gcc
      pkgs.unzip
      pkgs.wget
      pkgs.gzip
      pkgs.gnutar
      pkgs.python3
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
