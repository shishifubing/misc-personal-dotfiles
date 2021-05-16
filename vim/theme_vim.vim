hi clear

if exists("syntax_on")
    syntax reset
endif

" let g:accent_color = #bf3eff
" let g:accent_color_2 = #9932cc
" let g:accent_color_3 = #808080
" let g:background_color = #000000
" let g:foreground_color =  #ffffff

" general colors {{{

" general text
hi Normal                        guifg=#ffffff    guibg=#000000
" visual selecton
hi Visual                        guifg=#000000    guibg=#ffffff
" the line the cursor is on
hi CursorLine                    guifg=none       guibg=#000000
" line number
hi LineNr                        guifg=#ffffff    guibg=#000000
" line number of the line the cursor is on
hi CursorLineNr                  guifg=#ffffff    guibg=#9932cc


hi Comment                       guifg=#BBBBBB    guibg=#000000
" folded lines
hi Folded                        guifg=#808080    guibg=#000000
" tilde on non-existing lines
hi NonText                       guifg=#000000    guibg=#000000
" errors
hi Error                         guifg=#ffffff    guibg=#ff0000

" }}}

" windows {{{

" status line of the focused window
hi StatusLine                    guifg=#000000    guibg=#ffffff
" status line of non-focused windows
hi StatusLineNC                  guifg=#000000    guibg=#000000
" vertical window separators
hi VertSplit                     guifg=#000000    guibg=#000000

" }}}

" popups {{{

" general
hi Pmenu                         guifg=#ffffff    guibg=#000000
" selection
hi PmenuSel                      guifg=#ffffff    guibg=#bf3eff
" scrollbar
hi PmenuSbar                     guifg=#ffffff    guibg=#000000
" thumb of scrollbar
hi PmenuThumb                    guifg=#ffffff    guibg=#bf3eff

" }}}

" MiniBufExplorer {{{

" buffers that have NOT CHANGED and are NOT VISIBLE
hi MBENormal                     guifg=#ffffff    guibg=#000000
" buffers that have CHANGED and are NOT VISIBLE
hi MBEChanged                    guifg=#ffffff    guibg=#000000
" buffers that have NOT CHANGED and are VISIBLE
hi MBEVisibleNormal              guifg=#ffffff    guibg=#000000
" buffers that have CHANGED and are VISIBLE
hi MBEVisibleChanged             guifg=#ffffff    guibg=#000000
" active buffer that was NOT CHANGED and is VISIBLE
hi MBEVisibleActiveNormal        guifg=#bf3eff    guibg=#000000
" active buffer that was CHANGED and is VISIBLE
hi MBEVisibleActiveChanged       guifg=#bf3eff    guibg=#000000

" }}}

" ale {{{

" line without errors
hi SignColor                     guifg=#000000    guibg=#000000
hi ALESignColumnWithErrors       guifg=#000000    guibg=#000000
hi ALESignColumnWithoutErrors    guifg=#000000    guibg=#000000


" items with `'type': 'E'`
hi ALEError                      guifg=none       guibg=none
hi ALEErrorSign                  guifg=#ff0000    guibg=#000000
" items with `'type': 'E'` and `'sub_type': 'style'`
hi ALEStyleError                 guifg=none       guibg=none
hi ALEStyleErrorSign             guifg=#ff0000    guibg=#000000
" items with `'type': 'W'`
hi ALEWarning                    guifg=none       guibg=none
hi ALEWarningSign                guifg=#ffff00    guibg=#000000
" items with `'type': 'W'` and `'sub_type': 'style'`
hi ALEStyleWarning               guifg=none       guibg=none
hi ALEStyleWarningSign           guifg=#ffff00    guibg=#000000
" items with `'type': 'I'`
hi ALEInfo                       guifg=none       guibg=none
hi ALEInfoSign                   guifg=#DDDDDD    guibg=#000000

" when g:ale_set_signs is set to `0`, the following highlights for entire
" lines will be set.set

"" all items with `'type': 'E'`
"hi ALEErrorLine guifg=#ffffff guibg=#ff0000
"" all items with `'type': 'W'`
"hi ALEWarningLine guifg=#ffffff guibg=#ff0000
"" all items with `'type': 'I'`
"hi ALEInfoLine guifg=#ffffff guibg=#ff0000

" }}}
