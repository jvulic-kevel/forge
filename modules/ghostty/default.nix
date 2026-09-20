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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Ghostty configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/ghostty/config".source = ./config;
    };
  };
}
