# Claude Code configuration with hybrid settings and 1MCP aggregator.
#
# Settings architecture:
# - managed-settings.json (Nix-generated at /Library/Application Support/ClaudeCode/):
#   Path-dependent settings needing nixConfigDirectory. See darwin/claude-managed-settings.nix.
# - settings.json (symlinked from configs/claude/): All other settings. Edit without rebuild.

{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;

  claudeDir = "${nixConfigDirectory}/configs/claude";
in
{
  # Symlinked for live editing (no rebuild needed)
  home.file = {

    ".claude/settings.json".source = mkOutOfStoreSymlink "${claudeDir}/settings.json";
    ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${claudeDir}/CLAUDE-USER.md";
    ".claude/agents".source = mkOutOfStoreSymlink "${claudeDir}/agents";
    ".claude/rules".source = mkOutOfStoreSymlink "${claudeDir}/rules";
    ".claude/hooks".source = mkOutOfStoreSymlink "${claudeDir}/hooks";
    ".claude/statusline.sh".source = mkOutOfStoreSymlink "${claudeDir}/statusline.sh";
  };
}
