# Homebrew Module

This module manages all macOS software dependencies installed via **Homebrew** (including Taps, Brews, and Casks) natively through `nix-darwin`.

## First-Time Installation Notes & Manual Actions

When rebuilding and setting up this macOS environment for the first time, some graphical (GUI) applications installed via Casks cannot register their startup settings with macOS sandboxing until they are executed at least once by the user.

Therefore, **you must perform the following manual actions after your very first `just apply`**:

### 1. Launch AeroSpace
Open your application launcher (e.g. Spotlight/Raycast) or Finder and launch **AeroSpace.app** manually.
- On first launch, macOS may ask you to grant accessibility permissions.
- Inside AeroSpace, the configuration (`start-at-login = true`) will automatically register itself with Apple's native `SMAppService` so it starts cleanly on all subsequent logins.

### 2. Launch AeroSpaceBar
Launch **AeroSpaceBar.app** manually.
- Make sure to enable its launch-on-login setting in its settings panel if prompted.

### 3. Launch Raycast
Launch **Raycast.app** manually.
- Go through the initial welcome wizard.
- Inside Raycast Settings, make sure to enable **Launch on login** under General preferences so that it starts automatically in the future.

---

*Note: All background command-line daemons (like JankyBorders/`borders`) are fully automated and managed natively as persistent background services via `nix-darwin` (no manual start required).*
