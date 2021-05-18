" noremap instead of map since it's not recursive and in general better practice

" <LEADER>. space
let mapleader = " "
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


