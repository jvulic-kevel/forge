{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.ghostty;
in
{
  options.forge.ghostty = {
    enable = lib.mkEnableOption "Ghostty configuration.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/ghostty/config".source = ./config;
    };
  };
}
