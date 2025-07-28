# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a zsh-custom repository containing oh-my-zsh plugins for various CLI tools. The repository follows a standard oh-my-zsh plugin structure with three main plugins:

### Plugin Architecture

Each plugin follows a consistent pattern:
- **Conditional loading**: Only loads if the CLI tool is installed (`(( ! $+commands[tool] ))`)
- **Auto-completion**: Uses official tool completion commands cached in `$ZSH_CACHE_DIR/completions/`
- **Aliases**: Short aliases for common operations
- **Helper functions**: Advanced wrapper functions for complex workflows
- **Integration**: Optional integration with kubectl, hubble, or other related tools

### Plugins

1. **cilium** (`plugins/cilium/`): Cilium CLI plugin with Kubernetes networking aliases and functions
2. **kbcli** (`plugins/kbcli/`): KubeBlocks CLI plugin for database cluster management
3. **qshell** (`plugins/qshell/`): Qiniu Cloud Storage CLI plugin for file operations

## Plugin Structure

```
plugins/
├── [plugin-name]/
│   ├── README.md          # Comprehensive documentation with examples
│   └── [plugin-name].plugin.zsh  # Main plugin file
```

## Key Features Across Plugins

### Completion System
All plugins use a consistent completion caching pattern:
```zsh
if [[ ! -f "$ZSH_CACHE_DIR/completions/_tool" ]]; then
  tool completion zsh | tee "$ZSH_CACHE_DIR/completions/_tool" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_tool"
else
  source "$ZSH_CACHE_DIR/completions/_tool"
  tool completion zsh | tee "$ZSH_CACHE_DIR/completions/_tool" >/dev/null &|
fi
```

### Helper Function Pattern
Most plugins include helper functions that:
- Provide unified interfaces for common operations
- Include usage help when called without arguments
- Support multiple subcommands with case statements
- Add safety features like confirmation prompts for destructive operations

### Common Alias Patterns
- Short aliases for main commands (e.g., `c` for `cilium`, `kb` for `kbcli`)
- Action-based aliases (e.g., `cepl` for `cilium endpoint list`)
- Combination aliases for complex operations

## Development Guidelines

### Adding New Plugins
1. Create plugin directory under `plugins/`
2. Follow the existing plugin structure and patterns
3. Include comprehensive README.md with examples
4. Implement conditional loading, completion caching, and helper functions
5. Use consistent naming conventions for aliases

### Plugin Development Patterns
- Always check if the main CLI tool is installed before loading
- Cache completions for performance
- Provide both simple aliases and comprehensive helper functions
- Include safety features for destructive operations
- Document all functions and aliases in README.md

### Testing Plugins
Test plugins by:
1. Installing the relevant CLI tool
2. Loading the plugin in a zsh session
3. Testing aliases, functions, and completion
4. Verifying conditional loading works without the CLI tool

## No Build System

This repository has no build system, package.json, Makefile, or test scripts. Plugins are loaded directly by oh-my-zsh when added to the plugins list in `.zshrc`.

## Installation and Usage

Users add these plugins to their oh-my-zsh configuration by:
1. Placing the plugin in their custom plugins directory
2. Adding the plugin name to their `.zshrc` plugins list
3. Reloading their shell with `source ~/.zshrc`