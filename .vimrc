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

    " https://vimawesome.com/plugin/vim-airline-superman
    Plug 'vim-airline/vim-airline'

    " https://vimawesome.com/plugin/fugitive-vim
    " Best integration with airline
    Plug 'tpope/vim-fugitive'
    " https://vimawesome.com/plugin/vim-gitgutter
    " Git +-~ symbols within files
    Plug 'airblade/vim-gitgutter'

    " https://vimawesome.com/plugin/nerdtree-red
    Plug 'preservim/nerdtree'

    " https://vimawesome.com/plugin/tcomment
    Plug 'tomtom/tcomment_vim'

    " https://vimawesome.com/plugin/vim-dirdiff
    Plug 'will133/vim-dirdiff'

    if executable('composer')
        " https://vimawesome.com/plugin/phpactor
        Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev --prefer-dist --classmap-authoritative'}

        Plug 'dantleech/vim-phpnamespace'
        Plug 'dense-analysis/ale'
    endif
call plug#end()

set omnifunc=syntaxcomplete#Complete
if executable('composer')
    autocmd FileType php setlocal omnifunc=phpactor#Complete
    set completeopt=noinsert,menuone,noselect
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    let g:ale_php_phpcbf_executable = 'vendor/bin/phpcbf'
    let g:ale_php_phpcs_executable = 'vendor/bin/phpcs'
    let g:ale_php_phpstan_executable = 'vendor/bin/phpstan'
    let g:ale_php_psalm_executable = ' vendor/bin/psalm'
    let g:ale_php_cs_fixer_executable = 'vendor/bin/php-cs-fixer'
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'php': ['php_cs_fixer', 'phpcbf'],
    \}
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif

set hidden
let g:airline#extensions#tabline#enabled = 1

map <Leader>n :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1

" Too many mapping from default TComment plugin
let g:tcomment_maps = 0
nmap <silent> gc <Plug>TComment_gc
nmap <silent> gcc <Plug>TComment_gcc
nmap <silent> gcb <Plug>TComment_gcb
xmap gc <Plug>TComment_gc

" PHPActor
" Include use statement
"nmap <Leader>u  :call phpactor#UseAdd()<CR>
" Invoke the context menu
nmap <Leader>o :call phpactor#ContextMenu()<CR>
" Invoke the navigation menu
nmap <Leader>p :call phpactor#GotoDefinition()<CR>

" Browsing buffers quickly
map <Leader>w       :bdelete<CR>
map <Leader><Right> :bnext<CR>
map <Leader><Left>  :bprevious<CR>

" indent without killing the selection in VISUAL mode
vmap < <gv
vmap > >gv

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
set wildmode=longest:full

if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo')
endif
" VIM behaviour
set backspace=indent,eol,start
set nopaste
set undofile
set undodir=~/.vim/undo

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
set shiftround

if has("autocmd")
    filetype plugin indent on
endif
