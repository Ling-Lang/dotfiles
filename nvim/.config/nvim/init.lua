-- ==========================================
-- 1. BASIC SETTINGS (Startet sofort schnell)
-- ==========================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.syntax = "on" -- In Lua ist das vim.opt.syntax etwas anders, vim.cmd ist sicherer hier
vim.cmd("syntax on")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.opt.clipboard:append('unnamedplus')

-- Keymaps (Basics)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>set wrap!<CR>', { silent = true })

-- Config Reload
vim.keymap.set("n", "<leader>R", function()
    vim.cmd("source $MYVIMRC")
    print("Neovim Config wurde neu geladen!")
end, { silent = true })

-- ==========================================
-- 2. LAZY.NVIM BOOTSTRAP (Installiert sich selbst)
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. PLUGIN DEFINITIONEN
-- ==========================================
require("lazy").setup({
    -- Farbschema
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },

    -- Icons (wichtig für NvimTree & Lualine)
    "nvim-tree/nvim-web-devicons",

    -- Statusleiste
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'catppuccin-mocha',
                    component_separators = '|',
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 }, },
                    lualine_b = { 'filename', 'branch' },
                    lualine_c = { 'fileformat' },
                    lualine_x = {},
                    lualine_y = { 'filetype', 'progress' },
                    lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 }, },
                },
            }
        end
    },

-- Treesitter (Highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master", -- <--- DAS IST DIE RETTUNG! Zwingt ihn auf die stabile Version.
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end
    },
    -- File Explorer (NvimTree)
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Netrw deaktivieren (empfohlen für NvimTree)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                -- Deine Custom Mappings
                vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
            end

            require("nvim-tree").setup({
                on_attach = my_on_attach,
                sort = { sorter = "case_sensitive" },
                view = { width = 30 },
                renderer = { group_empty = true },
            })

            -- Globale Hotkeys für den Tree
            vim.keymap.set('n', '<leader>q', ':NvimTreeToggle<CR>', { silent = true })
            vim.keymap.set('n', '<leader>e', ':NvimTreeFindFile<CR>', { silent = true })
        end
    },

    -- Autocomplete & LSP (COC)
    {
        "neoclide/coc.nvim",
        branch = "release",
        config = function()
            -- Hier kommt dein Tab-Mapping hin (Vimscript ist hier am sichersten für coc)
            vim.cmd[[
              inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<Plug>(Tabout)"
            ]]
        end
    },

    -- Tabout (Rausspringen aus Klammern)
    {
        "abecodes/tabout.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "neoclide/coc.nvim" },
        config = function()
            require('tabout').setup {
                tabkey = '', -- Wir managen das Tab-Mapping manuell (siehe coc config oben)
                backwards_tabkey = '',
                act_as_tab = true,
                act_as_shift_tab = false,
                enable_backwards = true,
                completion = false,
                tabouts = {
                    {open = "'", close = "'"},
                    {open = '"', close = '"'},
                    {open = '`', close = '`'},
                    {open = '(', close = ')'},
                    {open = '[', close = ']'},
                    {open = '{', close = '}'}
                },
                ignore_beginning = true,
            }
        end
    },

    -- Discord Rich Presence (Nur auf deinem Main PC)
    {
        "vyfor/cord.nvim",
        build = "./build",
        event = "VeryLazy",
        -- Das Plugin wird nur geladen, wenn cond = true ist
        cond = function()
            return vim.fn.hostname() == "dylanMain"
        end,
        config = function()
            require('cord').setup({})
        end
    },

    -- Sonstiges
    'vim-syntastic/syntastic',
    'mhinz/vim-startify',
})
