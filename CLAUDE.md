# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Build and switch to the macOS nix-darwin configuration
darwin-rebuild switch --no-nom

# Build without switching (for testing)
darwin-rebuild build --no-nom

# Update all flake inputs
nix flake update

# Update a specific input
nix flake update nixpkgs-unstable

# NixOS hosts, run on the host itself
nixos-rebuild switch --flake .#jukebox

# matchbox is a Pi 3 and can't realistically build its own closure: build on jukebox, push it
nixos-rebuild switch --flake .#matchbox --target-host matchbox --build-host localhost --sudo

# SD card image for a fresh matchbox install (needs an aarch64-linux builder)
nix build .#matchbox-sd-image
```

## Architecture

This is a Nix flake that manages system configuration for macOS (via nix-darwin), NixOS, and other
Linux systems (via home-manager).

### Key Structure

- **`flake.nix`** - Main entry point defining inputs, outputs, overlays, and system configurations
- **`darwin/`** - nix-darwin modules for macOS system-level configuration
- **`linux/`** - NixOS modules: `common.nix` is shared by every NixOS host, the rest are per-host
- **`home/`** - home-manager modules for user-level configuration
- **`modules/`** - Reusable modules (`users.nix` is shared by darwin and NixOS, `nixos/` is NixOS-only)
- **`lib/`** - Helper functions including `mkDarwinSystem` and `mkNixosSystem`
- **`configs/`** - Application configs (Claude Code) symlinked for live editing
- **`overlays/`** - Nixpkgs overlays

### System Configurations

- **`darwinConfigurations.boombox`** - Primary macOS config, built with `lib.mkDarwinSystem`
- **`darwinConfigurations.githubCI`** - CI variant with homebrew disabled
- **`nixosConfigurations.nixos`** - Stock NixOS install, hardware config from `/etc/nixos`
- **`nixosConfigurations.jukebox`** - Gaming PC (AM5 / Ryzen 5 7600X / RTX 4070 SUPER): GNOME,
  proprietary NVIDIA driver, Steam, and Wake-on-LAN armed on the wired NIC
- **`nixosConfigurations.matchbox`** - Raspberry Pi 3: headless, aarch64, exists to run
  `wake-jukebox` over the point-to-point ethernet link to jukebox (both use wifi for internet).
  Gets `mekot.slimProfile` and a reduced set of home-manager modules
- **`homeConfigurations.mekot`** - Standalone home-manager config for Linux

### User Info Pattern

User info is defined once and referenced throughout:

1. Passed to `lib.mkDarwinSystem`/`lib.mkNixosSystem` as `username`, `fullName`, `email`,
   `nixConfigDirectory`
2. Set on `users.primaryUser` in the darwin and NixOS configs alike (`modules/users.nix`)
3. Available as `config.home.user-info` in all home-manager modules

Example usage in a home module:
```nix
{ config, ... }:
let
  inherit (config.home.user-info) email nixConfigDirectory;
in { ... }
```

### Live-Editable Configs

Files in `configs/` are symlinked via `mkOutOfStoreSymlink`, allowing edits without rebuild:
- `configs/claude/` → `~/.claude/` (CLAUDE-USER.md → CLAUDE.md, settings.json, commands, plugins, etc.)

**Claude Code settings** use a hybrid approach:
- **`managed-settings.json`** (Nix-generated at `/Library/Application Support/ClaudeCode/`):
  Has highest precedence. Contains only path-dependent settings needing `nixConfigDirectory`
  interpolation (`additionalDirectories`, nix-config permissions, `extraKnownMarketplaces`).
  Created by `darwin/claude-managed-settings.nix`.
- **`settings.json`** (user-editable symlink from `configs/claude/`):
  All other settings using portable `~` paths. Edit directly without rebuild.

### Package Version Overlays

Access packages from different nixpkgs channels via overlays:
```nix
pkgs.nixpkgs-master.some-package    # bleeding edge
pkgs.nixpkgs-unstable.some-package  # nixpkgs-unstable
pkgs.nixpkgs-stable.some-package    # stable release
```

## Common Tasks

**Add a package:** Edit `home/packages.nix`, add to the appropriate category's `inherit` block.

**Add a new home-manager module:**
1. Create `home/tool.nix` with the module configuration
2. Add `mekot-tool = import ./home/tool.nix;` to `homeManagerModules` in `flake.nix`
3. The module is automatically included via `attrValues self.homeManagerModules`

**Add a darwin module:** Same pattern in `darwin/` directory and `darwinModules` in flake.nix.

**Add a NixOS module:** Reusable ones go in `modules/nixos/` and `nixosModules` in flake.nix (every
NixOS host pulls in `attrValues self.nixosModules`). Anything host-specific belongs in that host's
own module under `linux/`.

**Iterate on Claude Code plugins:** Plugins in `configs/claude/plugins/` are symlinked but cached by Claude. After making changes, clear the cache and restart:
```bash
rm -rf ~/.claude/plugins/cache/user-plugins/<plugin-name>
# Then restart Claude Code
```

## Conventions

- Comments: avoid them unless the logic is genuinely non-obvious. When adding one, make it concise — no narrating what the code does, no multi-line explanations for a single thought.
- Follow nixpkgs code style
- Line length: 100 columns
- Section banners: `# Section name` followed by dashes to column 100, with a blank line before and after
- Module files named for their purpose (e.g., `git.nix`, `fish.nix`)
- Home-manager modules prefixed with `mekot-` in flake outputs
- Use `inherit` for clarity when pulling from attribute sets
- Extract repeated deep paths into `let`/`inherit` at the top of each file. If a dotted path like
  `config.home.homeDirectory`, `pkgs.stdenv.isDarwin`, or `lib.mkIf` appears two or more times in
  a file body, pull it into the `let` block (e.g., `inherit (config.home) homeDirectory;`). Single-use
  paths are fine inline — the goal is compactness when repetition adds noise

## Gotchas

- **Home-manager activation PATH:** Activation scripts run with a minimal PATH (bash, coreutils,
  findutils, etc.) — no `node`, `git`, or user-profile binaries. Use full nix store paths
  (e.g. `${pkgs.nodejs}/bin/npx`) or prepend to PATH explicitly.
- **`run --silence` hides errors:** Home-manager's `run --silence` redirects both stdout and
  stderr to `/dev/null`. When debugging activation scripts, temporarily remove `--silence` or
  use `run` without flags to see output. The generated script is at
  `~/.local/state/home-manager/gcroots/current-home/activate`.
- **nix-index comes prebuilt:** `nix-index-database` supplies the index, wired in through the
  home-manager module (`homeManagerModules.nix-index`), so `nix-index` never runs locally. Don't
  add `nix-index` or `comma` to any package list — the wrappers would collide. The upstream index
  is regenerated weekly, so `nix flake update` pulls a fresh ~90 MB fetch whenever it moves.
- **Placeholders in the new NixOS hosts:** `linux/jukebox/hardware-configuration.nix` is a stand-in
  until `nixos-generate-config` has run on the machine, `wiredInterface` in
  `linux/jukebox/default.nix` is a guess, and `linux/matchbox.nix` holds a dummy MAC and SSID.
  `linux/bigbox/hardware-configuration.nix` is likewise a stand-in (fake UUIDs) until bigbox is
  installed, and `isolatedCpus` in `linux/bigbox/default.nix` needs real core IDs from `lscpu -e`
  once it's up (2 physical cores per NUMA node, skipping CPU 0). These evaluate fine but won't work
  until they're filled in with real values.
