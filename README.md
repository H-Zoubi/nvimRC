# Personal Neovim config

Lua config built on [lazy.nvim](https://github.com/folke/lazy.nvim). Full LSP,
completion, and treesitter, with C/C++ (desktop CMake + embedded PlatformIO)
and Python as first-class citizens, and VS-style debug keybindings.

## Structure

```
init.lua                 -- entry point
lua/config/options.lua   -- vim options
lua/config/keymaps.lua   -- non-plugin keymaps
lua/config/autocmds.lua  -- autocommands
lua/config/lazy.lua       -- lazy.nvim bootstrap + setup
lua/plugins/*.lua        -- one file per plugin/feature area
```

## Prerequisites

- **Neovim 0.12+** (this config targets the current stable/nightly; the new
  nvim-treesitter rewrite requires it)
- **git** — plugin installation
- **A C/C++ toolchain on PATH** (MSVC `cl`, or LLVM `clang`) — you already
  have this for C++ dev; also used to build `telescope-fzf-native`
- **[`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter)** —
  required by the rewritten nvim-treesitter to compile parsers.
  Install with:
  ```powershell
  winget install tree-sitter.tree-sitter-cli
  ```
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** — powers Telescope
  live grep (already installed on this machine via winget)
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal, for icons
- **PlatformIO Core** (`pio` on PATH) if you use the embedded workflow
- For embedded hardware debugging: a GDB server for your probe (OpenOCD,
  JLinkGDBServer, Black Magic Probe, ...) and an ARM GDB
  (e.g. `arm-none-eabi-gdb`)

## First launch

Open `nvim`. `lazy.nvim` bootstraps itself and installs all plugins.
Treesitter parsers, LSP servers, formatters, and debuggers download
automatically in the background (via Mason) — this can take a few minutes
the first time. Check progress with `:Lazy`, `:Mason`, and `:MasonToolsLog`.

## Keybindings

Leader is `<Space>`. `<C-p>` finds files, VS-code muscle memory works too.

### General
| Key | Action |
|---|---|
| `<C-s>` | Save |
| `<C-p>` | Find files |
| `<C-S-f>` | Find in files (live grep) |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` / `fg` / `fb` / `fh` / `fr` / `fd` / `fs` | Telescope: files / grep / buffers / help / recent / diagnostics / symbols |
| `<C-b>` | Switch to previous (alternate) buffer |
| `<C-t>` | Toggle floating terminal |
| `<C-_>` / `<C-/>` | Toggle comment |
| `gd` / `F12` | Go to definition |
| `gr` / `<S-F12>` | References |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>ih` | Toggle inlay hints |
| `<leader>xx` | Diagnostics list (Trouble) |

### Debugging (VS-style — nvim-dap)
| Key | Action |
|---|---|
| `F5` | Start/Continue |
| `<S-F5>` | Stop |
| `<leader>dl` | Run last |
| `F9` | Toggle breakpoint |
| `F10` | Step over |
| `F11` | Step into |
| `<S-F11>` | Step out |
| `<leader>du` | Toggle debug UI |

### Harpoon
| Key | Action |
|---|---|
| `<leader>a` | Add current file |
| `<C-e>` | Toggle quick menu |
| `<M-y>` / `<M-u>` / `<M-i>` / `<M-o>` / `<M-p>` | Jump to file 1–5 |

### Git
| Key | Action |
|---|---|
| `]c` / `[c` | Next/previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff this |
| `<leader>gc` | Browse commits (Telescope) |

### C++ (CMake projects — cmake-tools.nvim)
| Key | Action |
|---|---|
| `F7` / `<leader>cb` | Build |
| `<C-F5>` | Run (without debugging) |
| `<leader>cg` | Configure/generate |
| `<leader>cr` | Run |
| `<leader>cd` | Debug |
| `<leader>cs` / `ct` / `cl` | Select build type / target / launch target |

### Embedded (PlatformIO)
| Key | Action |
|---|---|
| `<leader>pb` | Build (`pio run`) |
| `<leader>pu` | Upload |
| `<leader>pm` | Serial monitor |
| `<leader>pc` | Regenerate `compile_commands.json` (run after editing `platformio.ini`) |
| `<leader>pt` | Clean |

## C++ workflow notes

- **Desktop/CMake projects**: `clangd` reads `build/compile_commands.json`;
  `cmake-tools.nvim` generates it automatically on `CMakeGenerate`/`CMakeBuild`.
- **PlatformIO/embedded projects**: run `<leader>pc` (`pio run -t compiledb`)
  once after any `platformio.ini` change so `clangd` sees the right
  toolchain, defines, and include paths for your board.
- **Embedded debugging** uses the `cppdbg` (OpenDebugAD7) adapter attaching
  to a remote GDB server — see the "Attach to gdbserver (embedded /
  PlatformIO)" config in `lua/plugins/dap.lua`. Start your probe's GDB
  server (e.g. `openocd -f <cfg>`) first, then hit `F5` and pick that
  config. Adjust `miDebuggerPath` and `miDebuggerServerAddress` for your
  toolchain/probe.

## Notes

- C/C++ is *not* auto-formatted on save (clang-format can be opinionated
  about others' code); use `<leader>cf` on demand. Python/Lua/CMake format
  on save.
- Colorscheme is Monokai Pro, "spectrum" filter (`lua/plugins/colorscheme.lua`)
  — dark background, distinct color per syntax category (no shared hues
  between types/keywords/functions/etc). Swap `filter` for `pro`/`octagon`/
  `machine`/`ristretto`/`classic` to taste.
