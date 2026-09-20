{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.forge.fish;
in
{
  options.forge.fish = {
    enable = lib.mkEnableOption "Fish configuration.";
  };

  config = lib.mkIf cfg.enable {
    # System packages needed for yazi/fzf features.
    environment.systemPackages = [
      pkgs.fzf
      pkgs.fd
      pkgs.bat

      # yazi preview dependencies
      pkgs.file
      pkgs.ffmpegthumbnailer
      pkgs.unar
      pkgs.jq
      pkgs.poppler-utils
      pkgs.ripgrep
      pkgs.zoxide
    ];

    home-manager.users.jvulic = { pkgs, ... }: {
      # Fish configuration.
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting

          # If Tide is not initialized, initialize it with lean defaults.
          if not set -q tide_left_prompt_items
            source (functions --details _tide_sub_configure)
            _load_config lean
            _tide_finish
          end

          # Load custom abbreviations.
          _abbr_vim
          _abbr_kube
          _abbr_mount

          # Ensure homebrew binaries are in PATH.
          if test -d /opt/homebrew/bin
            fish_add_path --prepend --global /opt/homebrew/bin
          end
        '';
        plugins = [
          {
            name = "tide";
            src = pkgs.fetchFromGitHub {
              owner = "IlanCosman";
              repo = "tide";
              rev = "v6.2.0";
              sha256 = "sha256-1ApDjBUZ1o5UyfQijv9a3uQJ/ZuQFfpNmHiDWzoHyuw=";
            };
          }
          {
            name = "fzf";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "v11.0";
              sha256 = "sha256-H7HgYT+okuVXo2SinrSs+hxAKCn4Q4su7oMbebKd/7s=";
            };
          }
          {
            name = "done";
            src = pkgs.fetchFromGitHub {
              owner = "franciscolourenco";
              repo = "done";
              rev = "1.21.1";
              sha256 = "sha256-GZ1ZpcaEfbcex6XvxOFJDJqoD9C5out0W4bkkn768r0=";
            };
          }
          {
            name = "forgit";
            src = pkgs.fetchFromGitHub {
              owner = "wfxr";
              repo = "forgit";
              rev = "26.09.1";
              sha256 = "sha256-02w+BGrRDEFWLtH6tniiTgs+FHmghiHn9FMxO+U4wrI=";
            };
          }
        ];
      };

      # Dircolors.
      programs.dircolors = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          OTHER_WRITABLE = "01;36";
          STICKY_OTHER_WRITABLE = "01;34";
        };
      };

      # Yazi terminal file manager.
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableFishIntegration = true;
        enableBashIntegration = true;
      };

      home.file.".config/fish/functions/_abbr_kube.fish".source = ./_abbr_kube.fish;
      home.file.".config/fish/functions/_abbr_mount.fish".source = ./_abbr_mount.fish;
      home.file.".config/fish/functions/_abbr_vim.fish".source = ./_abbr_vim.fish;
      home.file.".config/fish/functions/fish_user_key_bindings.fish".source =
        ./fish_user_key_bindings.fish;
    };
  };
}
