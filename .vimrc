let mapleader=" "

set cursorline
set expandtab
set incsearch
set relativenumber
set nocompatible
set nowrap
set number
set wildmenu
set shiftwidth=4
set tabstop=4

filetype on
filetype indent on

syntax on

nnoremap <silent> <leader>s <CMD>:w<CR>
nnoremap <silent> <C-s> <CMD>:w<CR>

nnoremap <C-q> <CMD>:q<CR>
nnoremap <leader>q <CMD>:q<CR>
nnoremap <leader>Q <CMD>:q!<CR>
