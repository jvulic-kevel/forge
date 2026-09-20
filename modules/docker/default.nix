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
    enable = lib.mkEnableOption "Docker configuration and credentials helpers";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".docker/config.json".source = ./docker.json;
    };
  };
}
