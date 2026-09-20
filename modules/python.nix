{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.python;
in
{
  options.forge.python = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Python configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.python3
    ];
  };
}
