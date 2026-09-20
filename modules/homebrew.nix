{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.homebrew;
in
{
  options.forge.homebrew = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Homebrew configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      enableFishIntegration = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
      };
      taps = [
        "nikitabobko/tap"
      ];
      casks = [
        "ghostty"
        "aerospace"
        "raycast"
        "google-chrome"
        "neovide-app"
      ];
    };
  };
}
