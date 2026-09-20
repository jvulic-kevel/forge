{ pkgs, ... }:
let
  mcp-hub = pkgs.callPackage ./mcp-hub { };
in
{
  inherit mcp-hub;
}
