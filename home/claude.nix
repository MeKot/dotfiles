# Claude Code configuration with hybrid settings and 1MCP aggregator.
#
# Settings architecture:
# - managed-settings.json (Nix-generated at /Library/Application Support/ClaudeCode/):
#   Path-dependent settings needing nixConfigDirectory. See darwin/claude-managed-settings.nix.
# - settings.json (symlinked from configs/claude/): All other settings. Edit without rebuild.

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  inherit (config.home.user-info) nixConfigDirectory;

  claudeDir = "${nixConfigDirectory}/configs/claude";

  # Configuration ----------------------------------------------------------------------------------
  # Edit these values to customize your setup. Everything below is implementation.

  # External skills from skills.sh, installed via activation script.
  # Format: "owner/repo --skill skill-name"
  externalSkills = [
    "anthropics/skills --skill pdf"
    "anthropics/skills --skill docx"
  ];

in
lib.mkMerge [
  {

    home.file = {

      # Symlinked for live editing (no rebuild needed)
      ".claude/settings.json".source = mkOutOfStoreSymlink "${claudeDir}/settings.json";
      ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${claudeDir}/CLAUDE-USER.md";
      ".claude/skills".source = mkOutOfStoreSymlink "${claudeDir}/skills";
      ".claude/agents".source = mkOutOfStoreSymlink "${claudeDir}/agents";
      ".claude/rules".source = mkOutOfStoreSymlink "${claudeDir}/rules";
      ".claude/hooks".source = mkOutOfStoreSymlink "${claudeDir}/hooks";
      ".claude/statusline.sh".source = mkOutOfStoreSymlink "${claudeDir}/statusline.sh";
    };

    # External skills ------------------------------------------------------------------------------

    # Nuke and repave on each activation. Uses direct file removal instead of `skills remove`
    # (which has interactive TUI prompts that hang under home-manager's non-interactive activation).
    home.activation.installClaudeSkills =
      let
        npx = "${pkgs.nodejs}/bin/npx";
        skillsDir = "${homeDirectory}/.claude/skills";
        agentsDir = "${homeDirectory}/.agents/skills";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''

        export PATH="${pkgs.nodejs}/bin:${pkgs.git}/bin:$PATH"
        export DISABLE_TELEMETRY=1
        echo "Reconciling Claude Code skills from skills.sh..."

        # Remove external skill symlinks (pointing into ~/.agents/) and their cloned sources
        ${pkgs.findutils}/bin/find -H "${skillsDir}" -maxdepth 1 -type l -lname '*/\.agents/*' -delete 2>/dev/null || true
        rm -rf "${agentsDir}" 2>/dev/null || true
        ${lib.concatMapStringsSep "\n        " (
          s: "run --silence ${npx} -y skills add ${s} -g -a claude-code -y || true"
        ) externalSkills}

        # Fix broken relative symlinks: skills.sh creates paths like ../../.agents/skills/<name>
        # which resolve incorrectly because ~/.claude/skills is itself a symlink into the nix-config
        # repo. Replace them with absolute symlinks pointing to ~/.agents/skills/<name>.
        for link in $(${pkgs.findutils}/bin/find -H "${skillsDir}" -maxdepth 1 -type l -lname '*/\.agents/*' 2>/dev/null); do
          name=$(${pkgs.coreutils}/bin/basename "$link")
          target="${agentsDir}/$name"
          if [ -d "$target" ]; then
            rm "$link"
            ln -s "$target" "$link"
          fi
        done
      '';
  }
]
