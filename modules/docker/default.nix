{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.docker;
in
{
  options.forge.docker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Docker configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".docker/config.json".source = ./docker.json;
    };
  };
}
