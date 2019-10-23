set nocompatible

" Auto install VIM-PLUG if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
    " https://vimawesome.com/plugin/fzf-vim
    " How did I live without FZF before?
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --xdg --no-update-rc' }
    Plug 'junegunn/fzf.vim'

    " https://vimawesome.com/plugin/lightline-vim
    " Airline has better buffer management, and doesn't seem slow atm
    "Plug 'itchyny/lightline.vim'
    " https://vimawesome.com/plugin/vim-airline-superman
    Plug 'vim-airline/vim-airline'

    " https://vimawesome.com/plugin/vim-gitbranch
    " gitbranch only useful on lightline
    "Plug 'itchyny/vim-gitbranch'
    " https://vimawesome.com/plugin/fugitive-vim
    " Best integration with airline
    Plug 'tpope/vim-fugitive'
    " https://vimawesome.com/plugin/vim-gitgutter
    " Git +-~ symbols within files
    Plug 'airblade/vim-gitgutter'

    " https://vimawesome.com/plugin/vim-fubitive
    " Add Bitbucket URL support to fugitive.vim's :Gbrowse command
    "Plug 'tommcdo/vim-fubitive'

    " https://vimawesome.com/plugin/vim-rhubarb
    " rhubarb.vim: GitHub extension for fugitive.vim
    "Plug 'tpope/vim-rhubarb'

    " https://vimawesome.com/plugin/nerdtree-red
    Plug 'scrooloose/nerdtree'

    " https://vimawesome.com/plugin/tcomment
    Plug 'tomtom/tcomment_vim'

    " https://vimawesome.com/plugin/vim-gutentags
    " Best CTAGS for php, but with PHPCD and PHPActor no needs for them as of yet
    "Plug 'ludovicchabant/vim-gutentags'

"    if v:version >= 800 || has('nvim')
"        " https://vimawesome.com/plugin/ale
"        Plug 'w0rp/ale'
"    endif
"
"    " https://vimawesome.com/plugin/phpcd-vim-the-thing-itself
"    Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer.phar install --no-dev --classmap-authoritative' }
"
"    " https://vimawesome.com/plugin/deoplete-nvim
"    " Auto loaded async completion
"    if has('nvim')
"        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"    elseif v:version >= 800
"        Plug 'Shougo/deoplete.nvim'
"        Plug 'roxma/nvim-yarp'
"        Plug 'roxma/vim-hug-neovim-rpc'
"    endif
"
"    " https://vimawesome.com/plugin/phpactor
"    Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer.phar install --no-dev --classmap-authoritative'}
"    " PHPActor on Deoplete seems slow af and not as reliable as PHPCD
"    " But still it's good for refactoring
"    "Plug 'kristijanhusak/deoplete-phpactor'
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

map <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1

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
"
"let g:ale_linters = {
"    \   'php': ['php'],
"    \}
"let g:ale_lint_on_save = 1
"let g:ale_lint_on_text_changed = 0
"
" Deoplete " {{{
"let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
"let g:deoplete#ignore_sources.php = ['omni']
"let g:deoplete#enable_at_startup = 1

" Use TAB/S-TAB for Deoplete autocomplete
"inoremap <silent><expr> <TAB>
"    \ pumvisible() ? "\<C-n>" :
"    \ <SID>check_back_space() ? "\<TAB>" :
"    \ deoplete#mappings#manual_complete()
"inoremap <silent><expr> <S-TAB>
"    \ pumvisible() ? "\<C-p>" :
"    \ <SID>check_back_space() ? "\<S-TAB>" :
"    \ deoplete#mappings#manual_complete()
"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"endfunction
" }}}

" PHPActor
" Include use statement
"nmap <Leader>u  :call phpactor#UseAdd()<CR>
" Invoke the context menu
"nmap <Leader>mm :call phpactor#ContextMenu()<CR>
" Invoke the navigation menu
"nmap <Leader>nn :call phpactor#Navigate()<CR>

" Browsing buffers quickly
map <Leader>w       :bdelete<CR>
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

" Appearance
set background=dark
syntax on
set number
set scrolloff=5
set laststatus=2
set showcmd
set wildmenu
set wildmode=full

" VIM behaviour
set backspace=indent,eol,start
set nobackup
set nopaste
set noundofile

" Search behaviour
set ignorecase
set smartcase
set incsearch

" Indent behaviour
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

if has("autocmd")
    filetype plugin indent on
endif
