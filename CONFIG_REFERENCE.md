# Development Environment Configuration Reference

This document describes the complete WezTerm + tmux + Neovim setup managed via
`~/dotfiles` with symlinks into `~/.config/`.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [WezTerm (Terminal Emulator)](#wezterm-terminal-emulator)
3. [tmux (Terminal Multiplexer)](#tmux-terminal-multiplexer)
4. [Neovim](#neovim)
   - [Directory Layout](#directory-layout)
   - [General Options](#general-options)
   - [Keymaps Quick-Reference](#keymaps-quick-reference)
   - [Plugin Manager (Lazy.nvim)](#plugin-manager-lazynvim)
   - [Color Theme (Nord)](#color-theme-nord)
   - [File Explorer (Neo-tree)](#file-explorer-neo-tree)
   - [Fuzzy Finder (Telescope)](#fuzzy-finder-telescope)
   - [LSP & Mason](#lsp--mason)
   - [Autocompletion (nvim-cmp)](#autocompletion-nvim-cmp)
   - [Formatting & Linting (none-ls / conform)](#formatting--linting-none-ls--conform)
   - [Treesitter](#treesitter)
   - [Git Integration](#git-integration)
   - [Statusline (lualine)](#statusline-lualine)
   - [Buffer Tabs (bufferline)](#buffer-tabs-bufferline)
   - [Dashboard (alpha)](#dashboard-alpha)
   - [Miscellaneous Plugins](#miscellaneous-plugins)
5. [Cross-Tool Integration](#cross-tool-integration)

---

## Architecture Overview

```
WezTerm  (GPU-accelerated terminal emulator)
  |
  +---> fish shell  (default login shell)
          |
          +---> tmux  (session / window / pane management)
                  |
                  +---> Neovim  (editor)
```

All configuration lives in `~/dotfiles/` and is symlinked:

| Tool    | Source                                | Symlink target         |
| ------- | ------------------------------------- | ---------------------- |
| Neovim  | `~/dotfiles/nvim/`                    | `~/.config/nvim`       |
| tmux    | `~/dotfiles/tmux/.config/tmux/`       | `~/.config/tmux`       |
| WezTerm | `~/dotfiles/wezterm/wezterm.lua`      | `~/.wezterm.lua`       |

---

## WezTerm (Terminal Emulator)

**Config file:** `~/dotfiles/wezterm/wezterm.lua`

### Appearance

| Setting               | Value                        | Notes                                           |
| --------------------- | ---------------------------- | ----------------------------------------------- |
| Color scheme          | **Catppuccin Mocha**         | Dark, warm pastel palette                        |
| Font                  | **PragmataPro Liga Regular** | Monospace with programming ligatures             |
| Font size             | 12.5                         |                                                  |
| Background color      | `#282c35`                    | One Dark-ish background tone                     |
| Background opacity    | **0.80** (80%)               | Semi-transparent window                          |
| Window decorations    | `RESIZE`                     | No title bar; only resize handles                |
| Tab bar               | **Disabled**                 | tmux handles multiplexing instead                |
| Cursor                | **BlinkingBar**              |                                                  |

### Behavior

| Setting                         | Value                          |
| ------------------------------- | ------------------------------ |
| Auto-reload config              | `true`                         |
| Close confirmation              | `NeverPrompt` (instant close)  |
| Default shell                   | `/opt/homebrew/bin/fish -l`    |
| Initial window size             | **180 columns x 50 rows**     |

### Key Takeaways

- The tab bar is intentionally hidden because **tmux** is used for window/pane
  management.
- The transparent background lets your desktop show through; combined with
  `RESIZE`-only decorations this gives a minimal, distraction-free look.
- Fish shell is launched as a login shell (`-l`).

---

## tmux (Terminal Multiplexer)

**Config file:** `~/dotfiles/tmux/.config/tmux/tmux.conf`

### Plugins (via TPM)

| Plugin                            | Purpose                                       |
| --------------------------------- | --------------------------------------------- |
| `tmux-plugins/tpm`                | Tmux Plugin Manager                           |
| `tmux-plugins/tmux-sensible`      | Sensible defaults (larger history, faster key repeat, etc.) |
| `christoomey/vim-tmux-navigator`  | Seamless `Ctrl-h/j/k/l` navigation between tmux panes and Neovim splits |
| `odedlaz/tmux-onedark-theme`      | One Dark color theme for the status bar        |

### Settings

| Setting         | Value                          | Notes                                  |
| --------------- | ------------------------------ | -------------------------------------- |
| Default shell   | `/opt/homebrew/bin/fish`       | Matches WezTerm's default              |
| Mouse           | **Enabled**                    | `set-option -g mouse`                  |
| Status bar      | **Bottom**, enabled            | Shows session, pane title, clock, date |
| Pane borders    | Status **off**                 | Clean look, no per-pane labels         |
| Prefix key      | `Ctrl-b` (default)            |                                         |

### Using tmux

| Action                       | Keys                       |
| ---------------------------- | -------------------------- |
| New session                  | `tmux new -s <name>`       |
| Detach                       | `Ctrl-b d`                 |
| Re-attach                    | `tmux attach -t <name>`   |
| New window                   | `Ctrl-b c`                 |
| Next / previous window       | `Ctrl-b n` / `Ctrl-b p`   |
| Split horizontal             | `Ctrl-b "`                 |
| Split vertical               | `Ctrl-b %`                 |
| Navigate panes               | `Ctrl-h/j/k/l` (vim-tmux-navigator) |
| Kill pane                    | `Ctrl-b x`                 |
| Reload config                | `Ctrl-b :source ~/.config/tmux/tmux.conf` |
| Install plugins (TPM)        | `Ctrl-b I`                 |

### Key Takeaways

- **vim-tmux-navigator** is installed in both tmux and Neovim so you can move
  between tmux panes and Neovim splits with the same `Ctrl-h/j/k/l` keys
  without thinking about which tool owns the split.
- Mouse support is on, so you can click to select panes, resize them by
  dragging borders, and scroll through history.

---

## Neovim

### Directory Layout

```
~/.config/nvim/  (symlink -> ~/dotfiles/nvim/)
  init.lua                       -- Entry point: loads options, keymaps, bootstraps Lazy
  lua/
    core/
      options.lua                -- Editor-wide vim options
      keymaps.lua                -- Global keybindings (leader = Space)
    configs/
      lazy.lua                   -- Lazy.nvim manager settings (NvChad legacy)
      lspconfig.lua              -- NvChad-era LSP config (legacy, not loaded by init.lua)
      conform.lua                -- conform.nvim format-on-save config (legacy, not loaded by init.lua)
    plugins/
      init.lua                   -- Extra plugins: conform, leap, copilot, smart-splits, lsp_signature, etc.
      alpha.lua                  -- Dashboard / start screen
      autocompletion.lua         -- nvim-cmp + LuaSnip + sources
      bufferline.lua             -- Buffer tab bar
      colortheme.lua             -- Nord color scheme + transparency toggle
      comment.lua                -- Toggle comments (Ctrl-/ or Ctrl-c)
      gitsigns.lua               -- Git gutter signs
      indent-blankline.lua       -- Indent guide lines
      lsp.lua                    -- Mason + LSP server config (primary)
      lualine.lua                -- Statusline
      misc.lua                   -- vim-tmux-navigator, vim-sleuth, fugitive, which-key, autopairs, todo-comments, colorizer
      neotree.lua                -- File explorer sidebar
      none-ls.lua                -- Formatters & linters via none-ls (null-ls successor)
      telescope.lua              -- Fuzzy finder
      treesitter.lua             -- Syntax highlighting / code parsing
```

> **Note:** `plugins/init.lua` contains an older NvChad-style plugin list
> (conform, lspconfig, mason, copilot, leap, etc.). The main `init.lua` loads
> the individual plugin files from `plugins/*.lua`. Both are loaded by Lazy,
> so all plugins in both files are active.

---

### General Options

Configured in `lua/core/options.lua`. Highlights:

| Option             | Value          | Effect                                           |
| ------------------ | -------------- | ------------------------------------------------ |
| Leader key         | **Space**      | Prefix for most custom keybindings               |
| Line numbers       | Absolute + Relative | `number` + `relativenumber`                 |
| Tabs / Indent      | **4 spaces**   | `tabstop=4`, `shiftwidth=4`, `expandtab`         |
| Clipboard          | `unnamedplus`  | System clipboard integrated (yank = copy)        |
| Search             | Case-insensitive (smart) | `ignorecase` + `smartcase`              |
| Line wrap          | **Off**        | Long lines scroll horizontally                   |
| Swap / Backup      | **Off**        | No `.swp` or `~` backup files                    |
| Undo file          | **On**         | Persistent undo across sessions                  |
| Update time        | **250ms**      | Faster CursorHold events (hover, highlights)     |
| Timeout            | **300ms**      | Time to wait for key sequence completion         |
| Scroll offset      | 4 / 8          | Keep 4 lines above/below cursor, 8 cols on sides |
| Split direction    | Below / Right  | New splits open predictably                      |
| Search highlight   | **Off**        | No lingering highlights after search             |
| Sign column        | Always         | Prevents layout shift from git/diagnostic signs  |
| Popup menu height  | 10             | Completion menu max items                        |
| Termguicolors      | **On**         | Full 24-bit color support                        |

---

### Keymaps Quick-Reference

Leader key: **Space**

#### General

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Ctrl-s`      | Normal | Save file                               |
| `Space sn`    | Normal | Save file without auto-formatting       |
| `Ctrl-q`      | Normal | Quit                                    |
| `x`           | Normal | Delete char without yanking             |
| `Ctrl-d`      | Normal | Scroll down half page + center          |
| `Ctrl-u`      | Normal | Scroll up half page + center            |
| `n` / `N`     | Normal | Next/prev search result + center        |
| `Space lw`    | Normal | Toggle line wrap                        |
| `<` / `>`     | Visual | Indent/dedent and stay in visual mode   |
| `p`           | Visual | Paste without overwriting yank register |

#### Window / Split Management

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Space v`     | Normal | Split vertically                        |
| `Space h`     | Normal | Split horizontally                      |
| `Space se`    | Normal | Equalize split sizes                    |
| `Space xs`    | Normal | Close current split                     |
| `Ctrl-h/j/k/l` | Normal | Navigate between splits (also works across tmux panes) |
| Arrow keys    | Normal | Resize splits (Up/Down = height, Left/Right = width) |

#### Buffers

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Tab`         | Normal | Next buffer                             |
| `Shift-Tab`   | Normal | Previous buffer                         |
| `Space x`     | Normal | Close current buffer                    |
| `Space b`     | Normal | New empty buffer                        |
| `Space Space` | Normal | Telescope: list open buffers            |

#### Tabs

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Space to`    | Normal | Open new tab                            |
| `Space tx`    | Normal | Close current tab                       |
| `Space tn`    | Normal | Next tab                                |
| `Space tp`    | Normal | Previous tab                            |

#### Telescope (Fuzzy Finding)

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Space sf`    | Normal | **Find files** in project               |
| `Space sg`    | Normal | **Live grep** across project            |
| `Space sw`    | Normal | Grep current word under cursor          |
| `Space sh`    | Normal | Search help tags                        |
| `Space sk`    | Normal | Search keymaps                          |
| `Space ss`    | Normal | Search Telescope builtins               |
| `Space sd`    | Normal | Search diagnostics                      |
| `Space sr`    | Normal | Resume last search                      |
| `Space s.`    | Normal | Search recent files                     |
| `Space /`     | Normal | Fuzzy search in current buffer          |
| `Space s/`    | Normal | Live grep in open files only            |

Inside Telescope picker:

| Keys          | Action                                    |
| ------------- | ----------------------------------------- |
| `Ctrl-j`      | Move to next result                       |
| `Ctrl-k`      | Move to previous result                   |
| `Ctrl-l`      | Open selected file                        |
| `Ctrl-/` (insert) or `?` (normal) | Show picker keymaps |

#### LSP (when attached to a buffer)

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `gd`          | Normal | Go to **definition**                    |
| `gr`          | Normal | Find **references**                     |
| `gI`          | Normal | Go to **implementation**                |
| `gD`          | Normal | Go to **declaration** (e.g. C header)   |
| `K`           | Normal | Hover documentation popup               |
| `Space D`     | Normal | Go to **type definition**               |
| `Space ds`    | Normal | Document symbols                        |
| `Space ws`    | Normal | Workspace symbols                       |
| `Space rn`    | Normal | **Rename** symbol                       |
| `Space ca`    | Normal | **Code action**                         |
| `Space th`    | Normal | Toggle **inlay hints**                  |
| `Space wa`    | Normal | Add workspace folder                    |
| `Space wr`    | Normal | Remove workspace folder                 |
| `Space wl`    | Normal | List workspace folders                  |

#### Diagnostics

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `[d`          | Normal | Previous diagnostic                     |
| `]d`          | Normal | Next diagnostic                         |
| `Space d`     | Normal | Open floating diagnostic                |
| `Space q`     | Normal | Open diagnostics list (loclist)         |

#### Autocompletion (nvim-cmp)

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Tab`         | Insert | Next completion item / expand snippet   |
| `Shift-Tab`   | Insert | Previous completion item                |
| `Ctrl-n`      | Insert | Next completion item                    |
| `Ctrl-p`      | Insert | Previous completion item                |
| `Ctrl-y`      | Insert | **Accept** completion                   |
| `Ctrl-Space`  | Insert | Manually trigger completion             |
| `Ctrl-b/f`    | Insert | Scroll docs back / forward              |
| `Ctrl-l`      | Insert | Jump to next snippet placeholder        |
| `Ctrl-h`      | Insert | Jump to previous snippet placeholder    |

#### Comments

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Ctrl-/`      | Normal | Toggle comment on current line          |
| `Ctrl-c`      | Normal | Toggle comment on current line          |
| `Ctrl-/`      | Visual | Toggle comment on selected lines        |
| `Ctrl-c`      | Visual | Toggle comment on selected lines        |

#### Neo-tree (File Explorer)

| Keys          | Mode   | Action                                  |
| ------------- | ------ | --------------------------------------- |
| `Space e`     | Normal | **Toggle** file explorer sidebar        |
| `\`           | Normal | **Reveal** current file in tree         |
| `Space ngs`   | Normal | Open **git status** float               |

Inside Neo-tree:

| Key    | Action                    |
| ------ | ------------------------- |
| `l` / `Enter` | Open file            |
| `S`    | Open in horizontal split  |
| `s`    | Open in vertical split    |
| `t`    | Open in new tab           |
| `P`    | Toggle floating preview   |
| `a`    | Create new file           |
| `A`    | Create new directory      |
| `d`    | Delete                    |
| `r`    | Rename                    |
| `y`    | Copy to clipboard         |
| `x`    | Cut                       |
| `p`    | Paste                     |
| `c`    | Copy file                 |
| `m`    | Move file                 |
| `q`    | Close Neo-tree            |
| `H`    | Toggle hidden files       |
| `/`    | Fuzzy finder in tree      |
| `z`    | Collapse all nodes        |
| `?`    | Show help                 |

#### Other

| Keys   | Mode   | Action                                  |
| ------ | ------ | --------------------------------------- |
| `Space bg` | Normal | Toggle background transparency (Nord) |
| `s` / `S`  | Normal | **Leap** forward / backward (motion) |
| `gs`        | Normal | Leap to other windows                |

---

### Plugin Manager (Lazy.nvim)

Lazy.nvim is bootstrapped in `init.lua` (auto-cloned from GitHub if missing).
Plugins are loaded from the individual files in `lua/plugins/*.lua`.

Performance optimizations from `configs/lazy.lua` disable many built-in Vim
plugins that aren't needed (netrw, zip, tar, gzip, matchit, tutor, etc.).

---

### Color Theme (Nord)

**Plugin:** `shaunsingh/nord.nvim`

| Setting                   | Value   |
| ------------------------- | ------- |
| Contrast                  | On      |
| Borders                   | Off     |
| Background                | **Transparent** (disabled by default) |
| Italic                    | Off     |
| Bold                      | Off     |
| Uniform diff background   | On      |

- Press `Space bg` to toggle between transparent and opaque background.
- Lualine also uses the `nord` theme to match.

---

### File Explorer (Neo-tree)

**Plugin:** `nvim-neo-tree/neo-tree.nvim` (v3)

- Positioned on the **left**, 40 columns wide.
- Git status and diagnostics are enabled.
- Hidden files are **shown** by default (`hide_dotfiles = false`).
- Common noise is hidden: `.DS_Store`, `node_modules`, `__pycache__`, `.git`,
  `.venv`, `.python-version`, `.virtual_documents`.
- Netrw is hijacked so opening a directory goes to Neo-tree.
- Git status view opens as a **floating** window with shortcuts for staging,
  committing, and pushing.

---

### Fuzzy Finder (Telescope)

**Plugin:** `nvim-telescope/telescope.nvim` (master branch)

Extensions loaded:
- **fzf-native** -- fast C-based sorter
- **ui-select** -- replaces `vim.ui.select` with Telescope dropdown

File finding and grep ignore `node_modules`, `.git`, and `.venv`. Hidden files
are included in results.

---

### LSP & Mason

**Plugin:** `neovim/nvim-lspconfig` + `mason-org/mason.nvim` + `mason-org/mason-lspconfig.nvim`

Language servers are configured in `lua/plugins/lsp.lua` using the modern
`vim.lsp.config()` + `vim.lsp.enable()` API.

#### Configured Language Servers

| Server                             | Language(s)                |
| ---------------------------------- | -------------------------- |
| `lua_ls`                           | Lua (with LuaJIT runtime, `vim` global) |
| `pylsp`                            | Python (all linting plugins disabled -- defers to Ruff) |
| `ruff`                             | Python (linting + formatting) |
| `jsonls`                           | JSON                       |
| `sqlls`                            | SQL                        |
| `terraformls`                      | Terraform / HCL            |
| `yamlls`                           | YAML                       |
| `bashls`                           | Bash / Shell               |
| `dockerls`                         | Dockerfile                 |
| `docker_compose_language_service`  | docker-compose.yml         |
| `html`                             | HTML (+ twig, hbs)         |

Additional servers from `plugins/init.lua` (NvChad layer):
- `clangd` (C/C++, with `--offset-encoding=utf-16`)
- `pyright` (Python type checking)
- `gopls` (Go)
- `rust_analyzer` (Rust)
- `tsserver` (TypeScript / JavaScript)
- `html-lsp`, `css-lsp`

**Mason** auto-installs all servers plus `stylua`.

#### LSP Features

- **Document highlight**: References of the symbol under cursor are highlighted
  after a short CursorHold.
- **Inlay hints**: Toggled with `Space th` (if the server supports them).
- **Fidget.nvim**: Shows LSP progress notifications in the bottom-right corner
  with a transparent background.
- **lsp_signature.nvim**: Shows function signature help as you type.

---

### Autocompletion (nvim-cmp)

**Plugin:** `hrsh7th/nvim-cmp`

Completion sources (priority order):
1. `lazydev` -- Neovim Lua API completions
2. `nvim_lsp` -- Language server completions
3. `copilot` -- GitHub Copilot suggestions (via `copilot-cmp`)
4. `luasnip` -- Snippet expansions (friendly-snippets library)
5. `buffer` -- Words from open buffers
6. `path` -- File system paths

Each completion item shows a **kind icon** (Nerd Font glyphs) and a source tag
like `[LSP]`, `[Snippet]`, `[Buffer]`, `[Path]`.

---

### Formatting & Linting (none-ls / conform)

Two formatting systems are configured (both active):

#### none-ls (null-ls successor)

**Plugin:** `nvimtools/none-ls.nvim`

| Formatter / Linter | Filetypes               |
| ------------------- | ----------------------- |
| `prettier`          | HTML, JSON, YAML, Markdown |
| `stylua`            | Lua                     |
| `shfmt` (`-i 4`)   | Shell scripts           |
| `terraform_fmt`     | Terraform               |
| `ruff` (+ ruff_format) | Python (with import sorting via `--extend-select I`) |
| `checkmake`         | Makefiles (linter)      |
| `eslint_d`          | JS/TS (installed via Mason) |

Format-on-save is enabled: files are auto-formatted via `vim.lsp.buf.format`
on every `BufWritePre`.

#### conform.nvim

**Plugin:** `stevearc/conform.nvim`

| Formatter      | Filetypes |
| -------------- | --------- |
| `stylua`       | Lua       |
| `prettier`     | CSS, HTML |
| `clang-format` | C++       |
| `black`        | Python    |

Also has format-on-save via a `BufWritePre` autocmd.

---

### Treesitter

**Plugin:** `nvim-treesitter/nvim-treesitter`

Ensures parsers are installed for: Lua, Python, JavaScript, TypeScript, TSX,
HTML, CSS, Vim, Vimdoc, Regex, Terraform, SQL, Dockerfile, TOML, JSON, Java,
Groovy, Go, Gitignore, GraphQL, YAML, Make, CMake, Markdown, Bash, C, C++.

- `auto_install = true` -- new filetypes get parsers installed automatically.
- Highlighting and indentation are enabled.

---

### Git Integration

| Plugin                    | Purpose                                                |
| ------------------------- | ------------------------------------------------------ |
| `lewis6991/gitsigns.nvim` | Gutter signs: `+` added, `~` changed, `_` deleted     |
| `tpope/vim-fugitive`      | `:Git` commands (status, diff, blame, commit, push)    |
| `tpope/vim-rhubarb`       | GitHub integration for fugitive (`:GBrowse`)           |
| Neo-tree git status       | Floating git status window with stage/commit/push keys |

---

### Statusline (lualine)

**Plugin:** `nvim-lualine/lualine.nvim`

Theme: **Nord** (matching the color scheme).

| Section | Content                                               |
| ------- | ----------------------------------------------------- |
| A (left)  | Mode (with icon)                                    |
| B         | Git branch                                          |
| C         | Filename                                            |
| X (right) | Diagnostics (errors/warns), Git diff, encoding, filetype |
| Y         | Line:Column location                                |
| Z         | Progress through file (%)                           |

- Diagnostics and diff sections hide when the window is narrower than 100
  columns.
- Disabled in `alpha` (dashboard) and `neo-tree` buffers.
- Uses round separators (``, ``).

---

### Buffer Tabs (bufferline)

**Plugin:** `akinsho/bufferline.nvim`

- Mode: **buffers** (each open buffer gets a tab).
- Close command uses `Bdelete!` (from `vim-bbye`) to avoid layout disruption.
- Separator style: vertical pipes (`│`).
- Tabs are sorted by insertion order.
- Always visible (even with a single buffer).
- File icons and close icons are shown.

---

### Dashboard (alpha)

**Plugin:** `goolord/alpha-nvim`

Uses the **startify** theme with a custom ASCII art "NEOVIM" header. Shown on
startup when no file arguments are provided. Lists recent files, bookmarks,
and sessions.

---

### Miscellaneous Plugins

| Plugin                          | Purpose                                              |
| ------------------------------- | ---------------------------------------------------- |
| `christoomey/vim-tmux-navigator` | `Ctrl-h/j/k/l` navigation across tmux + nvim splits |
| `tpope/vim-sleuth`              | Auto-detect `tabstop` and `shiftwidth` from file     |
| `folke/which-key.nvim`          | Popup showing available keybindings after leader key  |
| `windwp/nvim-autopairs`         | Auto-close `()`, `[]`, `{}`, `""`, `''`              |
| `folke/todo-comments.nvim`      | Highlight `TODO`, `FIXME`, `NOTE`, etc. in comments  |
| `norcalli/nvim-colorizer.lua`   | Inline color preview for hex codes, CSS colors       |
| `ggandor/leap.nvim`             | Fast cursor motion: press `s` + 2 chars to jump      |
| `zbirenbaum/copilot.lua`        | GitHub Copilot inline suggestions (auto-trigger)     |
| `zbirenbaum/copilot-cmp`        | Copilot as a nvim-cmp completion source              |
| `ray-x/lsp_signature.nvim`      | Function signature help while typing                 |
| `mrjones2014/smart-splits.nvim` | Improved split resizing                              |
| `lukas-reineke/indent-blankline.nvim` | Thin indent guide lines (`▏`)                  |
| `numToStr/Comment.nvim`         | `Ctrl-/` or `Ctrl-c` to toggle comments             |
| `j-hui/fidget.nvim`             | LSP progress indicator in bottom-right               |
| `moll/vim-bbye`                 | `:Bdelete` closes buffer without closing window      |
| `3rd/image.nvim`                | Image preview support in Neo-tree (optional)         |

---

## Cross-Tool Integration

### Seamless Pane Navigation (tmux <-> Neovim)

The `vim-tmux-navigator` plugin is installed in **both** tmux and Neovim:
- **tmux plugin:** `christoomey/vim-tmux-navigator` (in `tmux.conf`)
- **Neovim plugin:** `christoomey/vim-tmux-navigator` (in `plugins/misc.lua`)

This means `Ctrl-h`, `Ctrl-j`, `Ctrl-k`, `Ctrl-l` seamlessly move focus:
- Between Neovim splits (when inside Neovim)
- Between tmux panes (when moving out of Neovim)
- Back into Neovim from an adjacent tmux pane

No need to use the tmux prefix key for pane navigation.

### Consistent Shell

Both WezTerm and tmux are configured to use **fish** (`/opt/homebrew/bin/fish`)
as the default shell, ensuring a consistent experience regardless of how a
terminal session is started.

### Color Harmony

| Layer    | Theme               |
| -------- | -------------------- |
| WezTerm  | Catppuccin Mocha     |
| tmux     | One Dark             |
| Neovim   | Nord (transparent)   |
| Lualine  | Nord                 |

The dark themes complement each other. Neovim's transparent background lets the
WezTerm / terminal background show through, creating a unified visual feel.

### Transparency Stack

1. **WezTerm** renders at 80% opacity with background color `#282c35`.
2. **Neovim** (Nord) has `disable_background = true` by default, making the
   editor background transparent.
3. The result: your desktop wallpaper or other windows are subtly visible behind
   your code.
4. Toggle with `Space bg` in Neovim to get an opaque editor background if
   needed.
