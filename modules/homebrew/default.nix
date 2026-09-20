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
        "rdrkr/tap"
        "FelixKratz/formulae"
      ];
      brews = [
        {
          name = "borders";
          restart_service = "always";
          start_service = true;
        }
      ];
      casks = [
        "ghostty"
        "aerospace"
        "aerospacebar"
        "raycast"
        "google-chrome"
        "neovide-app"
        "zoom"
        "slack"
      ];
    };
  };
}
