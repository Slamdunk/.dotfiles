
set nocompatible

syntax on

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set autoindent
set background=dark
set backspace=indent,eol,start
set expandtab
set ignorecase
set incsearch
set laststatus=2
set nobackup
set nopaste
set noundofile
set number
set scrolloff=5
set shiftwidth=4
set showcmd
set smartcase
set smartindent
set softtabstop=4
set tabstop=4
set wildmenu
set wildmode=full

if has("autocmd")
    filetype plugin indent on
endif

nnoremap  
