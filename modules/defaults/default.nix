{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.defaults;
in
{
  options.forge.defaults = {
    enable = lib.mkEnableOption "macOS system tuning, defaults, and security configurations";
  };

  config = lib.mkIf cfg.enable {
    # Keyboard configuration.
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    # Enable biometric sudo authentication using touch id.
    security.pam.services.sudo_local = {
      touchIdAuth = true; # fingerprint sudo
      reattach = true; # make touch id work inside multiplexers / terminal sessions
    };

    # MacOS system tuning.
    system.defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false; # do not automatically rearrange spaces based on most recent use
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv"; # default list view
        _FXShowPosixPathInTitle = true; # show path in finder window title
      };
      NSGlobalDomain = {
        # Low-latency key repeat (units are in 15ms blocks).
        InitialKeyRepeat = 10; # 150ms delay
        KeyRepeat = 1; # 15ms repeat speed

        "com.apple.swipescrolldirection" = false; # traditional mouse scroll direction
      };
    };
  };
}
