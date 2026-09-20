{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.direnv;
in
{
  options.forge.direnv = {
    enable = lib.mkEnableOption "Direnv configuration.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
