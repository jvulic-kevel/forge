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
    enable = lib.mkEnableOption "Declarative Git configuration and git utilities";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.git
      pkgs.lazygit
    ];

    home-manager.users.jvulic = { ... }: {
      programs.git = {
        enable = true;
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
        settings = {
          user = {
            name = "Josip Vulic";
            email = "jvulic@kevel.com";
          };
          gpg = {
            format = "ssh";
            ssh.program = "/usr/bin/ssh-keygen";
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
