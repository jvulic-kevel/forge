# Project: Forge

This repository, "Forge," is a streamlined Nix-based project for managing macOS systems and home configurations. It is specifically tailored to configure and support the single `apple` host (Apple Silicon / aarch64-darwin) using `nix-darwin` and `home-manager`.

## Project Overview

The project is structured around a single-host, fully modular, and self-contained design targeting macOS.

- **Nix Flakes:** The project entry point is `flake.nix`, which defines the dependencies (`nixpkgs`, `nix-darwin`, `home-manager`, `unstablepkgs`) and binds the final `darwinConfigurations.apple`.
- **Hosts:** The configuration for our target Apple Silicon machine is located under `hosts/apple/default.nix`, which serves as the primary system builder invoking `darwinSystem` and defining system and home-manager module compositions.
- **Encapsulated Modules:** Configuration modules are organized into self-contained subdirectories under `modules/` according to the service or tool they configure (e.g., `modules/fish/`, `modules/aerospace/`). Each subdirectory contains a `default.nix` module along with any adjacent, relevant config resources (like `.toml`, `.json`, or `.fish` files) loaded relative to that module.
- **Custom Packages:** Custom packages are declared in `pkgs/` (for example, `mcp-hub`) and automatically exposed to both nix-darwin and home-manager scopes via `mypkgs`.
- **Administrative Utilities:** All actions (applying configuration, updating inputs, garbage collection, and code verification) are driven by a simple, unified root `justfile`.

## Building and Running

Instead of custom wrappers, we use standard ecosystem tools combined with a root `justfile` to run all configuration and maintenance actions.

### `just` commands

- `just`: List all available commands.
- `just apply [switch|build]`: Builds and applies the system configuration. Defaults to `switch`. Use `command="build"` for dry-run/evaluation checks.
- `just update [input]`: Updates all flake inputs, or a specific input if `input="<name>"` is provided.
- `just test`: Fast evaluation and dry-run build verification of the complete host configuration to confirm that the entire codebase evaluates and compiles with zero errors.
- `just clean`: Cleans old profile generations, runs garbage collection, and optimises/deduplicates the Nix store.

## Development Conventions

- **Subdirectory Encapsulation:** Always organize modules according to the specific service or tool they encapsulate. Each module should have its own folder under `modules/` containing a `default.nix` that loads any adjacent configuration files (e.g. `modules/ghostty/config`, `modules/docker/docker.json`).
- **Namespace Option Hygiene:** Use the `forge` namespace for configuring module options (e.g. `forge.fish.enable = true;`).
- **Standard Special Arguments:** Use standard parameters (`pkgs`, `unstablepkgs`, `mypkgs`) to resolve system packages.
- **Verification before Push:** Always run `just test` before applying or committing changes. This guarantees that your changes contain no syntax errors, missing variables, or option conflicts across any of the imported modular packages.
