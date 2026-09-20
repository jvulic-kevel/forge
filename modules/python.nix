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
    enable = lib.mkEnableOption "Python configuration.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.python3
    ];
  };
}
