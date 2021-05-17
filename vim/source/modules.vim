" formatting {{{
" https://github.com/chiel92/vim-autoformat


" }}}

" NERDTree {{{
" https://github.com/preservim/nerdtree

" remove press help message from the top
let NERDTreeMinimalUI = 1
" position
let NERDTreeWinPos = "left"
" width
let NERDTreeWinSize = 25
" arrow folded
let NERDTreeDirArrowExpandable = ""
" arrow unfolded
let NERDTreeDirArrowCollapsible = ""

" }}}

" buffer management {{{
" https://github.com/fholgado/minibufexpl.vim


" if value, then it is width, if 0 - split horizontally
let g:miniBufExplVSplit = 25
" Put new window on the top
let g:miniBufExplBRSplit = 0
" do not autostart
let g:miniBufExplorerAutoStart = 0
" do not wait for normal buffer
let g:miniBufExplBuffersNeeded = 0
" force splitting at edge of the screen
let g:miniBufExplSplitToEdge = 0
" cycle when you reach the end
let g:miniBufExplCycleArround = 1
" custom colors
let g:did_minibufexplorer_syntax_inits = 1


" }}}

" tagbar {{{
" https://github.com/preservim/tagbar

" Make panel vertical and place on the right
let g:tagbar_autoshowtag = 1
" Mapping to open and close the panel
let g:tagbar_position = 'botright vertical'
" do not autoclose when jumping to tags
let g:tagbar_autoclose = 0
" do not autofocus tagbar window
let g:tagbar_autofocus = 1
" width
let g:tagbar_width = 25
" don't show the help on the top or the blank lines
let g:tagbar_compact = 1
" level of indentation
let g:tagbar_indent = 0
" show tags next to group names
let g:tagbar_show_tag_count = 1

" }}}

" supertab {{{
" https://github.com/ervandew/supertab



" }}}

" ALE - linting {{{
" https://github.com/dense-analysis/ale

" when to run linters
" when you modify a buffer
let g:ale_lint_on_text_changed = 'always'
" on leaving insert mode
let g:ale_lint_on_insert_leave = 1
" when you open a new or modified buffer
let g:ale_lint_on_enter = 1
" when you save a buffer
let g:ale_lint_on_save = 1
" when the filetype changes for a buffer
let g:ale_lint_on_filetype_changed = 1

" show errors
" by updating loclist (On by default)
let g:ale_set_loclist = 1
" by updating quickfix (Off by default)
let g:ale_set_quickfix = 0
" by setting error highlights
let g:ale_set_highlights = 1
" by creating signs in the sign column
let g:ale_set_signs = 1
" by echoing messages based on your cursor
let g:ale_echo_cursor = 1
" by inline text based on your cursor
let g:ale_virtualtext_cursor = 0
" by displaying the preview based on your cursor
let g:ale_cursor_detail = 0
" use floating window
let g:ale_floating_preview = 1
" by showing balloons for your mouse cursor
let g:ale_set_balloons = 1
" always show sign column
let g:ale_sign_column_always = 1
" change colors
let g:ale_change_sign_column_color = 1
" do not highlight line numbers
let g:ale_sign_highlight_linenrs = 0
" completion
let g:ale_completion_enabled = 1

" }}}

" ctrlsg - search {{{
" https://github.com/dyng/ctrlsf.vim

" Use the ack tool as the backend
let g:ctrlsf_backend = 'ack'
" Auto close the results panel when opening a file
let g:ctrlsf_auto_close = { "normal":0, "compact":0 }
" Immediately switch focus to the search window
let g:ctrlsf_auto_focus = { "at":"start" }
" Don't open the preview window automatically
let g:ctrlsf_auto_preview = 0
" Use the smart case sensitivity search scheme
let g:ctrlsf_case_sensitive = 'smart'
" Normal mode, not compact mode
let g:ctrlsf_default_view = 'normal'
" Use absoulte search by default
let g:ctrlsf_regex_pattern = 0
" Position of the search window
let g:ctrlsf_position = 'right'
" Width or height of search window
let g:ctrlsf_winsize = '46'
" Search from the current working directory
let g:ctrlsf_default_root = 'cwd'

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

