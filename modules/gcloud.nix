{
  config,
  lib,
  ...
}:
let
  cfg = config.forge.gcloud;
in
{
  options.forge.gcloud = {
    enable = lib.mkEnableOption "Google Cloud configuration.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jvulic = { ... }: {
      home.sessionVariables = {
        GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
      };
    };
  };
}
