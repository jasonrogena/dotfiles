set nu
set ts=4
set expandtab
set sw=4
set bs=2
set bg=dark
set paste
set wildmode=longest,list   " change filename autocomplete to be more like bash
set mouse=v                 " some vim defaults to mouse=a, which sucks for copying and pasting in Xorg
syntax on
if version >= 600
    filetype on             " enable file type detection
    filetype plugin on      " enable file type plugins
    filetype indent on      " enable file type indents
endif

let g:solarized_termtrans=1
colorscheme solarized
