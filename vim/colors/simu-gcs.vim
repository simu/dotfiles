
set background=light

hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "simu"

if version >= 700
  hi CursorLine guibg=#f6f6f6
  hi CursorColumn guibg=#eaeaea
  hi MatchParen guifg=#404850 guibg=#ffff80 gui=bold

  "Tabpages
  hi TabLine guifg=black guibg=#b0b8c0
  hi TabLineFill guifg=#9098a0
  hi TabLineSel guifg=black guibg=#f0f0f0 gui=bold

  "P-Menu (auto-completion)
  hi Pmenu guifg=#f8f8f8 guibg=#808080
  "PmenuSel
  "PmenuSbar
  "PmenuThumb
endif
"
" Html-Titles
hi Title      guifg=#502020
hi Underlined  guifg=#202020 gui=underline


hi Cursor    guifg=black   guibg=#b0b4b8
hi lCursor   guifg=black   guibg=#f8f8f8
hi LineNr    guifg=#404040 guibg=#e0e0e0

hi Normal    guifg=#252a24   guibg=#f0f0f0

hi ErrorMsg guifg=#f8f8f8 guibg=#f02020 gui=None
hi WarningMsg guifg=#f8f8f8 guibg=#f07020 gui=None

hi Search term=reverse ctermbg=226 guibg=#ffff00

hi StatusLine guifg=#f8f8f8 guibg=#8090a0 gui=none
hi StatusLineNC guifg=#506070 guibg=#a0b0c0 gui=none
hi VertSplit guifg=#a0b0c0 guibg=#a0b0c0 gui=NONE

" hi Folded    guifg=#708090 guibg=#c0d0e0
hi Folded    guifg=#a0a0a0 guibg=#e8e8e8

hi NonText   guifg=#a0a0a0 guibg=#e0e0e0
" Kommentare
" TODO:
hi Comment   guifg=#707070
hi Todo      guifg=#606060 guibg=#f0f090 gui=bold

" Konstanten
hi Constant  guifg=#af5f6b
hi String    guifg=#5f87da
hi Number    guifg=#40a070
hi Float     guifg=#70a040
"hi Statement guifg=#0070e0 gui=NONE
" Python: def and so on, html: tag-names
hi Statement  guifg=#005a0e gui=none
" hi Keyword    guifg=#007020 gui=none

" HTML: arguments
hi Type       guifg=#e5a00d gui=none
" Python: Standard exceptions, True&False
hi Structure  guifg=#007020 gui=none
hi Function   guifg=#06287e gui=none

hi Identifier guifg=#503070 gui=none

hi Repeat      guifg=#7fbf58 gui=none
hi Conditional guifg=#4c8f2f

" Cheetah: #-Symbol, function-names
hi PreProc    guifg=#1060a0 gui=NONE
" Cheetah: def, for and so on, Python: Decorators
hi Define      guifg=#1060a0
hi Error      guifg=#f00000 guibg=#f8f8f8 gui=bold,underline
hi SpecialChar guifg=#a03070

" Python: %(...)s - constructs, encoding
hi Special    guifg=#70a0d0 gui=none

hi Operator   guifg=#408010

" color of <TAB>s etc...
"hi SpecialKey guifg=#d8a080 guibg=#e8e8e8
hi SpecialKey guifg=#d0b0b0 guibg=#f0f0f0 gui=none

" Diff
hi DiffChange guifg=NONE guibg=#e0e0e0 gui=bold
hi DiffText guifg=NONE guibg=#f0c8c8 gui=bold
hi DiffAdd guifg=NONE guibg=#c0e0d0 gui=bold
hi DiffDelete guifg=NONE guibg=#f0e0b0 gui=bold

" GitGutter
hi GitGutterAdd guifg=#00aa00 guibg=#eeeeee
hi GitGutterChange guifg=#a0a000 guibg=#eeeeee
hi GitGutterDelete guifg=#aa0000 guibg=#eeeeee
hi GitGutterChangeDelete guifg=#aa00aa guibg=#eeeeee


