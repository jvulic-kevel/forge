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
    enable = lib.mkEnableOption "Declarative Homebrew package management on macOS";
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
        "ghostty" # modern gpu-accelerated terminal
        "aerospace" # sway-style tiling window manager
        "google-chrome" # primary browser
        "neovide" # modern GUI for Neovim
      ];
    };
  };
}
