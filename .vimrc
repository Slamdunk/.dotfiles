
set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
    " https://vimawesome.com/plugin/fzf-vim
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " https://vimawesome.com/plugin/lightline-vim
    Plug 'itchyny/lightline.vim'

    " https://vimawesome.com/plugin/vim-gitbranch
    Plug 'itchyny/vim-gitbranch'

    " https://vimawesome.com/plugin/vim-multiple-cursors
    Plug 'terryma/vim-multiple-cursors'

    " https://vimawesome.com/plugin/tcomment
    Plug 'tomtom/tcomment_vim'

    " https://vimawesome.com/plugin/vim-gutentags
    "Plug 'ludovicchabant/vim-gutentags'

    " https://vimawesome.com/plugin/ale
    Plug 'w0rp/ale'

    " https://vimawesome.com/plugin/phpcd-vim-the-thing-itself
    Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer.phar install' }
call plug#end()

let g:lightline = {
    \   'active': {
    \     'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']]
    \   },
    \   'component_function': {
    \     'gitbranch': 'gitbranch#name'
    \   },
    \ }

syntax on

"let g:gutentags_cache_dir = '~/.vim/gutentags'
"let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
"                            \ '*.phar', '*.ini', '*.rst', '*.md',
"                            \ '*vendor/*/test*', '*vendor/*/Test*',
"                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
"                            \ '*/cache/*', '*/log*',
"                            \ '*/tmp/*']
"let g:gutentags_project_root = ['composer.json']

let g:ale_linters = {
    \   'php': ['php'],
    \}
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

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

" nnoremap  

