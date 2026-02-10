-- Configure the user-facing parts of the LSP in Neovim.
-- LSP Completion menus are provided by plugins like nvim-cmp/blink.cmp.

local map = require("util.keymap")

local M = {}

-- {{{ LSP Base Setup

-- Disable logging as it can grow quite large over time.
-- Available levels: "off", "error", "warn", "info", "debug", "trace"
vim.lsp.set_log_level("off")

-- }}}

--{{{ Key Mappings
-- Called, once a LSP server is attached to a buffer. Use this to setup key bindings. The bufnr is given.
M.mappings = function(bufnr)
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    map.group("<leader>c", "Code & LSP", "")

    map.buf.n(bufnr, "<leader>cf", function()
        vim.lsp.buf.code_action({
            apply = true,
        })
    end, { desc = "Code fix", icon = "󰁨" })

    map.buf.n(bufnr, "<leader>ff", function()
        vim.lsp.buf.code_action({
            apply = true,
        })
    end, { desc = "Fast code fix", icon = "󰁨" })

    map.buf.n(bufnr, "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration", icon = "" })
    map.buf.n(bufnr, "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition", icon = "󰅲" })
    map.buf.n(bufnr, "<leader>ci", vim.lsp.buf.implementation, { desc = "Go to implementation", icon = "󰅩" })
    map.buf.n(bufnr, "<leader>ct", vim.lsp.buf.type_definition, { desc = "Go to type-definition", icon = "" })

    map.n("<leader>c<F2>", vim.lsp.buf.rename, { desc = "Rename symbol", icon = "" })
    map.buf.n(bufnr, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", icon = "󰁨" })

    map.buf.n(bufnr, "<leader>cI", vim.lsp.buf.hover, { desc = "Hover info", icon = "" })
    map.buf.n(bufnr, "<leader>cS", vim.lsp.buf.signature_help, { desc = "Signature help", icon = "󰊕" })

    map.buf.n(bufnr, "<leader>cS", vim.lsp.buf.signature_help, { desc = "Signature help", icon = "󰊕" })

    map.buf.n(bufnr, "<leader>ch", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Inlay Hint", icon = "󰷻" })

    -- NOTE: refer to the plugins config. There are probably plugins that provide nicer lists.
    -- map.buf.n(bufnr, "<leader>cr", vim.lsp.buf.references, { desc = "References", icon = "󰈇" })
    -- map.buf.n(bufnr, "<leader>ch", vim.lsp.buf.typehierarchy, { desc = "Type hierarchy", icon = "" })
end
--}}}

-- {{{ Default LSP configuration
vim.lsp.config("*", {
    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a certain file or dir. Files that share a root directory will reuse
    -- the connection to the same LSP server. Nested lists indicate equal priority, see |vim.lsp.Config|.
    -- NOTE: these lists do not merge! You have to add '.git' to each individual LSP root_marker
    root_markers = {
        ".git",
    },

    -- Specific settings to send to the server. The schema for this is  defined by the server itself.
    settings = {},

    -- Called when attaching a LSP to a buffer. By default, this sets up the mappings and configures capabilities
    on_attach = function(client, bufnr)
        M.mappings(bufnr)

        -- Disable semantic highlights/tokens? Also refer to treesitter highlighting.
        client.server_capabilities.semanticTokensProvider = false
    end,

    -- Some default capabilities to en/disable. These should actually be set by the completion plugins in most cases.
    capabilities = {
        -- Fold code?
        -- To enable, set foldmethod=expr and vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
        -- NOTE: treesitter also provides something like that. You might want to enable this per language.
        -- textDocument = {
        --     foldingRange = {
        --         dynamicRegistration = false,
        --         lineFoldingOnly = true,
        --     },
        -- },

        -- Multi-line semantic tokens help to properly highlight single tokens spanning multiple lines. An example would
        -- be a multi-line string.
        -- textDocument = {
        --     semanticTokens = {
        --       multilineTokenSupport = true,
        --     }
        -- }
    },
})
-- }}}

-- {{{ LSP configurations
--
-- nvim-lspconfig is basically a collection of default configs. Check their repo for defaults and clues on how to set up
-- a specific LSP: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
--
-- NOTE: as an alternative, just use nvim-lspconfig. It pre-configures everything. (vim.lsp.enable is still needed
-- though).
M.servers = {
    -- {{{ Cmake, C, C++, Cuda, Objective-C, Objective-CPP and similar
    clangd = {
        cmd = { "clangd", "--experimental-modules-support" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
            ".git",
        },

        init_options = {
            fallbackFlags = { "--std=c++23" },
        },
    },
    cmake = {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        root_markers = { "CMakePresets.json", "CTestConfig.cmake", "build", "cmake", ".git" },

        init_options = {
            buildDirectory = "build",
        },
    },
    -- }}}

    -- {{{ Lua
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git",
        },

        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        -- VIM
                        "vim",
                        "require",
                        -- AwesomeWM
                        "awesome",
                        "client",
                        "tag",
                        "screen",
                        "root",
                    },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    -- }}}

    -- {{{ Nix
    nixd = {
        cmd = { "nixd" },
        filetypes = { "nix" },
        root_markers = { ".git" },

        settings = {},
    },
    -- }}}

    -- {{{ Bash
    bash_ls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "bash", "sh" },
        root_markers = { ".git" },

        settings = {
            bashIde = {
                globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
            },
        },
    },
    -- }}}

    -- {{{ Javascript, Typescript, Vue, ...
    ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
        },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

        init_options = { hostInfo = "neovim" },
    },
    -- vue_ls = {},
    -- }}}

    --{{{ JSON
    json_ls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },

        init_options = {
            provideFormatter = true,
        },

        capabilities = {
            -- According to the docs, snippet support must be enabled for this LS
            textDocument = { completion = { completionItem = { snippetSupport = true } } },
        },
    },
    -- }}}

    -- TODO: python
    -- TODO: rust
    -- TODO: c#
}

-- Apply the defined configurations.
M.apply = function()
    -- Enable and configure these.
    for lsp, lspCfg in pairs(M.servers) do
        vim.lsp.enable(lsp)
        vim.lsp.config(lsp, lspCfg)
    end
end

-- }}}

------------------------------------------------------------------------------------------------------------------

-- {{{ Styling defaults

-- The icons used for each symbol kind in completion menus
M.kindIcons = {
    -- Callable things
    Function = "󰊕",
    Method = "󰊕",
    Constructor = "",

    -- Classes and Types
    Interface = "󱡠", -- ""
    Class = "",
    Struct = "",
    Enum = "",
    -- NOTE: this is a namespace in C++
    Module = "",

    -- Value-things
    Value = "󰎠",
    Text = "󰉿",
    EnumMember = "",
    TypeParameter = "",

    -- Variable things (named symbols)
    Variable = "󰫧",
    Field = "",
    Property = "",
    Constant = "󰏿",
    Event = "",

    -- Keywords and statements
    Operator = "󰆕",
    Keyword = "",

    Reference = "󰈇",
    File = "",
    Folder = "",
    Color = "",
    Unit = "",

    Snippet = "󱄽",

    -- Required by the plugin config for undefined/new/unknown symbols
    Default = "",
}

-- The icons that denote the source of the completion entry. (aka menu icon)
M.sourceIcons = {
    ai = "",
    buffer = "",
    path = "",
    lsp = "󰅴",
    snippet = "󱄽",
    unknown = "?",
}
-- }}}

return M
