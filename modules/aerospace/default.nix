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
    enable = lib.mkEnableOption "AeroSpace window manager configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/aerospace/aerospace.toml".source = ./aerospace.toml;
    };
  };
}
