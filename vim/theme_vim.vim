hi clear
if exists("syntax_on")
    syntax reset
endif

hi Normal           ctermfg=15      ctermbg=0
hi CursorLine                       ctermbg=0       cterm=none
hi CursorLineNr     ctermfg=4                       cterm=none

hi Boolean          ctermfg=141
hi Character        ctermfg=222
hi Number           ctermfg=141
hi String           ctermfg=222
hi Conditional      ctermfg=197                     cterm=bold
hi Constant         ctermfg=141                     cterm=bold

hi DiffDelete       ctermfg=125     ctermbg=0

hi Directory        ctermfg=154                     cterm=bold
hi Error            ctermfg=222     ctermbg=0
hi Exception        ctermfg=154                     cterm=bold
hi Float            ctermfg=141
hi Function         ctermfg=154
hi Identifier       ctermfg=208

hi Keyword          ctermfg=197                     cterm=bold
hi Operator         ctermfg=197
hi PreCondit        ctermfg=154                     cterm=bold
hi PreProc          ctermfg=154
hi Repeat           ctermfg=197                     cterm=bold

hi Statement        ctermfg=197                     cterm=bold
hi Tag              ctermfg=197
hi Title            ctermfg=203
hi Visual           ctermfg=15                      ctermbg=4

hi Comment          ctermfg=15
hi LineNr           ctermfg=15      ctermbg=0
hi NonText          ctermfg=239
hi SpecialKey       ctermfg=239

hi StatusLine       ctermfg=0      ctermbg=15
hi StatusLineNC     ctermfg=0      ctermbg=15
hi VertSplit        ctermfg=0      ctermbg=4


" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
