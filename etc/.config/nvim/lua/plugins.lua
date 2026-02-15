local hl = require("util.highlight")
local map = require("util.keymap")
local palette = require("config.core.colorscheme").palette

return {

    --------------------------------------------------------------------------------------------------------------------
    -- Core Plugins.

    -- {{{ restore_view - Stores and restores settings/folds/... of files
    {
        -- Automagically save/restore views
        "vim-scripts/restore_view.vim",
    },
    -- }}}

    -- {{{ vim-rooter - Find the project root
    {
        "notjedi/nvim-rooter.lua",

        -- Required immediately. Must not be lazily loaded.
        lazy = false,

        opts = {
            -- With git submodules, .git exists as file in a submodule. To
            -- make the top-level project the project root, use ".git/"
            -- with slash to match only git dirs.
            rooter_patterns = { ".root", ".repo/", ".git/", "_darcs/", ".hg/", ".bzr/", ".svn/" },

            -- If no root is found, go to the files own dir
            fallback_to_parent = true,
        },
    },
    -- }}}

    -- {{{ fzf-lua - Fuzzy finder with Lua
    {
        "ibhagwan/fzf-lua",
        --dependencies = { "nvim-tree/nvim-web-devicons" },

        lazy = true,
        event = "VeryLazy",

        opts = function()
            map.n("<leader>e", function()
                require("fzf-lua").files()
            end, { desc = "Edit file", icon = "󱇧" })

            return {
                -- Space around icons?
                file_icon_padding = "",
                winopts = {
                    -- Visibility of the background (the text window)
                    backdrop = 60,

                    width = 1,
                    height = 0.6,
                    row = 1,

                    preview = {
                        title = false,
                        scrollbar = "float", -- "float" to use the default scrollbar. False disables the scrollbar.
                    },
                },
                hls = {
                    border = "FloatBorder",
                    preview_border = "FloatBorder",

                    dir_icon = "wtf",
                    dir_part = "wtf",
                    file_part = "wtf",

                    -- Scollbars in the preview window (if scrollbar = "float")
                    scrollfloat_e = "PmenuSbar",
                    scrollfloat_f = "PmenuThumb",
                },

                fzf_opts = {
                    ["--layout"] = "default",
                },

                files = {
                    color_icons = false,
                },

                _fzf_colors = {
                    true,

                    -- Normal background and foreground
                    ["fg"] = { "fg", "Normal" },
                    ["bg"] = { "bg", "Normal" },

                    -- Selected foreground and background
                    ["fg+"] = { "fg", "Visual" },
                    ["bg+"] = { "bg", "Visual" },

                    -- Highlight matches and selected matches
                    ["hl"] = { "fg", "Search" },
                    ["hl+"] = { "fg", "Search" },

                    -- ["info"] = { "fg", "Search" },
                    -- ["border"] = { "fg", "CursorLine" },
                    -- ["prompt"] = { "fg", "Keyword" },
                    -- ["pointer"] = { "fg", "Keyword" },
                    -- ["marker"] = { "fg", "Keyword" },
                    -- ["spinner"] = { "fg", "Search" },
                    -- ["header"] = { "bg", "Error" },
                    -- ["gutter"] = -1, -- { "bg", "CursorLine" },
                },
            }
        end,
    },
    -- }}}

    -- {{{ vim-startify - start page showing mru, git changes, ...
    {
        "mhinz/vim-startify",

        -- required at startup
        lazy = false,

        init = function()
            vim.cmd([[
            " do not change dir on file selection. vim-rooter is doing it already
            let g:startify_change_to_dir = 0
            let g:startify_change_to_vcs_root = 0

            " returns all modified files of the current git repo
            " `2>/dev/null` makes the command fail quietly, so that when we are not
            " in a git repo, the list will be empty
            function! s:gitmodified()
                let files = systemlist('git ls-files -m 2>/dev/null')
                return map(files, "{'line': v:val, 'path': v:val}")
            endfunction

            " same as above, but show untracked files, honouring .gitignore
            function! s:gituntracked()
                let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
                return map(files, "{'line': v:val, 'path': v:val}")
            endfunction

            function! s:gitlistcommits()
                let commits = systemlist('git log --oneline 2>/dev/null | head -n10')
                return map(commits, '{"line": v:val}')
            endfunction

            " Color of the header
            hi! link StartifyHeader Normal
            hi! link StartifySection Keyword

            " Enable the cursorline
            autocmd User Startified setlocal cursorline

            let g:startify_lists = [
                    "\ { 'type': 'files',                        'header': ['   mru'] },
                    \ { 'type': 'dir',                          'header': ['   mru '. getcwd()] },
                    \ { 'type': 'sessions',                     'header': ['   sessions'] },
                    \ { 'type': function('s:gitmodified'),      'header': ['   modified'] },
                    \ { 'type': function('s:gituntracked'),     'header': ['   untracked'] },
                    "\ { 'type': function('s:gitlistcommits'),   'header': ['   commits'] },
                    \ { 'type': 'commands',                     'header': ['   commands'] },
                    \ ]

            " By default, the unix fortune command is used. Override with:
            let g:_____startify_custom_header =[
             \ '    _   _         __     ___           ',
             \ '   | \ | | ___  __\ \   / (_)_ __ ___  ',
             \ '   |  \| |/ _ \/ _ \ \ / /| | `_ ` _ \ ',
             \ '   | |\  |  __/ (_) \ v / | | | | | | |',
             \ '   |_| \_|\___|\___/ \_/  |_|_| |_| |_|',
             \ '',
             \]
        ]])
        end,
    },
    -- }}}

    -- {{{ which-key.nvim - Unobtrusively show key bindings while typing
    {
        "folke/which-key.nvim",

        dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },

        lazy = true,
        event = "VeryLazy",

        opts = function()
            -- Map the color groups of WhichKey. The defaults do not match my color-scheme nicely
            vim.api.nvim_set_hl(0, "WhichKey", { link = "Operator" })
            vim.api.nvim_set_hl(0, "WhichKeySeperator", { link = "Normal" })
            vim.api.nvim_set_hl(0, "WhichKeyGroup", { link = "Visual" })
            vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "Normal" })
            vim.api.nvim_set_hl(0, "WhichKeyIcon", { link = "Normal" })
            -- vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "SidebarNormal" })

            return {
                preset = "helix",

                -- Wait until the popup is shown:
                delay = 500,

                -- In modern and helix, disable the tiny help (the help is a separate window)
                show_help = false,

                -- en- or disable some plugins.
                plugins = {
                    -- shows a list of your marks on ' and `
                    marks = true,
                    -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                    registers = true,

                    -- show spelling hints when pressing z=
                    spelling = {
                        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                        suggestions = 20, -- how many suggestions should be shown in the list?
                    },

                    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                    -- No actual key bindings are created
                    presets = {
                        operators = true, -- adds help for operators like d, y, ...
                        motions = true, -- adds help for motions
                        text_objects = true, -- help for text objects triggered after entering an operator
                        windows = true, -- default bindings on <c-w>
                        nav = true, -- misc bindings to work with windows
                        z = true, -- bindings for folds, spelling and others prefixed with z
                        g = true, -- bindings for prefixed with g
                    },
                },

                win = {
                    no_overlap = false,
                    wo = {
                        winblend = 5, -- value between 0-100 0 for fully opaque and 100 for fully transparent
                    },
                },

                icons = {
                    colors = false,
                },

                -- Override what triggers whichkey.
                --triggers = {
                --    { "<leader>", mode = { "n" } },
                --}
            }
        end,
    },
    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- Core UI Plugins

    -- {{{ nvim-neo-tree - A file/buffer/git tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },

        lazy = true,
        event = { "VeryLazy" },

        opts = function()
            map.n("\\", ":Neotree toggle<CR>", { desc = "File Browser", icon = "" })

            vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { link = "Error" })
            vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { link = "Added" })
            vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { link = "Changed" })
            vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { link = "Changed" })
            -- vim.api.nvim_set_hl(0, "NeoTreeDotfile", { link = "SignifySignChange" })
            -- vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { link = "Comment" })

            -- See :help neo-tree-highlights

            hl.link("NeoTreeNormal", "SidebarNormal")
            hl.link("NeoTreeNormalNC", "SidebarNormal")
            hl.link("NeoTreeVertSplit", "SidebarVertSplit")
            hl.link("NeoTreeWinSeparator", "SidebarVertSplit")
            hl.link("NeoTreeDirectoryIcon", "Directory")
            hl.link("NeoTreeTabActive", "Selected")

            hl.link("NeoTreeIndentMarker", "IndentLine")

            return {
                -- Enables source (file/buffer/git) selection
                source_selector = {
                    winbar = true,
                    statusline = false,
                },

                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                    -- Experimental feature to show all LSP symbols as a tree.
                    -- "document_symbols",
                },

                -- ? Causes issues when closing a buf.
                close_if_last_window = true,

                -- They are quite annoying and clutter the tree.
                enable_diagnostics = false,

                -- Refer to the git page of the project. Nearly all styles and highlight groups can be modified.
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        with_expanders = true,
                    },
                    modified = {
                        symbol = "",
                        highlight = "Search",
                    },
                    name = {
                        use_git_status_colors = false,
                    },

                    git_status = {
                        symbols = {
                            -- Change type
                            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted = "", -- this can only be used in the git_status source
                            renamed = "", -- this can only be used in the git_status source
                            -- Status type - see nerd fonts box types
                            untracked = "",
                            ignored = "",
                            unstaged = "",
                            staged = "",
                            conflict = "",
                        },
                    },
                },

                filesystem = {
                    -- Make the netrw replacement full size
                    hijack_netrw_behavior = "open_current",

                    filtered_items = {
                        visible = true, -- when true, they will just be displayed differently than normal items
                        hide_dotfiles = true,
                        hide_gitignored = true,
                        hide_hidden = true, -- only works on Windows for hidden files/directories
                        hide_by_name = {
                            --"node_modules"
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            --"*.meta",
                            --"*/src/*/tsconfig.json",
                        },
                        always_show = { -- remains visible even if other settings would normally hide it
                            --".gitignored",
                        },
                        always_show_by_pattern = { -- uses glob style patterns
                            --".env*",
                        },
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            --".DS_Store",
                            --"thumbs.db"
                        },
                        never_show_by_pattern = { -- uses glob style patterns
                            --".null-ls_*",
                        },
                    },

                    follow_current_file = {
                        enabled = true, -- Focus the file of the current buffer
                        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                    },

                    group_empty_dirs = true,
                },
            }
        end,
    },
    -- }}}

    -- {{{ lualine.nvim - Configurable status-line
    {
        "nvim-lualine/lualine.nvim",

        lazy = true,
        event = "VeryLazy",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            options = {
                -- Disable in some file-types
                disabled_filetypes = { "neo-tree", "NVimTree", "qf", "fzf", "trouble", "DiffviewFiles" },

                icons_enabled = true,
                theme = {
                    normal = {
                        a = { fg = "#ffffff", bg = palette.structuralAlt, gui = "bold" },
                        b = { fg = hl.fg("StatusLine"), bg = hl.bg("StatusLine") },
                        c = { fg = hl.fg("StatusLineNC"), bg = hl.bg("StatusLineNC") },
                    },

                    insert = {
                        a = { fg = hl.fg("Visual"), bg = palette.bg.L5, gui = "bold" },
                    },

                    replace = {
                        a = { fg = hl.fg("Visual"), bg = palette.bg.L5, gui = "bold" },
                    },

                    visual = {
                        a = { fg = hl.fg("Visual"), bg = palette.bg.L5, gui = "bold" },
                    },

                    command = {
                        a = { fg = hl.bg("Normal"), bg = hl.fg("Search"), gui = "bold" },
                    },

                    inactive = {
                        a = { fg = hl.fg("StatusLineNC"), bg = hl.bg("StatusLineNC") },
                        b = { fg = hl.fg("StatusLineNC"), bg = hl.bg("StatusLineNC") },
                        c = { fg = hl.fg("StatusLineNC"), bg = hl.bg("StatusLineNC") },
                    },
                },

                component_separators = { left = "", right = "" },
                --section_separators = { left = '', right = ''},
                --section_separators = { left = '🭛', right = '🭋'},
            },

            sections = {
                -- Status as single letter
                lualine_a = {
                    {
                        "mode",
                        fmt = function(str)
                            -- if str:sub(1, 1) == "C" then
                            --     return "  "
                            -- end
                            -- if str:sub(1, 1) == "V" then
                            --     return " 󰒇 "
                            -- end
                            -- if str:sub(1, 1) == "I" then
                            --     return " 󰌌 "
                            -- end
                            -- if str:sub(1, 1) == "N" then
                            --     return " 󰆾 "
                            -- end
                            return str:sub(1, 1)
                        end,
                    },
                },

                -- Git status info
                lualine_b = {
                    {
                        "branch",
                        icon = { "", align = "left" },
                    },
                    {
                        "diff",
                        -- Re-format de detailed output to only show a small "modified" marker instead of
                        -- add/remove/change counts
                        fmt = function(
                            str,
                            -- content:
                            _
                        )
                            if str == nil or str == "" then
                                return ""
                            end
                            return ""
                        end,

                        padding = { left = 0, right = 1 },

                        -- color = { fg = '#a2bf6d', gui='bold' },
                    },
                },

                -- The bufferlist
                lualine_c = {
                    {
                        -- Add some space
                        function()
                            return [[ ]]
                        end,
                        padding = 0,
                    },
                    {
                        "buffers",

                        -- Split buffers NOT using the powerline arrows
                        section_separators = { left = "X", right = "" },

                        padding = { left = 1, right = 1 },
                        component_separators = { left = "", right = "" },

                        -- Use nvim-web-devicons for file icons?
                        icons_enabled = false,

                        -- filenames or a shortened path relative to the CWD
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,

                        mode = 2, -- 0: Shows buffer name
                        -- 1: Shows buffer index
                        -- 2: Shows buffer name + buffer index
                        -- 3: Shows buffer number
                        -- 4: Shows buffer name + buffer number

                        buffers_color = {
                            active = { fg = "#dddddd", bg = "background", gui = "bold" },
                            -- inactive = { fg = "#dd0000", bg = "green", gui = "bold" },
                        },

                        symbols = {
                            modified = " ",
                            alternate_file = "",
                            directory = "",
                        },
                    },
                },

                lualine_x = {

                    {
                        "diagnostics",

                        -- Table of diagnostic sources, available sources are:
                        --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                        -- or a function that returns a table as such:
                        --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                        sources = { "nvim_diagnostic", "coc" },

                        on_click = function()
                            require("trouble").toggle("diagnostics")
                        end,

                        -- Displays diagnostics for the defined severity types
                        sections = {
                            "error",
                            "warn",
                            "info",
                            "hint",
                        },

                        diagnostics_color = {
                            error = "DiagnosticErrorInv",
                            warn = "DiagnosticWarnInv",
                            info = "DiagnosticInfoInv",
                            hint = "DiagnosticHintInv",
                        },
                        colored = true,

                        -- symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        -- symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },

                        component_separators = { left = "", right = "" },

                        update_in_insert = false,
                        always_visible = false,
                    },
                    {
                        "lsp_status",
                        -- icon = "󰒓",
                        -- icon = "󰅩",
                        icon = "󱙺",

                        symbols = {
                            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                            -- done = "✓",
                            -- done = " ",
                            done = "",
                            -- Delimiter inserted between LSP names:
                            separator = "  󱙺 ",
                        },

                        -- List of LSP names to ignore (e.g., `null-ls`):
                        ignore_lsp = {},

                        component_separators = { left = "", right = "" },
                    },
                    {
                        function()
                            if vim.v.hlsearch == 0 then
                                return ""
                            end

                            local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
                            if not ok or next(result) == nil then
                                return ""
                            end

                            local denominator = math.min(result.total, result.maxcount)
                            if denominator == 0 then
                                return ""
                            end
                            return ("  %d/%d"):format(result.current, denominator)
                        end,

                        component_separators = { left = "", right = "" },
                        color = { fg = hl.fg("Search") },
                    },
                },

                lualine_y = {
                    {
                        "filetype",
                        colored = false, -- Displays filetype icon in color if set to true
                        icon_only = false, -- Display only an icon for filetype
                        icon = { align = "left" }, -- Display filetype icon on the right hand side

                        component_separators = { left = "", right = "" },
                    },
                    -- {
                    --     function()
                    --         return [[]]
                    --     end,
                    -- },
                    {
                        "encoding",
                        -- Show '[BOM]' when the file has a byte-order mark
                        show_bomb = false,

                        padding = { left = 1, right = 1 },
                        component_separators = { left = "", right = "" },
                    },
                    {
                        "fileformat",
                        symbols = {
                            unix = "", -- e712
                            dos = "", -- e70f
                            mac = "", -- e711
                        },

                        padding = { left = 1, right = 1 },
                    },
                },

                lualine_z = {
                    {
                        function()
                            -- return [[⌽]]
                            -- return [[   󰓾       @]]
                            -- return [[]]
                            -- return [[]]
                            return [[ ]]
                        end,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        -- 'location' and 'progress' but a bit nicer
                        function()
                            local line = vim.fn.line(".")
                            local col = vim.fn.charcol(".")
                            local total = vim.fn.line("$")

                            -- Handle some special cases
                            local perc = math.floor(line / total * 100)
                            if line == 1 then
                                perc = 0
                            elseif line == total then
                                perc = 100
                            end

                            return string.format("%2d%%%% %2d/%d:%-3d", perc, line, total, col)
                        end,

                        padding = { left = 1, right = 1 },
                    },
                },
            },
        },
    },
    -- }}}

    -- {{{ gitsigns.nvim - Show changes and provides basic staging/diff features
    {
        "lewis6991/gitsigns.nvim",

        lazy = true,
        event = { "VeryLazy" },

        opts = function()
            local function makeSigns()
                -- ┆ ┋ ┇ ╎ ╏  ░  ▒  ▓ ▍ │  ▏ 🭲
                --                    ┃
                local icon = "▍" -- "🭲" -- "┃"
                return {
                    add = { text = icon },
                    change = { text = icon },
                    delete = { text = icon },
                    topdelete = { text = icon },
                    changedelete = { text = icon },
                    untracked = { text = icon },
                }
            end

            vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "AddedSign" })
            vim.api.nvim_set_hl(0, "GitSignsChange", { link = "ChangedSign" })
            vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "RemovedSign" })
            vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "AddedSign" })
            -- Also allows to modify staged versions, virtual lines, ...
            -- Staged versions seem to be derived automatically from the non-staged versions.

            return {
                signs = makeSigns(),
                signs_staged = makeSigns(),

                -- Different signs for staged changes?
                signs_staged_enable = true,

                -- Indicate untracked files? Gets very noisy!
                attach_to_untracked = false,

                -- Show blame info next to the line?
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`

                -- When attaching, add some key mappings
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    -- Actions
                    map.group("<leader>v", "Versioning", "")

                    map.n("<leader>vs", gitsigns.stage_hunk, { desc = "Stage hunk", icon = "", buffer = bufnr })
                    map.n("<leader>vr", gitsigns.reset_hunk, { desc = "Reset hunk", icon = "", buffer = bufnr })
                    map.v("<leader>vs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Stage hunk", icon = "", buffer = bufnr })
                    map.v("<leader>vr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Reset hunk", icon = "", buffer = bufnr })
                    map.n(
                        "<leader>vu",
                        gitsigns.undo_stage_hunk,
                        { desc = "Undo stage hunk", icon = "", buffer = bufnr }
                    )

                    map.n("<leader>vS", gitsigns.stage_buffer, { desc = "Stage buffer", icon = "", buffer = bufnr })
                    map.n("<leader>vR", gitsigns.reset_buffer, { desc = "Reset buffer", icon = "", buffer = bufnr })

                    map.n("<leader>vp", gitsigns.preview_hunk, { desc = "Preview hunk", icon = "", buffer = bufnr })
                    map.n("<leader>vb", function()
                        gitsigns.blame_line({ full = true })
                    end, { desc = "Blame current line", icon = "", buffer = bufnr })

                    map.n("<leader>vd", gitsigns.diffthis, { desc = "Diff this", icon = "", buffer = bufnr })
                    map.n("<leader>vD", function()
                        gitsigns.diffthis("~")
                    end, { desc = "Diff this", icon = "", buffer = bufnr })

                    -- Show blame info as virtual text.
                    -- Disabled: slow and not useful. Query via <leader>vb!
                    -- map.n(
                    --     "<leader>tb",
                    --     gitsigns.toggle_current_line_blame,
                    --     { desc = "Toggle blame line", icon = "", buffer = bufnr }
                    -- )
                    --
                    -- Show deleted lines as virtual text.
                    -- Disabled: Gets very messy. Use <leader>vd or vD instead.
                    -- map.n(
                    --     "<leader>td",
                    --     gitsigns.toggle_deleted,
                    --     { desc = "Toggle deleted lines", icon = "", buffer = bufnr }
                    -- )
                end,
            }
        end,
    },
    -- }}}

    -- {{{ nvim-web-devicons (dependency)
    -- Nice icon set used by several UI plugins
    {
        "nvim-tree/nvim-web-devicons",

        lazy = true,

        opts = {
            -- globally enable different highlight colors per icon (default to true)
            -- if set to false all icons will have the default icon's color
            color_icons = false,

            -- globally enable default icons (default to false)
            -- will get overwritten by `get_icons` option
            default = true,

            -- globally enable "strict" selection of icons - icon will be looked up in
            -- different tables, first by filename, and if not found by extension; this
            -- prevents cases when file doesn't have any extension but still gets some icon
            -- because its name happened to match some extension (default to false)
            strict = true,
        },
    },
    -- }}}

    -- {{{ nvim-hlslens - provide a virtual text next to the current search highlight
    -- NOTE: nvim-scrollbar uses this too
    {
        "kevinhwang91/nvim-hlslens",

        lazy = true,
        event = "VeryLazy",

        opts = function()
            local kopts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)

            hl.link("HlSearchNear", "CurSearch")
            hl.link("HlSearchLens", "Visual") -- the lens for a match that is not current
            hl.link("HlSearchLensNear", "Search") -- the lens for a match that is not current

            return {
                build_position_cb = function(plist, _, _, _)
                    require("scrollbar.handlers.search").handler.show(plist.start_pos)
                end,

                -- If false, also show other matches that are not the current one
                nearest_only = true,

                -- Customize the virtual text to match the diagnostics style
                override_lens = function(render, posList, nearest, idx, relIdx)
                    local sfw = vim.v.searchforward == 1
                    local indicator, text, chunks
                    local absRelIdx = math.abs(relIdx)
                    if absRelIdx > 1 then
                        indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
                    elseif absRelIdx == 1 then
                        indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
                    else
                        indicator = ""
                    end

                    local lnum, col = unpack(posList[idx])
                    if nearest then
                        local cnt = #posList
                        if indicator ~= "" then
                            text = ("┃  %s %d/%d "):format(indicator, idx, cnt)
                        else
                            text = ("┃   %d/%d "):format(idx, cnt)
                        end
                        chunks = { { " " }, { text, "HlSearchLensNear" } }
                    else
                        text = ("┃   %s %d "):format(indicator, idx)
                        chunks = { { " " }, { text, "HlSearchLens" } }
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end,
            }
        end,
    },
    -- }}}

    -- {{{ nvim-scrollbar - a fancy scrollbar that shows search matches, diagnostics and git markers
    {
        "petertriho/nvim-scrollbar",
        lazy = true,
        event = "VeryLazy",

        opts = function()
            -- require("scrollbar.handlers.gitsigns").setup()
            return {
                folds = 0,
                marks = {},
                excluded_filetypes = {
                    "neo-tree",
                },
                handle = {
                    text = " ",
                    blend = 10, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
                    color = nil,
                    color_nr = nil, -- cterm
                    highlight = "CursorColumn",
                    hide_if_all_visible = true, -- Hides handle if all lines are visible
                },
                handlers = {
                    cursor = true,
                    diagnostic = true,
                    gitsigns = false, -- Requires gitsigns
                    handle = true,
                    search = true, -- Requires hlslens
                    ale = false, -- Requires ALE
                },
            }
        end,
    },
    -- }}}

    -- {{{ statuscol.nvim - allows to customize the left status columns
    {
        "luukvbaal/statuscol.nvim",

        lazy = false,

        opts = function()
            local builtin = require("statuscol.builtin")
            return {
                ft_ignore = { "neo-tree", "NVimTree", "qf", "fzf", "trouble", "startify", "help" },

                segments = {
                    {
                        hl = "FoldColumn",
                        text = {
                            function(args)
                                local t = builtin.foldfunc(args)
                                if t == "" then
                                    return ""
                                end
                                -- adds some padding
                                -- HACK: remove the end indicator to ensure proper highlights
                                return " " .. string.sub(t, 1, -3) .. " %*"
                            end,
                        },

                        click = "v:lua.ScFa",
                    },
                    -- All the other signs
                    {
                        sign = { namespace = { ".*" }, maxwidth = 1, auto = true, colwidth = 1 },
                        click = "v:lua.ScSa",
                    },
                    -- Have a separate column for git
                    {
                        sign = { namespace = { "gitsigns" }, maxwidth = 1, auto = false, colwidth = 1 },
                        click = "v:lua.ScSa",
                    },
                    -- Show diagnostics in the gutter
                    {
                        sign = { namespace = { "diagnostic" }, maxwidth = 1, auto = false, colwidth = 1 },
                        click = "v:lua.ScSa",
                    },
                    {
                        text = { builtin.lnumfunc, " " },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    },
                },

                clickhandlers = {
                    -- Disable some "dangerous" handlers. Happened once too often that I accidentally reset a hunk
                    -- without even noticing.
                    gitsigns = function(args)
                        if args.button == "l" then
                            require("gitsigns").preview_hunk()
                        elseif args.button == "m" then
                            --require("gitsigns").reset_hunk()
                        elseif args.button == "r" then
                            -- require("gitsigns").stage_hunk()
                        end
                    end,
                },
            }
        end,
    },
    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- Coding Base Plugins.

    -- {{{ nvim-treesitter - Language support (important dependency): Treesitter - Provides AST for a lot of languages.
    {
        "nvim-treesitter/nvim-treesitter",

        lazy = true,
        event = { "VeryLazy" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },

        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter.configs").setup({
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                -- List of parsers to ignore installing (or "all")
                -- ignore_install = { },

                -- Use for highlighting additional syntax elements.
                -- Be warned: this sometimes works nicely, sometimes it messes up things. Example: doxygen tags are
                -- highlighted nicely. This interferes with language server highlights too.
                highlight = {
                    enable = true,
                },

                -- Enable to indent code.
                -- WARN: It assumes some style rules. For example, in C++, indenting in namespaces is assumed to be 0. If
                -- you type 'o' to get a new line, indentation might be off if the thing is inside an indented namespace.
                --
                -- Use smartindent and cindent. They perform equally or even better in 99.9% of the time so far.
                indent = {
                    enable = false,
                },

                -- A list of parser names, or "all" (the listed parsers MUST always be installed)
                ensure_installed = {
                    -- C, CPP
                    "c",
                    "cpp",
                    "cmake",
                    "doxygen",

                    -- GPU programming
                    "glsl", -- "cuda", "opencl"

                    -- Rust
                    "rust",

                    -- C#
                    "c_sharp",

                    -- Python
                    "python",

                    -- Webdev
                    "json",
                    "jsonc",
                    "yaml",
                    "css",
                    "scss",
                    "html",
                    "javascript",
                    "typescript",
                    "jsdoc",
                    "vue",

                    -- Writing
                    "markdown",
                    "markdown_inline",

                    -- System, Scripting, ...
                    "nix",
                    "bash",
                    "lua",
                    "luadoc", -- for vim, awesome, ...
                    "vim",
                    "vimdoc",
                    "query", -- tree-sitter query syntax

                    -- QUIRK: neovim on Nix comes with these pre-installed. This caused runtime errors from time to time
                    -- (probably version mismatches). Manually installing these grammars fixes the issue by compiling them
                    -- for the correct tree-sitter version delivered with this plugin.
                    "bash",
                    "c",
                    "lua",
                    "python",
                    "vimdoc",
                    "vim",
                    "query",
                    "markdown",
                    "markdown_inline",
                },
            })
        end,

        --init = function()
        -- -- Enable folds?
        -- -- -> keep in mind that setting these will be saved in the view.
        --set foldmethod=expr
        --set foldexpr='v:lua.vim.treesitter.foldexpr()'
        --end,
    },
    -- }}}

    --{{{ Auto-close: nvim-treesitter-endwise - Automatically add end/endif/... statements in Lua, Bash, ...
    -- NOTE: disabled right now. Only works for a few languages.
    -- {
    --     "brianhuster/treesitter-endwise.nvim",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    --
    --     lazy = true,
    --     event = { "InsertEnter" },
    --
    --     config = function()
    --         require("nvim-treesitter.configs").setup({
    --             endwise = {
    --                 enable = true,
    --             },
    --         })
    --     end,
    -- },
    -- }}}

    -- {{{ Auto-close: nvim-autopairs - Automatically close braces, strings, ...
    {
        "windwp/nvim-autopairs",

        lazy = true,
        event = "InsertEnter",

        opts = {},
    },
    -- }}}

    -- {{{ Auto-close: nvim-ts-autotag - Automatically close tags in html/xml/...
    {
        "windwp/nvim-ts-autotag",

        lazy = true,
        event = { "InsertEnter" },

        opts = {
            opts = {
                -- Defaults
                enable_close = true, -- Auto close tags
                enable_rename = true, -- Auto rename pairs of tags
                enable_close_on_slash = false, -- Auto close on trailing </
            },

            -- Override settings:
            per_filetype = {
                --["html"] = { enable_close = false },
            },
        },
    },
    -- }}}

    -- {{{ indent-blankline.nvim - Provides indent level lines.
    {
        "lukas-reineke/indent-blankline.nvim",

        main = "ibl",

        lazy = true,
        event = { "BufReadPost", "BufNewFile" },

        opts = {
            -- Indent lines
            indent = {
                -- To disable indentlines, set some BG highlight group
                -- The line char
                char = "🭲",
                -- The highlight group to use
                highlight = "IndentLine",
            },

            -- Highlight the current scope? (requires teeesitter)
            scope = {
                enabled = true,
                char = "│",
                highlight = "ScopeLine",

                -- Underline the beginning/end of the scope?
                show_start = false,
                show_end = false,
            },

            -- Alternating highlight of the indent-level background
            -- whitespace = {
            --      -- Alternate these highlights
            --      highlight = { "Normal", "CursorLine" },
            --      -- Required.
            --      remove_blankline_trail = true,
            -- },
        },

        init = function()
            local hooks = require("ibl.hooks")

            -- Disable the line on level 0
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
        end,
    },
    -- }}}

    -- {{{ diffview - pretty diffs
    {
        "sindrets/diffview.nvim",

        lazy = true,
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },

        opts = {
            enhanced_diff_hl = false,
            keymaps = {
                disable_defaults = true,
            },
        },
    },

    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- Coding Plugins: LSP.

    -- {{{ Formatting: conform.nvim - Add formatters support
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },

        opts = function()
            local conform = require("conform")

            map.n("<leader>f", conform.format, { desc = "Format buffer", icon = "󰉼" })

            return {
                -- Refer to https://github.com/stevearc/conform.nvim

                -- You gave to tell conform which formatter to use per filetype :-(
                formatters_by_ft = {
                    -- C++ and related
                    cpp = { "clang-format" },
                    c = { "clang-format" },
                    cmake = { "cmake_format" },

                    -- The JS/TS/... Webdev world
                    javascript = { "prettier" },
                    typesript = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    scss = { "prettier" },
                    vue = { "prettier" },
                    json = { "prettier" },
                    jsonc = { "prettier" },
                    yaml = { "prettier" },
                    toml = { "prettier" },

                    -- For neovim and awesome ;-)
                    lua = { "stylua" },

                    -- Shell scripting, system stuff, ...
                    sh = { "shfmt" },
                    bash = { "shfmt" },
                    nix = { "nixfmt" },
                    python = { "isort", "black" },

                    -- Text
                    markdown = { "prettier" },
                },
            }
        end,
    },
    -- }}}

    -- {{{ blink.cmp - An alternative completion tool
    {
        "saghen/blink.cmp",
        -- use a release tag to download pre-built binaries
        version = "1.*",

        dependencies = {
            -- provides a lot of nice snippets
            "rafamadriz/friendly-snippets",

            -- Is used properly syntax-highlight completion items
            "xzbdmw/colorful-menu.nvim",
        },

        opts = function()
            -- {{{ Color Mapping:

            -- hl.link("BlinkCmpGhostText", "NonText")

            -- Pmenu fixes

            -- Most things properly map to the Pmenu highlights. Fix those that don't
            hl.link("BlinkCmpMenuBorder", "PmenuBorder")
            hl.link("BlinkCmpLabelMatch", "PmenuMatch")

            -- Doc fixes
            hl.link("BlinkCmpDocBorder", "FloatBorder")
            hl.link("BlinkCmpDocSeparator", "FloatSeparator")

            -- Signature fixes
            hl.link("BlinkCmpSignatureHelpBorder", "FloatBorder")

            -- Kind symbols
            hl.link("BlinkCmpKind", "LspItemKind")
            hl.link("BlinkCmpSource", "LspItemSource")

            hl.link("BlinkCmpKindMethod", "LspItemKindFunction")
            hl.link("BlinkCmpKindFunction", "LspItemKindFunction")
            hl.link("BlinkCmpKindConstructor", "LspItemKindFunction")
            hl.link("BlinkCmpKindModule", "LspItemKindFunction")

            hl.link("BlinkCmpKindStruct", "LspItemKindType")
            hl.link("BlinkCmpKindClass", "LspItemKindType")
            hl.link("BlinkCmpKindInterface", "LspItemKindType")
            hl.link("BlinkCmpKindEnum", "LspItemKindType")
            hl.link("BlinkCmpKindReference", "LspItemKindType")
            hl.link("BlinkCmpKindUnit", "LspItemKindType")

            hl.link("BlinkCmpKindText", "LspItemKindString")
            hl.link("BlinkCmpKindEnumMember", "LspItemKindValue")
            hl.link("BlinkCmpKindTypeParameter", "LspItemKindValue")
            hl.link("BlinkCmpKindValue", "LspItemKindValue")
            hl.link("BlinkCmpKindColor", "LspItemKindValue")

            hl.link("BlinkCmpKindVariable", "LspItemKindValue")
            hl.link("BlinkCmpKindConstant", "LspItemKindValue")
            hl.link("BlinkCmpKindField", "LspItemKindValue")
            hl.link("BlinkCmpKindProperty", "LspItemKindValue")
            hl.link("BlinkCmpKindEvent", "LspItemKindValue")

            hl.link("BlinkCmpKindFile", "LspItemKindFiles")
            hl.link("BlinkCmpKindFolder", "LspItemKindFiles")
            hl.link("BlinkCmpKindSnippet", "LspItemKindFiles")

            hl.link("BlinkCmpKindKeyword", "LspItemKindKeyword")
            hl.link("BlinkCmpKindOperator", "LspItemKindKeyword")
            -- }}}

            -- {{{ Config:
            --
            local config = require("config.lsp")
            local result = {
                -- refer to https://cmp.saghen.dev/configuration/keymap.html
                keymap = {
                    preset = "none",

                    -- Basics: open and select
                    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<CR>"] = { "accept", "fallback" },
                    -- ["<ESC>"] = { "cancel", "fallback" }, -- cancel bit stay in insert-mode? This feels weird when the menu auto opens!
                    ["<Up>"] = { "select_prev", "fallback" },
                    ["<Down>"] = { "select_next", "fallback" },

                    ["<Tab>"] = { "snippet_forward", "fallback" },
                    ["<S-Tab>"] = { "snippet_backward", "fallback" },

                    ["<C-k>"] = { "scroll_documentation_up" },
                    ["<C-j>"] = { "scroll_documentation_down" },

                    -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
                },

                -- Configure the completion menu and related tools
                completion = {
                    list = { selection = { preselect = false, auto_insert = false } },

                    -- Selected entry as ghost text? Keep in mind:
                    --  * AI completion plugins also show ghost text.
                    --  * Ghost text can overlap the typed text - sometimes hard to read.
                    ghost_text = {
                        enabled = false, -- its basically noise. Disable.

                        -- Show the ghost text when an item has been selected
                        show_with_selection = true,
                        -- Show the ghost text when no item has been selected, defaulting to the first item
                        show_without_selection = true,
                        -- Show the ghost text when the menu is open
                        show_with_menu = true,
                        -- Show the ghost text when the menu is closed
                        show_without_menu = true,
                    },

                    menu = {
                        --min_width = 15,
                        max_height = 20,

                        -- Make it slightly transparent
                        winblend = 0,

                        -- Own border or use vim.o.winborder?
                        -- border = "single",

                        -- Disable scrollbar.
                        scrollbar = false,

                        draw = {
                            -- Gap between components
                            gap = 1,

                            -- We don't need label_description now because label and label_description are already
                            -- combined together in label by colorful-menu.nvim.
                            columns = {
                                { "kind_icon" },
                                {
                                    "label",
                                    -- Not needed when using colorful-menu. It provides the label_description
                                    -- "label_description",
                                    gap = 1,
                                },
                                { "source_name" },
                            },

                            padding = {
                                -- Padding between the left border and the first component
                                0,

                                -- Padding between the right border and the last component
                                0,
                            },

                            components = {
                                kind_icon = {
                                    ellipsis = false,
                                    text = function(ctx)
                                        local icon = ctx.kind_icon
                                        -- A more flexible mapping. Alternative to appearance.kind_icons
                                        -- local icon = config.kindIcons[ctx.kind] or "?"
                                        return " " .. ctx.icon_gap .. icon .. ctx.icon_gap .. " "
                                    end,
                                },

                                source_name = {
                                    ellipsis = false,
                                    text = function(ctx)
                                        local icon = config.sourceIcons[
                                            ({
                                                -- Map the source_name values to those config.sourceIcons uses.
                                                Buffer = "buffer",
                                                Path = "path",
                                                LSP = "lsp",
                                                Snippets = "snippet",
                                                Copilot = "ai",
                                            })[ctx.source_name] or "unknown"
                                        ] or ctx.source_name

                                        return " " .. ctx.icon_gap .. icon .. ctx.icon_gap .. " "
                                    end,
                                },

                                label = {
                                    text = function(ctx)
                                        return require("colorful-menu").blink_components_text(ctx)
                                    end,
                                    highlight = function(ctx)
                                        return require("colorful-menu").blink_components_highlight(ctx)
                                    end,
                                },
                            },
                        },
                    },
                    documentation = {
                        -- Automatically show the doc for the selected symbol
                        auto_show = true,
                        -- Delay?
                        auto_show_delay_ms = 500,

                        -- Styling:
                        window = {
                            -- Own border or use vim.o.winborder?
                            -- border = "single",
                        },
                    },
                },

                -- Displays a signature hover window when typing.
                signature = {
                    enabled = true,

                    trigger = {
                        -- Show the signature help window when entering insert mode
                        show_on_insert = true,
                    },

                    -- Styling
                    window = {
                        -- Own border or use vim.o.winborder?
                        -- border = "single",
                    },
                },

                -- Completion in command line?
                cmdline = {
                    enabled = true,

                    -- The completion menu should only be opened when explicitly pressing tab/c-space.
                    keymap = {
                        -- Use the same keymap BUT tab should open the menu
                        preset = "inherit",

                        ["<Tab>"] = { "show_and_insert", "select_next" },
                        ["<S-Tab>"] = { "show_and_insert", "select_prev" },
                        ["<CR>"] = { "accept", "fallback" },
                        ["<ESC>"] = {
                            -- This closes the menu of it is open. Thanks to  https://github.com/Saghen/blink.cmp/issues/547
                            function(cmp)
                                if cmp.is_visible() then
                                    cmp.cancel()
                                else
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes("<C-c>", true, true, true),
                                        "n",
                                        true
                                    )
                                end
                            end,
                        },
                    },
                    completion = {
                        list = {
                            selection = {
                                preselect = false,
                                auto_insert = true,
                            },
                        },

                        menu = { auto_show = false },
                        ghost_text = { enabled = false },
                    },
                },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = "Nerd Font Mono",

                    kind_icons = config.kindIcons,
                },

                -- Completion sources. This also allows for a lot of customization
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },

                    -- Minimum number of characters in the keyword to trigger all providers
                    -- May also be `function(ctx: blink.cmp.Context): number`
                    min_keyword_length = 3,
                },

                -- Configure fuzzy finding
                fuzzy = {
                    implementation = "prefer_rust_with_warning",

                    -- Allows to customize the sorting of entries.
                    -- sorts = {
                    --    -- defaults
                    --    "score",
                    --    "sort_text",
                    -- },
                },
            }
            -- }}}

            return result
        end,
        opts_extend = { "sources.default" },
    },
    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- Coding Plugins: IDE-like fluff.

    -- {{{ todo-comments.nvim - Highlight TOOD/FIX/... keywords in comments
    {
        "folke/todo-comments.nvim",

        dependencies = { "nvim-lua/plenary.nvim" },

        lazy = true,
        event = { "BufReadPost", "BufNewFile" },

        opts = {
            signs = false,

            highlight = {

                -- Hightlight the line before and after the keyword?
                after = "", -- "fg" or "bg" or empty
                before = "", -- "fg" or "bg" or empty

                keyword = "fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)

                -- The match pattern. To require the ":" after the keyword, mention it here
                pattern = [[.*<(KEYWORDS)\s*:]],
                -- Only highlight in comments (requires Treesitter)
                comments_only = true,
            },
            colors = {
                -- Can be one or more hl groups or hex colors as strings. Uses the first matching color.
                error = { "DiagnosticError" },
                warning = { "DiagnosticWarn" },
                info = { "DiagnosticWarn" },
                hint = { "DiagnosticHint" },
                default = { "Identifier" },
                test = { "Identifier" },
            },
        },
    },
    -- }}}

    -- {{{ trouble.nvim - nicely show lsp and diagnostic info
    {
        "folke/trouble.nvim",
        lazy = true,
        event = { "VeryLazy" },

        opts = function()
            hl.link("TroubleNormal", "SidebarNormal")
            hl.link("TroubleNormalNC", "SidebarNormal")
            hl.set("TroubleIndent", hl.extended("FoldColumn", { bg = "NONE" }))

            -- Open trouble automatically after commands like :grep or :make
            vim.api.nvim_create_autocmd("QuickFixCmdPost", {
                callback = function()
                    vim.cmd([[Trouble qflist open]])
                end,
            })

            -- Open Trouble whenever a quickfix/loclist should open
            vim.api.nvim_create_autocmd("BufRead", {
                callback = function(ev)
                    if vim.bo[ev.buf].buftype == "quickfix" then
                        vim.schedule(function()
                            vim.cmd([[cclose]])
                            vim.cmd([[Trouble qflist open]])
                        end)
                    end
                end,
            })

            -- map.group("<leader>x", "Exploration", "󱣱")

            map.n("<leader>cb", function()
                require("trouble").toggle("lsp")
            end, { desc = "Code Browser", icon = "" })

            map.n("<leader>cx", function()
                require("trouble").toggle("diagnostics")
            end, { desc = "Diagnostics", icon = "" })

            map.n("<leader>cs", function()
                require("trouble").toggle("symbols")
            end, { desc = "Symbol Browser", icon = "" })

            map.n("<leader>cr", function()
                require("trouble").open({
                    mode = "lsp_references",
                    auto_refresh = false,
                    follow = false,
                    pinned = true,
                })
            end, { desc = "References", icon = "" })

            map.n("|", function()
                local trouble = require("trouble")

                local diagOpen = trouble.is_open()
                if not diagOpen then
                    trouble.toggle("diagnostics")
                else
                    trouble.close()
                end
            end, {})

            return {
                -- Show a preview per click?
                auto_preview = false,

                warn_no_results = false,
                open_no_results = false,

                win = { size = 0.33 },

                modes = {
                    symbols = {
                        focus = false,
                        win = { type = "split", position = "right" },
                        filter = { buf = 0 }, -- show buffer local info only
                    },
                    diagnostics = {
                        focus = true,
                        win = { size = 0.20 },
                        filter = { buf = 0 }, -- show buffer local info only
                    },
                },
            }
        end,
    },
    -- }}}

    -- {{{ vim-doge to generate doc for functions.
    {
        "seichelbaum/vim-doge",

        build = ":call doge#install()",

        init = function()
            vim.cmd([[
                let g:doge_enable_mappings = 0
                let g:doge_doxygen_settings = {
                \  'char': '@'
                \}
            ]])

            map.n("<Leader>d", "<Plug>(doge-generate)", {
                desc = "Generate Doc",
                icon = "󱪞",
            })

            -- Interactive mode comment todo-jumping
            vim.keymap.set("n", "<TAB>", "<Plug>(doge-comment-jump-forward)")
            vim.keymap.set("n", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")
            vim.keymap.set("i", "<TAB>", "<Plug>(doge-comment-jump-forward)")
            vim.keymap.set("i", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")
            vim.keymap.set("x", "<TAB>", "<Plug>(doge-comment-jump-forward)")
            vim.keymap.set("x", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")
        end,
    },
    -- }}}

    -- {{{ markview.nvim - makes markdown a bit more pretty
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        opts = {
            preview = {
                filetypes = {
                    -- Use it in markdown? Be aware: this switches from preview to native markdown when entering insert
                    -- mode. This can be annoying and shifts the text (visually)!
                    -- "markdown",

                    -- Make the AI chat a bit more pretty
                    "codecompanion",
                },
                ignore_buftypes = {},

                -- Preview in all Modes. This reduces the nasty "flicker" when switching between normal and insert mode.
                modes = { "n", "no", "c", "i", "v", "V", "s" },
            },
        },
    },
    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- Nice-to-have Plugins.

    -- {{{ Syntax and Style: nvim-colorizer - Provides coloring of hex/css colors.
    {
        "catgoose/nvim-colorizer.lua",

        lazy = true,
        event = "VeryLazy",

        opts = {
            lazy_load = true,

            filetypes = {
                -- "*", -- everywhere? Bad Idea. Use :ColorizerToggle to enable the colorizer when needed
                "css",
                "html",
                "vue",
                "javascript",
                "lua",
            },
            user_default_options = {
                -- Highlighting mode.  'background'|'foreground'|'virtualtext'
                mode = "virtualtext",
                -- virtualtext = "■",
                -- virtualtext = "󱥚 ",
                virtualtext = " ",
                virtualtext_inline = "after", -- 'before', 'after', boolean (false = end of line, true = 'after')
                virtualtext_mode = "foreground",
                -- update color values even if buffer is not focused
                always_update = false,

                -- Names like "blue"? Note that names_opts allows for more detailed config options. Refer to the
                -- official github page.
                names = true, -- "Name" codes like Blue or red.
                names_opts = {
                    lowercase = true,
                    camelcase = true,
                    uppercase = true,
                    strip_digits = true, -- ignore names with digits?
                },

                -- RGB hex codes like '#ffaaaa'
                RGB = true,
                RGBA = true,
                RRGGBB = true,
                -- RGBA? Keep in mind that this blends with the background color.
                RRGGBBAA = true,
                AARRGGBB = true, -- 0xAARRGGBB hex codes

                -- Interpret rgb(200, 50, 25), rgba(90,0,0,1), hsl(20, 70%, 50%)
                rgb_fn = true,
                hsl_fn = true,
            },
        },
    },
    -- }}}

    --------------------------------------------------------------------------------------------------------------------
    -- AI integrations

    -- {{{ GitHub Copilot integration
    {
        "github/copilot.vim",

        lazy = false, -- must be loaded when starting!

        -- Remap Copilot to Alt-Enter and Alt-Up/Down to navigate through suggestions.
        init = function()
            vim.g.copilot_no_tab_map = true

            vim.g.copilot_filetypes = {
                codecompanion = false,
            }

            -- vim.keymap.set("i", "<A-Up>", "<Plug>(copilot-previous)")
            -- vim.keymap.set("i", "<A-Down>", "<Plug>(copilot-next)")
            -- vim.keymap.set("i", "<A-S-CR>", "<Plug>(copilot-accept-line)")
            --
            -- map.group("<leader>c", "AI", "")

            map.i("<A-CR>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,

                desc = "AI: accept",
                icon = "",
            })

            map.i("<A-S-CR>", "<Plug>(copilot-accept-line)", { desc = "AI: accept Line", icon = "󰸟" })

            map.i("<A-Up>", "<Plug>(copilot-previous)", { desc = "AI: prev completion", icon = "󰁭" })
            map.i("<A-Down>", "<Plug>(copilot-next)", { desc = "AI: next completion", icon = "󰵵" })

            hl.link("CopilotSuggestion", "NonText")
        end,
    },
    -- }}}

    -- {{{ Code Companion - Provides AI chat and agent workflows - no support for inline suggestions.
    {
        "olimorris/codecompanion.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-treesitter/nvim-treesitter",
            -- "nvim-treesitter/nvim-treesitter",

            -- Extensions
            "ravitemer/codecompanion-history.nvim",
        },

        lazy = true,
        event = "VeryLazy",

        opts = function()
            map.group("<leader>a", "AI", "")

            map.n("<A-\\>", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Chat", icon = "󱋊" })
            map.v("<A-\\>", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add to Chat", icon = "󱐒" })

            map.n("<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Togle Chat", icon = "󱋊" })
            map.v("<leader>ac", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add to Chat", icon = "󱐒" })

            map.n("<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "Actions", icon = "" })
            map.v("<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "Actions", icon = "" })

            map.v("<leader>ae", "<cmd>:CodeCompanion /explain<CR>", { desc = "Explain", icon = "󱧣" })

            -- For codecompanion buffers, override some keymaps.

            local group = vim.api.nvim_create_augroup("markdown_autocommands", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "codecompanion" },
                callback = function(_)
                    -- NOTE: others are overwritten by the config options below.

                    -- Switch through chat history
                    map.buf.n(0, "<leader><s-tab>", "<nop>", { desc = "Prev Chat", icon = "" })
                    map.buf.n(0, "<leader><tab>", "<nop>", { desc = "Next Chat", icon = "" })

                    map.buf.n(0, "<leader>ax", function() end, { desc = "Clear Chat", icon = "󰧧" })

                    -- Close chat
                    map.buf.n(
                        0,
                        "<leader>q",
                        "<cmd>CodeCompanionChat Toggle<CR>",
                        { desc = "Close Chat", icon = "󱐔" }
                    )
                end,

                group = group,
            })

            return {
                display = {
                    chat = {
                        auto_scroll = false, -- do not scroll with LLM responses. This is annoying when reading.

                        window = {
                            layout = "float", -- float|vertical|horizontal|buffer
                            position = "top", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
                            border = "rounded",
                            height = 0.8,
                            width = 0.75,

                            opts = {
                                -- signcolumn = "yes:2",
                            },
                        },
                    },
                },
                strategies = {
                    chat = {
                        keymaps = {
                            send = {
                                modes = { n = "<A-CR>", i = "<A-CR>" },
                                opts = {},
                            },
                            clear = {
                                modes = { n = "<leader>ax" },
                                opts = {},
                            },
                        },
                        opts = {
                            ---Decorate the user message before it's sent to the LLM? VSCode wraps the user prompt in a
                            ---<prompt> tag. Replicate this here.
                            prompt_decorator = function(message, adapter, context)
                                return string.format([[<prompt>%s</prompt>]], message)
                            end,

                            slash_commands = {
                                ["file"] = {
                                    opts = { provider = "fzf_lua" },
                                },
                                ["buffer"] = {
                                    opts = { provider = "fzf_lua" },
                                },
                            },
                        },
                    },
                },
                extensions = {
                    history = {
                        enabled = true,
                        opts = {
                            keymap = "<leader>e",
                            save_chat_keymap = "<leader>w",
                            auto_save = false,
                            expiration_days = 0,
                            picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
                            -- Customize picker keymaps (optional)
                            picker_keymaps = {
                                rename = { n = "r", i = "<M-r>" },
                                delete = { n = "d", i = "<M-d>" },
                                duplicate = { n = "<C-y>", i = "<C-y>" },
                            },

                            -- Automatically generate titles for new chats
                            auto_generate_title = true,
                            title_generation_opts = {
                                adapter = nil, -- nil = current
                                model = nil,
                                refresh_every_n_prompts = 3,
                                max_refreshes = 3,
                            },

                            continue_last_chat = false, -- buggy!
                            delete_on_clearing_chat = true,

                            ---Directory path to save the chats

                            -- Load history based on the project root
                            -- NOTE: the project root and cwd are the same in this config (managed by nvim-rooter).
                            chat_filter = function(chat_data)
                                return chat_data.cwd == vim.fn.getcwd()
                            end,
                        },
                    },
                },
            }
        end,
    },
    -- }}}
}
