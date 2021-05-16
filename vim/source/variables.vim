" set: general stuff {{{

" path to plugins
set packpath=${HOME}/dot-files/vim
" do not change window title while editing
set notitle
" do not show line numbers
set nonumber
" do not highlight the line the cursor in on
set nocursorline
" changes horizontal scroll to 1 column
set sidescroll=1
" enable mouse presses: switching focus, resizing, etc
set mouse=a
" <LEADER>
let mapleader = " "
" enable loading the plugin files for specific file types
filetype plugin on


" }}}

" set: color {{{

" true color in terminal
set termguicolors
" dark background
set background=dark
" enable syntax highlighting
" condition is needed to not overide custom colors for plugins
if !exists("g:syntax_on")
    syntax enable
endif
" colorscheme
colorscheme theme_vim
" colorscheme
let g:colors_name = 'theme_vim'
" matching parenthesis
set showmatch

" }}}

" set: indentation and spaces {{{

" tab = n spaces
set tabstop=4
" when removing expanded tabs, remove n spaces
set softtabstop=4
" no idea
set shiftwidth=4
" pep8 standard
set textwidth=72
" allows you to indent each line the same as the previous one
set autoindent
" replaces tabs with spaces
set expandtab
" do not wrap lines
set wrap
" fold stuff
set foldmethod=syntax

" }}}

" set: search {{{

" ignore case when searching
set ignorecase
" search as characters are entered
set incsearch
" highlight all matches
set hlsearch

" }}}

" set: status and command lines {{{

" show command line
set showcmd
" always show status line on all windows
set laststatus=2

" reset status line
set statusline=
" buffer number
set statusline+=%#PmenuSel#\ \%n\ \%#Normal#
" flags: readonly, help, preview, filetype
set statusline+=\ \%R%H%W%Y
" path to the file
set statusline+=\ \[%F]
" current column + line / amount of lines
set statusline+=\ \[%l+%c/%L]
" ASCII of the symbol under the cursor
set statusline+=\ \[%b]

" }}}

" set: backup {{{
" The // means that the directory information will be saved in the filename

" a backup file — the version of the file before your edited it
set backupdir=/tmp//
" a swap file, containing the unsaved changes
set directory=/tmp//
" an undo file, containing the undo trees of the file edited
set undodir=/tmp//
" turn on undo files. It's needed to undo changes past writing into the file
set undofile

"  }}}

