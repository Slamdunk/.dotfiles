set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
    " https://vimawesome.com/plugin/fzf-vim
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --xdg --no-update-rc' }
    Plug 'junegunn/fzf.vim'

    " https://vimawesome.com/plugin/lightline-vim
    "Plug 'itchyny/lightline.vim'
    " https://vimawesome.com/plugin/vim-airline-superman
    Plug 'vim-airline/vim-airline'

    " https://vimawesome.com/plugin/vim-gitbranch
    "Plug 'itchyny/vim-gitbranch'
    " https://vimawesome.com/plugin/fugitive-vim
    Plug 'tpope/vim-fugitive'

    " https://vimawesome.com/plugin/vim-fubitive
    Plug 'tommcdo/vim-fubitive'

    " https://vimawesome.com/plugin/vim-rhubarb
    Plug 'tpope/vim-rhubarb'

    " https://vimawesome.com/plugin/nerdtree-red
    Plug 'scrooloose/nerdtree'

    " https://vimawesome.com/plugin/tcomment
    Plug 'tomtom/tcomment_vim'

    " https://vimawesome.com/plugin/vim-gutentags
    "Plug 'ludovicchabant/vim-gutentags'

    if v:version >= 800 || has('nvim')
        " https://vimawesome.com/plugin/ale
        Plug 'w0rp/ale'
    endif

    " https://vimawesome.com/plugin/phpcd-vim-the-thing-itself
    Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer.phar install' }

    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
call plug#end()

" let g:lightline = {
"     \   'active': {
"     \     'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']]
"     \   },
"     \   'component_function': {
"     \     'gitbranch': 'gitbranch#name'
"     \   },
"     \ }
set hidden
let g:airline#extensions#tabline#enabled = 1

syntax on

map <C-n> :NERDTreeToggle<CR>

" Too many mapping from default TComment plugin
let g:tcomment_maps = 0
nmap <silent> gc <Plug>TComment_gc
nmap <silent> gcc <Plug>TComment_gcc
nmap <silent> gcb <Plug>TComment_gcb
xmap gc <Plug>TComment_gc

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

" Deoplete " {{{
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']
let g:deoplete#enable_at_startup = 1

" Use TAB/S-TAB for Deoplete autocomplete
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
inoremap <silent><expr> <S-TAB>
    \ pumvisible() ? "\<C-p>" :
    \ <SID>check_back_space() ? "\<S-TAB>" :
    \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
" }}}

map <Leader><Right> :bnext<CR>
map <Leader><Left>  :bprevious<CR>

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Jump to position where last exited current buffer
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
