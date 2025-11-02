" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers and relative line numbers.
set number
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" Make backspace behave more reasonably, in that you can backspace over anything.
set backspace=indent,eol,start

" Allow you hide a buffer that has unsaved changes. See `:help hidden` for more information.
set hidden

" Make search case-insensitive when all characters in the string being searched are lowercase.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support.
set mouse+=a

" Sets how many lines of history VIM has to remember
set history=1024

" Line break
set lbr

" Use 4 spaces instead of tabs during formatting
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Tab completion for files/bufferss
set wildmode=longest,list
set wildmenu

" Show matching braces when text indicator is over them
set showmatch 

" Highlight search
set hlsearch

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Enable system chipboard
set clipboard=unnamed
