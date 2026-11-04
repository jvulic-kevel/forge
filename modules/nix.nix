{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.nix;
in
{
  options.forge.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Nix configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Determinate Nix runs the Nix daemon and owns /etc/nix/nix.conf. Its module writes these
    # settings to /etc/nix/nix.custom.conf, and turns off nix-darwin's management of Nix.
    determinateNix = {
      enable = true;
      customSettings = {
        # Lets jvulic pass restricted settings to the daemon per command, such as a build's
        # environment.
        trusted-users = [
          "root"
          "jvulic"
        ];
        # Lets a trusted user give a fixed-output build environment variables, such as a
        # registry token, with `impure-env`.
        extra-experimental-features = [ "configurable-impure-env" ];
      };
    };
  };
}
