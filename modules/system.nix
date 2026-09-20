{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.system;
in
{
  options.forge.system = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable System configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.jvulic = {
      home = "/Users/jvulic";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGdXDo+F2+TVAwH3CLJnK2SUIJR/6HvBeHEcfQbYxjk cardno:37_277_509"
      ];
    };

    system.primaryUser = "jvulic";

    # Enable openssh server.
    services.openssh.enable = true;

    # Disable nix-darwin's management of the nix daemon to prevent
    # conflicts with determinate nix.
    nix.enable = false;

    # Shell configuration.
    programs.fish.enable = true;
    programs.zsh.enable = true; # default shell, required for bootstrapping
    environment.shells = [ pkgs.fish ];

    # Networking configuration.
    networking = {
      hostName = "apple";
      computerName = "apple";
      localHostName = "apple";
    };

    # Auto-start AeroSpaceBar at login using native launchd user agent.
    launchd.user.agents.aerospacebar = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/open" "-g" "-a" "AeroSpaceBar" ];
        RunAtLoad = true;
      };
    };

    system.stateVersion = 6;

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
        InitialKeyRepeat = 15; # 225ms delay
        KeyRepeat = 1; # 15ms repeat speed
      };
    };

    home-manager.users.jvulic = { ... }: {
      home.username = "jvulic";
      home.homeDirectory = "/Users/jvulic";
      home.stateVersion = "26.05";
      home.enableNixpkgsReleaseCheck = true;

      programs.home-manager.enable = true;

      # Suppress "programs.man.generateCaches has no effect when programs.man.package is null".
      programs.man.generateCaches = false;
    };
  };
}
