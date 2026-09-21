{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.git;
in
{
  options.forge.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable DGit configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.git
      pkgs.lazygit
    ];

    home-manager.users.jvulic = { ... }: {
      programs.git = {
        enable = true;
        lfs.enable = true;
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
        settings = {
          user = {
            name = "Josip Vulic";
            email = "jvulic@kevel.com";
            signingKey= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFigqt9NEQAJPD5+YOY90eiBB2/hK8kASZJ5ycZg1Ok";
          };
          gpg = {
            format = "ssh";
            ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
          commit = {
            gpgSign = true;
          };
          init = {
            defaultBranch = "main";
          };
          pull = {
            rebase = true;
          };
          url = {
            "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
            };
          };
        };
      };
    };
  };
}
