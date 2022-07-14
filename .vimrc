"
" Vim-PLug core
"
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "c,html,javascript,lua,php,python"
let g:vim_bootstrap_editor = "vim"				" nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"
" Plug install packages
"
Plug 'flazz/vim-colorschemes' " colour!
Plug 'vim-scripts/CSApprox' " approximate themes with high colour gamut when in terminal
Plug 'Raimondi/delimitMate' " quality of life stuff like auto losing brackets
Plug 'scrooloose/syntastic' " ???
Plug 'Yggdroot/indentLine' " display indentation
Plug 'avelino/vim-bootstrap-updater'
Plug 'sheerun/vim-polyglot' " language pack


" session saving?
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

call plug#end()

"
" The basics (tm)
"

set nocompatible

filetype on
filetype plugin on
filetype indent on

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
set backspace=indent,eol,start " sane backspace behavior

" 4 space supremacy
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

let mapleader=','
set hidden

set hlsearch " highlight search matches
set incsearch " move as we search
set ignorecase
set smartcase

set nobackup
set noswapfile " TODO: keep?

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"
" The visuals (tm)
"

syntax on
set ruler
set number
set laststatus=2
set title
set titleold="Terminal"
set titlestring=%F " TODO: change this
set showmode

set statusline=%F%m%r%h%w%=(%{&ff}\%Y)\ (line\ %l\/%L,\ col\ %c)\

if exists("*fugitive#statusline")
    set statusline+=%{fugitive#statusline()}
endif

colorscheme codedark

if has("gui_running")
    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h12
    endif

    if has("gui_win32")
        set guifont=Pragmata Pro Mono Liga:h12
    endif
else
    let g:CSApprox_loaded = 1
    
    let g:indentLine_enabled = 1
    let g:indentLine_concealcursor = 0
    let g:indentLine_char = "┆"
    let g:indentLine_faster = 1

    if $COLORTERM == 'gnome-terminal'
        set term=gnome-256color
    else
        if $TERM == 'xterm'
            set term=xterm-256color
        endif
    endif
endif

"
" Dumb mitigation
"

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q

"
" Macros
"

command Formatify :%s/\w\+/'&',/g | $s/,$//
command SplitWinPath :%s/;/\r/g
command GlueWinPath :%s/\n/;/g
command SplitNixPath :%s/:/\r/g
command GlueNixPath :%s/\n/:/g
