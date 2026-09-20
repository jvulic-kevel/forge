{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.golang;
in
{
  options.forge.golang = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Golang configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.go
      pkgs.gopls
      pkgs.gotools
      pkgs.go-tools
    ];

    home-manager.users.jvulic = { ... }: {
      home.sessionVariables = {
        GOPATH = "$HOME/go";
        GOBIN = "$HOME/go/bin";
      };
      home.sessionPath = [
        "$HOME/go/bin"
      ];
    };
  };
}
