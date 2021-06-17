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

    Plug 'vim-airline/vim-airline'

    " Best integration with airline
    Plug 'tpope/vim-fugitive'
    " Git +-~ symbols within files
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/gv.vim'

    Plug 'preservim/nerdtree'

    Plug 'tpope/vim-commentary'

    Plug 'will133/vim-dirdiff'

    if executable('composer')
        " https://vimawesome.com/plugin/phpactor
        Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev --prefer-dist --classmap-authoritative'}
        Plug 'slamdunk/vim-php-static-analysis', {'for': 'php'}

        Plug 'dantleech/vim-phpnamespace', {'for': 'php'}
        Plug 'dense-analysis/ale'

        Plug 'vim-test/vim-test'
        Plug 'tpope/vim-dispatch'
        Plug 'slamdunk/vim-compiler-phpunit', {'for': 'php'}
    endif
call plug#end()

let test#strategy = "dispatch"

set omnifunc=syntaxcomplete#Complete
if executable('composer')
    autocmd FileType php setlocal omnifunc=phpactor#Complete
    set completeopt=noinsert,menuone,noselect
    function! CleverTab()
        if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
            return "\<Tab>"
        elseif pumvisible()
            return "\<C-n>"
        else
            return "\<C-X>\<C-O>"
        endif
    endfunction
    inoremap <Tab> <C-R>=CleverTab()<CR>
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

"Comments for PHP
autocmd FileType php setlocal commentstring=//\ %s

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
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Reload file when it changes on disk, can be undo
set autoread

set history=1000

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
