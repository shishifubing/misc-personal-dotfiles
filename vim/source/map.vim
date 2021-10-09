" noremap instead of map since it's not recursive and in general better practice

" <LEADER>. space
let mapleader = ","
" copy and to the clipboard instead of the usual vim buffer
" for windows the * register is needed
nnoremap y "+y
nnoremap d "+d
nnoremap <nowait>dd Vd
" correctly indent pasted text
nnoremap p p=`]
" paste on next line
nnoremap P :pu<CR>
" changes indentation of the selected block
" you can use . (dot) to repeat the last indent
vnoremap > >gv
vnoremap < <gv
" move between windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
" save file
noremap <C-S> :w<CR>
" close current window
nnoremap <LEADER>q :bdelete!<CR>:vertical resize 25<CR>:wincmd p<CR>
" move between buffers. <C-U> clears command line
nnoremap <LEADER>b :<C-U>execute v:count ? 'buffer!' . v:count : 'bnext!'<CR>
" open layout
nnoremap <LEADER>l :call Toggle_layout()<CR>

" modules {{{
 
" (Ctrl+F) Open search prompt (Normal Mode)
nmap <C-F>f <Plug>CtrlSFPrompt
" (Ctrl-F + f) Open search prompt with selection (Visual Mode)
xmap <C-F>f <Plug>CtrlSFVwordPath
" (Ctrl-F + F) Perform search with selection (Visual Mode)
xmap <C-F>F <Plug>CtrlSFVwordExec
" (Ctrl-F + n) Open search prompt with current word (Normal Mode)
nmap <C-F>n <Plug>CtrlSFCwordPath
" (Ctrl-F + o )Open CtrlSF window (Normal Mode)
nnoremap <C-F>o :CtrlSFOpen<CR>
" (Ctrl-F + t) Togge CtrlSF window (Normal Mode)
nnoremap <C-F>t :CtrlSFToggle<CR>
" (Ctrl-F + t) Toggle CtrlSF window (Insert Mode)
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

" }}}
