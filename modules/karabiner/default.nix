{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.karabiner;
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
      home.file.".config/karabiner/assets/complex_modifications/linux_rules.json".source =
        ./linux_rules.json;
    };
  };
}
