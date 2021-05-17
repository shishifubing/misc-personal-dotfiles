hi clear

if exists("syntax_on")
    syntax reset
endif

" general colors {{{

" general text
hi Normal                   ctermfg=15     ctermbg=0
" visual selecton
hi Visual                   ctermfg=0      ctermbg=15
" the line the cursor is on
hi CursorLine                              ctermbg=0      cterm=none
" line number
hi LineNr                   ctermfg=15     ctermbg=0
" line number of the line the cursor is on
hi CursorLineNr             ctermfg=15     ctermbg=4      cterm=none

" booleans
hi Boolean                  ctermfg=141
" characters
hi Character                ctermfg=222
" numbers
hi Number                   ctermfg=141
" strings
hi String                   ctermfg=222
" ifs
hi Conditional              ctermfg=197                   cterm=bold
" constants
hi Constant                 ctermfg=141                   cterm=bold

hi DiffDelete               ctermfg=125     ctermbg=0

hi Directory                ctermfg=154                   cterm=bold
hi Error                    ctermfg=15      ctermbg=12
hi Exception                ctermfg=154                   cterm=bold
hi Float                    ctermfg=141
hi Function                 ctermfg=154
hi Identifier               ctermfg=208

hi Keyword                  ctermfg=197                   cterm=bold
hi Operator                 ctermfg=197
hi PreCondit                ctermfg=154                   cterm=bold
hi PreProc                  ctermfg=154
hi Repeat                   ctermfg=197                   cterm=bold

hi Statement                ctermfg=197                   cterm=bold
hi Tag                      ctermfg=197
hi Title                    ctermfg=203

hi Comment                  ctermfg=15     ctermbg=1
" folded lines
hi Folded                   ctermfg=7      ctermbg=0
" tilde on non-existing lines
hi NonText                  ctermfg=0      ctermbg=0
hi SpecialKey               ctermfg=239

" }}}

" windows {{{

" status line of the focused window
hi StatusLine               ctermfg=0      ctermbg=15
" status line of non-focused windows
hi StatusLineNC             ctermfg=0      ctermbg=0
" vertical window separators
hi VertSplit                ctermfg=0      ctermbg=0

" }}}

" popups {{{

" general
hi Pmenu                    ctermfg=15     ctermbg=0
" selection
hi PmenuSel                 ctermfg=15     ctermbg=12
" scrollbar
hi PmenuSbar                ctermfg=15     ctermbg=0
" thumb of scrollbar
hi PmenuThumb               ctermfg=15     ctermbg=12

" }}}

" MiniBufExplorer {{{{

" buffers that have NOT CHANGED and are NOT VISIBLE
hi MBENormal                ctermfg=15     ctermbg=0
" buffers that have CHANGED and are NOT VISIBLE
hi MBEChanged               ctermfg=15     ctermbg=0
" buffers that have NOT CHANGED and are VISIBLE
hi MBEVisibleNormal         ctermfg=15     ctermbg=0
" buffers that have CHANGED and are VISIBLE
hi MBEVisibleChanged        ctermfg=15     ctermbg=0
" active buffer that was NOT CHANGED and is VISIBLE
hi MBEVisibleActiveNormal   ctermfg=12     ctermbg=0
" active buffer that was CHANGED and is VISIBLE
hi MBEVisibleActiveChanged  ctermfg=12     ctermbg=0

" }}}}

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
