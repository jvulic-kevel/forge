{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.borders;
in
{
  options.forge.borders = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable JankyBorders configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/borders/bordersrc" = {
        source = ./bordersrc;
        executable = true;
      };
    };
  };
}
