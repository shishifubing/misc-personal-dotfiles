" general stuff {{{

" path to plugins
set packpath=${HOME}/dot-files/vim
"" do not change window title while editing
"set notitle
" changes horizontal scroll to 1 column
set sidescroll=1
" enable mouse presses: switching focus, resizing, etc
set mouse=a
" enable loading the plugin files for specific file types
filetype plugin on
" working directory equals file directory 
set autochdir

" }}}

" colors {{{

" true colors in terminal
set termguicolors
" dark background
set background=dark
" do not highlight the line the cursor in on
set nocursorline
" do not show line numbers
set nonumber
" cursor shape
set guicursor=n-v-c-i:block-Cursor
" enable syntax highlighting
" condition is needed to not overide custom colors for plugins
if !exists("g:syntax_on")
    syntax enable
endif
" colorscheme
colorscheme theme_vim
let g:colors_name = 'theme_vim'
" matching parenthesis
set showmatch

" }}}

" indentation and spaces {{{

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
set foldmethod=manual

" }}}

" search {{{

" ignore case when searching
set ignorecase
" search as characters are entered
set incsearch
" highlight all matches
set hlsearch

" }}}

" status and command lines {{{

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

" backup {{{
" // means that the directory information will be saved in the filename

" a backup file — the version of the file before your edited it
set backupdir=/tmp//
" a swap file, containing the unsaved changes
set directory=/tmp//
" an undo file, containing the undo trees of the file edited
set undodir=/tmp//
" turn on undo files. it's needed to undo changes past writing into the file
set undofile

" }}}

" source stuff {{{
 
for file in split(glob('~/dot-files/vim/source/*'), '\n')
    execute 'source ' . file
endfor

" }}}

" modules {{{

" path to plugins
set packpath=${HOME}/dot-files/vim
" enable plugins in ${packpath}/pack/*/opt
packadd ale
packadd minibufexpl.vim
packadd nerdcommenter
packadd nerdtree
packadd supertab
packadd tagbar
packadd vim-autoformat
packadd vim-fugitive
packadd vim-polyglot
packadd vim-shellcheck
packadd vim-surround

" }}}
