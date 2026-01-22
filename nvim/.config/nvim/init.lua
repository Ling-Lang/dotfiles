local Plug = vim.fn['plug#']
local hostname = vim.fn.hostname()
vim.call('plug#begin')
    Plug 'https://github.com/vim-syntastic/syntastic'
    Plug 'https://github.com/joshdick/onedark.vim'
    Plug 'https://github.com/vim-airline/vim-airline'
    Plug 'mhinz/vim-startify'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'catppuccin/nvim'
    Plug('neoclide/coc.nvim', {branch='release'})
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
    Plug 'abecodes/tabout.nvim'
    -- Das neue nvim-tree Plugin (benötigt Neovim 0.9+)
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-tree/nvim-web-devicons' -- Icons für Dateien
    if hostname == "dylanMain" then
    	vim.fn['plug#']('vyfor/cord.nvim')
    end
vim.call('plug#end')

-- ==========================================
-- 3. SONSTIGE EINSTELLUNGEN (Nach oben verschoben, damit Basics immer gehen)
-- ==========================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.cmd("syntax on")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.opt.clipboard:append('unnamedplus')
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>set wrap!<CR>', { silent = true })
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("source $MYVIMRC")
    print("Neovim Config wurde neu geladen!")
end, { silent = true })
-- ==========================================
-- 2. NVIM-TREE SETUP (GESCHÜTZT)
-- ==========================================
-- Wir versuchen nvim-tree zu laden. Wenn es fehlschlägt (weil noch nicht installiert),
-- brechen wir diesen Block ab, damit PlugInstall laufen kann.
local status_tree, nvim_tree = pcall(require, "nvim-tree")

if not status_tree then
    print("Info: nvim-tree nicht gefunden (wird installiert...)")
else
    -- ALLES was nvim-tree betrifft kommt HIER rein
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    end

    nvim_tree.setup({
        on_attach = my_on_attach,
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = { group_empty = true },
    })

    -- Tastenkürzel nur setzen, wenn Plugin da ist
    vim.keymap.set('n', '<leader>q', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
end

-- ==========================================
-- LUALINE SETUP (GESCHÜTZT)
-- ==========================================
local status_lualine, lualine = pcall(require, "lualine")
if not status_lualine then
     print("Info: lualine nicht gefunden (wird installiert...)")
else
    lualine.setup {
        options = {
            theme = 'catppuccin-macchiato',
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
local cord = pcall(require, "cord")
if not cord then
	print("Info: Cord nicht gefunden (wird installiert...)")
else
	if hostname == "dylanMain" then
    		require('cord').setup({})
	end
end
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

-- Mapping für TAB
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#confirm() : "<TAB>"', opts)
-- THEME SETUP
-- ==========================================
local status_theme, _ = pcall(vim.cmd, "colorscheme catppuccin-macchiato")
if not status_theme then
    print("Info: Farbschema nicht gefunden (wird installiert...)")
end
