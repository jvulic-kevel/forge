{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.aerospace;
in
{
  options.forge.aerospace = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable AeroSpace configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/aerospace/aerospace.toml".source = ./aerospace.toml;
    };
  };
}
