{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.karabiner;

  dz60Rules = import ./dz60_rules.nix;
in
{
  options.forge.karabiner = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Karabiner-Elements configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.file.".config/karabiner/assets/complex_modifications/dz60_rules.json".text =
        builtins.toJSON dz60Rules;
    };
  };
}
