set nocompatible

" Group for all autocommands of this file: cleared on re-source to avoid duplicates
augroup vimrc
    autocmd!
augroup END

" Auto install VIM-PLUG if not present (curl, or wget as fallback)
let s:plug_file = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug_file))
    let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    if executable('curl')
        silent execute '!curl -fLo ' . shellescape(s:plug_file) . ' --create-dirs ' . s:plug_url
    elseif executable('wget')
        call mkdir(fnamemodify(s:plug_file, ':h'), 'p')
        silent execute '!wget -qO ' . shellescape(s:plug_file) . ' ' . s:plug_url
    endif
endif

let dev_with_composer = executable('composer') && $USER != 'root'

" plug#end() also enables 'filetype plugin indent on' and 'syntax enable'
call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --xdg --no-update-rc' }
    Plug 'junegunn/fzf.vim'

    Plug 'vim-airline/vim-airline'

    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/gv.vim'

    Plug 'preservim/nerdtree'

    Plug 'tpope/vim-commentary'

    Plug 'will133/vim-dirdiff'

    Plug 'dense-analysis/ale'

    if dev_with_composer
        Plug 'preservim/tagbar', {'for': 'php'}

        Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev --prefer-dist --classmap-authoritative'}
        Plug 'slamdunk/vim-php-static-analysis', {'for': 'php'}

        Plug 'dantleech/vim-phpnamespace', {'for': 'php'}

        Plug 'vim-vdebug/vdebug'
        let g:vdebug_options = {'port' : 9003}
    endif
call plug#end()

" Install missing plugins on startup
autocmd vimrc VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \ | PlugInstall --sync | source $MYVIMRC
    \ | endif

let mapleader = ","

let g:ale_php_phpcbf_executable = 'vendor/bin/phpcbf'
let g:ale_php_phpcs_executable = 'vendor/bin/phpcs'
let g:ale_php_phpstan_executable = 'vendor/bin/phpstan'
let g:ale_php_psalm_executable = 'vendor/bin/psalm'
let g:ale_php_cs_fixer_executable = 'vendor/bin/php-cs-fixer'
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'php': ['php_cs_fixer', 'phpcbf'],
\}
nmap <C-k> <Plug>(ale_previous_wrap)
nmap <C-j> <Plug>(ale_next_wrap)

let php_sql_query = 1
let php_htmlInStrings = 1
let php_folding = 1

set omnifunc=syntaxcomplete#Complete
set completeopt=noinsert,menuone,noselect

if dev_with_composer
    nnoremap <F8> :TagbarToggle<CR>
    autocmd vimrc FileType php setlocal omnifunc=phpactor#Complete
    function! CleverTab()
        if pumvisible()
            return "\<C-n>"
        elseif strpart( getline('.'), col('.')-2, 1 ) =~ '^\s*$'
            return "\<Tab>"
        else
            return "\<C-X>\<C-O>"
        endif
    endfunction
    inoremap <Tab> <C-R>=CleverTab()<CR>
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " PHPActor
    " Include use statement
    "nmap <Leader>u  :call phpactor#UseAdd()<CR>
    " Invoke the context menu
    nnoremap <Leader>o :call phpactor#ContextMenu()<CR>
    " Invoke the navigation menu
    nnoremap <Leader>p :call phpactor#GotoDefinition()<CR>
endif

set foldlevel=99

set hidden
let g:airline#extensions#tabline#enabled = 1

set wildignore+=*.swp

nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1

nnoremap <Leader>m :GFiles<CR>
nnoremap <Leader>l :Files<CR>
nnoremap <Leader>h :History<CR>
nnoremap <S-Up>      :cprevious<CR>
nnoremap <S-Down>    :cnext<CR>
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <Leader>q :call ToggleQuickFix()<CR>

"Comments for PHP
autocmd vimrc FileType php setlocal commentstring=//\ %s

nnoremap <S-s>       :update<CR>
nnoremap <S-w>       :confirm bdelete<CR>
nnoremap <S-q>       :confirm quitall<CR>

nnoremap <S-Right>   :bnext<CR>
nnoremap <S-Left>    :bprevious<CR>

" indent without killing the selection in VISUAL mode
vnoremap < <gv
vnoremap > >gv

" Prevent selecting and pasting from overwriting what you originally copied.
vnoremap <Leader>p "_dP

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Jump to position where last exited current buffer (not for git commit/rebase messages)
autocmd vimrc BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit\|rebase'
    \ | exe "normal! g'\"" | endif

" Reload file when it changes on disk, can be undo
set autoread

set history=1000

" Don't wait for key codes after Esc (no lag leaving insert mode)
set ttimeout
set ttimeoutlen=50

" Appearance
set background=dark
set number
set relativenumber
set scrolloff=5
set laststatus=2
set showcmd
set wildmenu
set wildmode=longest:full,full

" VIM behaviour
set backspace=indent,eol,start
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p', 0700)
endif
set undofile
set undodir=~/.vim/undo

" Search behaviour
set ignorecase
set smartcase
set incsearch
set hlsearch
" Clear hightlight
nnoremap <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" Paste regex-escaped yanked text
cnoremap <C-o> <C-R><C-R>=substitute(escape(@", '/\.*$^~['), '\n', '\\n', 'g')<CR>

" Indent behaviour
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set listchars=tab:>>,trail:-,extends:>,precedes:<,nbsp:+
set list
