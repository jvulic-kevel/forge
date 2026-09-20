{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.core;
in
{
  options.forge.core = {
    enable = lib.mkEnableOption "Core Darwin system and user base configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vim
      pkgs.git

      # astronvim & mason requirements
      pkgs.neovim
      pkgs.lazygit
      pkgs.nodejs
      pkgs.gnumake
      pkgs.gdu
      pkgs.bottom
    ];

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

    system.stateVersion = 6;

    home-manager.users.jvulic = { pkgs, ... }: {
      home.username = "jvulic";
      home.homeDirectory = "/Users/jvulic";
      home.stateVersion = "26.05";
      home.enableNixpkgsReleaseCheck = true;

      programs.home-manager.enable = true;

      # SUPRESS: programs.man.generateCaches has no effect when programs.man.package is null
      programs.man.generateCaches = false;

      # Session variables.
      home.sessionVariables = {
        EDITOR = "nvim";
        GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
      };

      # Direnv configuration.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
