" ==========================================
" 1. BASIC SETTINGS
" ==========================================
" Wichtig: Vim-Defaults statt Vi-Kompatibilität
set nocompatible

" Leader Key auf Space setzen
let mapleader = " "
let maplocalleader = " "

" UI Basics
set number              " Zeilennummern
set syntax=on           " Syntax Highlighting
set title               " Dateiname im Terminal-Titel
set mouse=a             " Mausunterstützung aktivieren
set encoding=utf-8      " UTF-8 erzwingen

" Tabs & Indents (Exakt wie in deiner nvim config)
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set autoindent
set smartindent

" Clipboard (Versucht System-Clipboard zu nutzen)
set clipboard=unnamedplus

" Suche
set ignorecase          " Groß/Kleinschreibung ignorieren...
set smartcase           " ...außer man tippt Großbuchstaben
set incsearch           " Springt schon während des Tippens
set hlsearch            " Treffer hervorheben

" Performance (macht Vim über SSH schneller)
set ttyfast
set lazyredraw

" ==========================================
" 2. KEYMAPS (Deine Gewohnheiten)
" ==========================================
" Space macht nichts im Normal/Visual Mode
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Wrap umschalten mit Leader+w
nnoremap <silent> <leader>w :set wrap!<CR>

" Config Reload mit Leader+R
nnoremap <leader>R :source $MYVIMRC<CR>:echo "Vim Config neu geladen!"<CR>

" Suche löschen mit Leader+h (Sehr nützlich!)
nnoremap <silent> <leader>h :nohlsearch<CR>

" Schnelleres Speichern/Beenden
nnoremap <leader>q :q<CR>
nnoremap <leader>s :w<CR>

" ==========================================
" 3. ERSATZ FÜR PLUGINS (Bordmittel)
" ==========================================

" --- Farben (Statt Catppuccin) ---
" 'desert' oder 'slate' sind auf 99% aller Server installiert
" und sehen gut aus.
try
    colorscheme desert
catch
    colorscheme default
endtry

" --- File Explorer (Statt NvimTree) ---
" Wir tunen das eingebaute 'netrw', damit es wie ein Tree aussieht.
let g:netrw_banner = 0        " Den Header oben ausblenden
let g:netrw_liststyle = 3     " Baum-Ansicht (Tree View)
let g:netrw_browse_split = 4  " Öffnet Dateien im vorigen Fenster
let g:netrw_altv = 1          " Splits rechts öffnen
let g:netrw_winsize = 25      " Breite des Explorers

" Toggle Netrw mit Leader+q (wie in deiner Nvim Config)
" (Das ist ein kleiner Hack, da netrw kein echtes Toggle hat)
nnoremap <leader>q :Lexplore<CR>

" --- Statusline (Statt Lualine) ---
" Eine einfache, aber informative Statuszeile ohne Powerline-Fonts
set laststatus=2
set statusline=
set statusline+=\ %M\       " Modified flag [+]
set statusline+=\ %y\       " Filetype [vim]
set statusline+=\ %r\       " Readonly flag [RO]
set statusline+=\ %F\       " Full file path
set statusline+=%=          " Trenner (rechtsbündig ab hier)
set statusline+=\ [%c:%l]\  " Spalte : Zeile
set statusline+=\ %p%%\     " Prozentzahl

" --- Autocomplete (Statt COC) ---
" Vim hat eingebautes Autocomplete mit Strg+n oder Strg+p.
" Wir machen das Menü etwas hübscher.
set wildmenu
set wildmode=longest:full,full
