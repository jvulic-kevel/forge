{
  config,
  lib,
  pkgs,
  mypkgs,
  ...
}:
let
  cfg = config.forge.mcphub;
in
{
  options.forge.mcphub = {
    enable = lib.mkEnableOption "MCP Hub configuration.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # Custom MCP Hub package
      mypkgs.mcp-hub

      # Google Chrome debugging for MCP.
      (pkgs.writeShellScriptBin "google-chrome-mcp" ''
        exec "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
          --remote-debugging-port=9222 \
          --user-data-dir="$HOME/.config/google-chrome-mcp" \
          --no-first-run \
          --no-default-browser-check \
          "$@"
      '')
    ];

    home-manager.users.jvulic = { config, lib, ... }: {
      # MCP Hub configuration files and templates.
      home.file.".config/mcphub/mcp_settings.json.template".text = builtins.toJSON {
        mcpServers = {
          chrome-devtools = {
            command = "npx";
            args = [
              "-y"
              "chrome-devtools-mcp"
              "--browserUrl=http://127.0.0.1:9222"
            ];
          };
        };
        systemConfig = {
          routing = {
            sessionRebuild = true;
          };
        };
      };

      home.activation.applyMcphubSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        mkdir -p "${config.home.homeDirectory}/.config/mcphub"
        TEMPLATE="${config.home.homeDirectory}/.config/mcphub/mcp_settings.json.template"
        TARGET="${config.home.homeDirectory}/.config/mcphub/mcp_settings.json"
        if [ ! -f "$TARGET" ]; then
          cp -f "$TEMPLATE" "$TARGET"
          chmod 644 "$TARGET"
        fi
      '';

      launchd.enable = true;
      launchd.agents.mcphub = {
        enable = true;
        config = {
          ProgramArguments = [ "${mypkgs.mcp-hub}/bin/mcp-hub" ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/Users/jvulic/Library/Logs/mcp-hub.log";
          StandardErrorPath = "/Users/jvulic/Library/Logs/mcp-hub.log";
          EnvironmentVariables = {
            ADMIN_PASSWORD = "admin";
          };
        };
      };
    };
  };
}
