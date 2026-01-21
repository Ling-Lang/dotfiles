-- ==========================================
-- 1. PLUGINS (vim-plug)
-- ==========================================
local Plug = vim.fn['plug#']

vim.call('plug#begin')
    Plug 'https://github.com/vim-syntastic/syntastic'
    Plug 'https://github.com/joshdick/onedark.vim'
    Plug 'https://github.com/vim-airline/vim-airline'
    Plug 'mhinz/vim-startify'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'catppuccin/nvim'
    -- Das neue nvim-tree Plugin (benötigt Neovim 0.9+)
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-tree/nvim-web-devicons' -- Icons für Dateien
vim.call('plug#end')

-- ==========================================
-- 2. NVIM-TREE SETUP (WICHTIG!)
-- ==========================================
-- ==========================================
-- 5. NVIM-TREE SETUP (MIT H/L NAVIGATION)
-- ==========================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.clipboard:append('unnamedplus')
-- Diese Funktion definiert die Tastenbelegung
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 1. Standard-Tasten laden (damit 'd' löschen, 'r' umbenennen usw. noch geht)
  api.config.mappings.default_on_attach(bufnr)

  -- 2. Eigene Tasten hinzufügen
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open')) -- Enter bleibt auch aktiv
end

-- Setup aufrufen
require("nvim-tree").setup({
  on_attach = my_on_attach, -- Hier binden wir die Funktion ein
  sort = { sorter = "case_sensitive" },
  view = { width = 30 },
  renderer = { group_empty = true },
})

-- Tastenkürzel global: Strg+n öffnet den Tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


require('lualine').setup {
  options = {
    theme = 'catppuccin-macchiato', -- Hier setzen wir das Theme direkt
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
}

-- TASTENKÜRZEL: Strg + n öffnet/schließt den Tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- ==========================================
-- 3. SONSTIGE EINSTELLUNGEN
-- ==========================================
vim.opt.number = true
vim.cmd("syntax on")
vim.opt.termguicolors = true -- Wichtig für Icons Farben

-- Airline Konfiguration

-- Theme aktivieren
local status_ok, _ = pcall(vim.cmd, "colorscheme catppuccin-macchiato")
if not status_ok then
    print("Info: Farbschema 'onedark' nicht gefunden (evtl. :PlugInstall ausführen)")
end
