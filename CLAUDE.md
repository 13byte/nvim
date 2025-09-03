# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration based on LazyVim framework with extensive customizations for system engineering and Python development. The configuration uses Lua for all configuration files and follows LazyVim's modular plugin architecture.

## Architecture

### Core Structure
- **init.lua**: Entry point that bootstraps the configuration
- **lua/config/**: Core configuration files
  - `lazy.lua`: Plugin manager setup with lazy.nvim
  - `options.lua`: Global Neovim options (Python LSP configured for basedpyright and ruff)
  - `keymaps.lua`: Custom keybindings (window resizing with Alt+Arrow keys)
  - `autocmds.lua`: Auto-commands configuration
- **lua/plugins/**: Individual plugin configurations following LazyVim's plugin spec format
- **lazyvim.json**: LazyVim extras configuration (30+ language and tool extras enabled)

### Key Plugin Configurations
- **Avante.nvim**: AI assistant with Gemini integration and MCP Hub support
- **MCP Hub**: Model Context Protocol integration for enhanced AI capabilities
- **Lualine**: Custom statusline configuration
- **Blink**: Completion engine setup
- **Rainbow delimiters, syntax highlighting, and visual enhancements**

## Development Commands

### Neovim Management
```bash
# Open Neovim
nvim

# Update plugins (inside Neovim)
:Lazy sync

# Check plugin status
:Lazy

# Check LazyVim health
:checkhealth lazyvim
```

### Code Formatting
```bash
# Format Lua files with stylua (2-space indentation, 120 column width)
stylua lua/
```

### Plugin Development
When adding new plugins:
1. Create a new file in `lua/plugins/` with the plugin spec
2. Follow the existing pattern of returning a table with plugin configuration
3. Use LazyVim's opts merging for overriding default plugin configs

## Configuration Guidelines

### Adding Custom Plugins
Place plugin specs in `lua/plugins/` following this pattern:
```lua
return {
  "author/plugin-name",
  event = "VeryLazy", -- or specific events
  opts = {
    -- configuration options
  },
  dependencies = {
    -- required dependencies
  },
}
```

### Modifying LazyVim Defaults
- Override existing plugins by creating a spec with the same plugin name
- Use `opts` to merge configuration with LazyVim defaults
- Set `enabled = false` to disable a default plugin

### Language Support
The configuration includes extensive language support via LazyVim extras:
- Python (basedpyright, ruff)
- Go, Rust, TypeScript, Java
- Docker, Kubernetes (Helm), Terraform
- Web technologies (Vue, Svelte, Tailwind)

### Window Management
Custom keymaps for window resizing are defined:
- `<A-Up/Down>`: Resize horizontal splits
- `<A-Left/Right>`: Resize vertical splits
These work in both normal and terminal modes.

## Plugin Architecture (Optimized)

### Core Configuration Files
- **lua/config/edge-palette.lua**: Central color palette management for Edge Aura theme
- **lua/config/python-enhanced.lua**: Unified Python settings and file type detection

### Plugin Roles and Responsibilities (No Overlapping)

#### Visual Theme & UI
1. **edge.lua**: Main color theme (Edge Aura style)
   - Role: Base color scheme for entire editor
   - No overlap with other plugins

2. **lualine.lua**: Status bar 
   - Role: Bottom status line display
   - Features: Mode indicator, file info, LSP status, Git info, Python venv display
   - No overlap with other plugins

3. **colorful-winsep.lua**: Window separator coloring
   - Role: Visual separation between split windows
   - Uses python_file_type from python-enhanced.lua
   - No overlap with other plugins

#### Syntax Highlighting (Specialized Roles)
1. **python-syntax.lua**: Complete Python syntax & argument highlighting
   - Role: Combines python-syntax + hlargs functionality
   - Features: Full Python syntax, function arguments, type hints, f-strings, data science keywords
   - Single unified configuration for all Python highlighting needs

2. **nvim-highlight-colors.lua**: Color code preview
   - Role: ONLY previews color codes (#hex, rgb, hsl) as backgrounds
   - Removed: All Python syntax patterns
   - No overlap after simplification

4. **rainbow-delimiters.lua**: Bracket coloring
   - Role: Colors nested brackets/parentheses/braces
   - Pure visual enhancement for nesting levels
   - No overlap with syntax highlighting

### Color Consistency
All plugins use the unified Edge Aura palette from `edge-palette.lua`:
- Background: #2b2d37 (bg0)
- Foreground: #c5cdd9 (fg)
- Red: #ec7279
- Green: #a0c980  
- Blue: #6cb6eb
- Purple: #d38aea
- Yellow: #deb974
- Cyan: #5dbbc1
- Orange: #ef9062

### Performance Optimizations
- Event-based loading (BufReadPost, BufNewFile, VeryLazy)
- Python file type detection centralized in python-enhanced.lua
- Single Python FileType autocmd group
- Local parsing strategy for Python files
- Reduced plugin overlap eliminates redundant processing