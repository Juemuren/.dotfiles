" Turn on syntax highlighting
syntax on

" Disable the default startup message
set shortmess+=I

" Show line numbers and relative line numbers
set number
set relativenumber

" Always show the status line at the bottom
set laststatus=2

" Make backspace behave more reasonably
set backspace=indent,eol,start

" Hide a buffer that has unsaved changes
set hidden

" Make search case-insensitive when all characters are lowercase
set ignorecase
set smartcase

" Enable searching when typing
set incsearch

" Disable audible bell
set noerrorbells visualbell t_vb=

" Enable mouse support
set mouse+=a

" Sets how many lines of history
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

" Enable system chipboard
set clipboard=unnamed
