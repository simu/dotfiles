filetype on
set t_Co=256
set nocompatible
set autoread
set cursorline
set nocp
set si
set showcmd
syn on
filetype plugin on
filetype plugin indent on

source ~/.vim/vimrc_bundle

"powerline setup
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
"airline setup
" show statusline always
set laststatus=2
" fixup for fontconfig powerline fonts
if $TERM_HAS_AIRLINE_SYMS != 0 || has("gui_running")
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"
  let g:airline_powerline_fonts = 1
endif
" configure colorscheme -- solarized light works ok with my colorscheme
let g:solarized_termcolors=256
let g:airline_theme="solarized"
" make whitespace warnings use much less space
let g:airline#extensions#whitespace#trailing_format = 't[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'm[%s]'
" configure gitgutter airline settings
let g:airline#extensions#hunks#enabled = 1
" gitgutter limits
let g:gitgutter_max_signs = 5000
" only show if we actually have changed lines (has the side-effect of hiding
" it completely for files that aren't under vc).
let g:airline#extensions#hunks#non_zero_only = 1

" maybe fix for junk symbols in text
let g:gitgutter_realtime=0

" default text width 77 (allows for 3-digit line numbers on 80 column
" terminals)
" now 78, as with smart relnumbers we wont have 3-digit line numbers anymore
set tw=78

" enable smart relativenumbers
set relativenumber
set number

"function! RelNumbers()
"  set relativenumber
"endfunc
"function! AbsNumbers()
"  set number
"endfunc

" default to user completion
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-u>"

if has("autocmd")
  filetype plugin indent on
  augroup SyntaxSwitching
    autocmd BufEnter *.javali set ft=java
    autocmd BufNewFile,BufRead *.ll set ft=lex
    autocmd BufNewFile,BufRead *.yy set ft=yacc
    autocmd BufNewFile,BufRead *.jhtml set ft=htmljinja
    autocmd BufNewFile,BufRead *.zsh-theme set ft=sh
    autocmd BufNewFile,BufRead SConstruct set ft=python
    autocmd BufNewFile,BufRead *.wsgi,*.tac set ft=python
    autocmd BufNewFile,BufRead CMakeLists set ft=cmake
    autocmd BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.glslv,*.glslf setf glsl
    autocmd BufNewFile,BufRead *.if,*.dev setf c
    autocmd BufNewFile,BufRead Hakefile setf haskell
    autocmd BufNewFile,BufRead *.tex set ft=tex
    autocmd BufNewFile,BufRead *.s set ft=gas
    autocmd BufNewFile,BufRead *.S set ft=gas
    autocmd BufNewFile,BufRead *.as set ft=gas
    autocmd BufNewFile,BufRead *.c set ft=c
    autocmd BufNewFile,BufRead *.h set ft=h
    autocmd BufNewFile,BufRead *.cpp,*.cc set ft=cpp
    autocmd BufNewFile,BufRead *.hpp,*.hh set ft=cpp
    autocmd BufNewFile,BufRead *.text set ft=mixed
    autocmd BufNewFile,BufRead *.md set ft=markdown
    autocmd BufNewFile,BufRead *.rs set ft=rust
    autocmd Filetype xml set ts=8 et sts=2 sw=2
    autocmd Filetype lisp set ts=8 et sts=2 sw=2
    autocmd Filetype python set ts=8 et sts=4 sw=4 "tw=79
    autocmd Filetype vim set ts=8 et sts=2 sw=2
    autocmd Filetype haskell set ts=8 et sts=2 sw=2
    autocmd Filetype matlab set ts=8 et sts=4 sw=4
    autocmd Filetype tex set fdm=manual fdl=99 sw=2 et sts=2 spell
    autocmd FileType htmldjango set ts=4 noet sts=4 sw=4
    autocmd FileType htmljinja set ts=4 et sts=4 sw=4
    autocmd FileType c set ts=8 et sts=4 sw=4
    autocmd FileType h set ts=8 et sts=4 sw=4
    autocmd FileType cpp set ts=8 et sts=4 sw=4
    autocmd FileType gas set ts=4 sw=4 sts=4 et
    autocmd FileType lhaskell set ts=8 sw=4 sts=4 et
    autocmd FileType haskell set ts=8 sw=4 sts=4 et
    autocmd FileType rust set ts=8 sw=4 sts=4 et
    autocmd FileType rust nmap <c-t> <Plug>KangarooPop
    autocmd FileType rust set makeprg=cargo
    "autocmd FileType rust let g:SuperTabContextDefaultCompletionType="<c-x><c-o>"
    autocmd FileType text set nolist lbr
    autocmd FileType mixed set nowrap syntax=objdasm
    autocmd FileType c let g:SuperTabContextDefaultCompletionType="<c-x><c-u>"
    "turn on highlighting for GNU C extensions
    autocmd FileType c let c_gnu=1
    autocmd FileType h let g:SuperTabContextDefaultCompletionType="<c-x><c-u>"
    autocmd FileType h let c_gnu=1
    autocmd FileType cpp let g:SuperTabContextDefaultCompletionType="<c-x><c-u>"
    autocmd FileType cpp let c_gnu=1
    autocmd FileType rst set tw=80
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  augroup END

  " should not be necessary anymore
  "augroup NumbersAug
  "  autocmd InsertEnter * :call AbsNumbers()
  "  autocmd InsertLeave * :call RelNumbers()
  "  autocmd BufNewFile  * :call RelNumbers()
  "  autocmd BufReadPost * :call RelNumbers()
  "augroup End
endif

" indentation keystrokes in visual
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

map <C-f> <C-]>

map <F20> :bn<CR>
map <F19> :bp<CR>

" devhelp
nmap <F2> :!devhelp -s <cword> >/dev/null 2>&1 &<CR><CR>
" completion generation
map <F12> :!ctags -R  -I --language-force=c --fields=+aS . >/dev/null 2>&1 &<CR><CR>
map <C-F12> :!ctags -R  -I --c++-kinds=+p --fields=+iaS --extra=+q . >/dev/null 2>&1 &<CR><CR>

" sudo write
ca w!! w !sudo tee >/dev/null "%"<CR>

" highlight blanks at end of line.
set list
set listchars=tab:\ \ ,trail:·

" set tab to insert sw chars
set smarttab

" mouse enabled
set mouse=a

" make mouse stuff work in screen
set ttymouse=xterm2

" scroll offset
set scrolloff=3

" fix annoying warning on gvim open
if has("gui_running")
  :color simu-gcs
else
  :source ~/.vim/bundle/guicolorscheme.vim/plugin/guicolorscheme.vim
  GuiColorScheme simu-gcs
endif


set hlsearch
" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent><Space> :noh<BAR>:nohlsearch<Bar>:echo<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if has("autocmd")
  let g:wordhi = 0

  aug wordhi
    au!
  aug END

  fun! MatchCWord()
    sil! exe printf('sil mat IncSearch /\<%s\>/', expand('<cword>'))
  endfun

  fun! ToggleCWordMatch()
    let g:wordhi = !g:wordhi
    if g:wordhi
      au wordhi CursorMoved * call MatchCWord()
      call MatchCWord()
      redraw
      echo "wordhi on"
    else
      au! wordhi
      match
      redraw
      "echo "wordhi off"
    endif
  endfun

  fun! FixCWordMatch()
    if g:wordhi
      au! wordhi
    else
      let g:wordhi = 1
    endif
    call MatchCWord()
    echo "wordhi fix"
  endfun

  fun! CWordOff()
    let g:wordhi = 0
    au! wordhi
    match
    redraw
  endfun


  nnoremap <silent><F7> :call ToggleCWordMatch()<CR>
  nnoremap <silent><F6> :call FixCWordMatch()<CR>
  nnoremap <silent><Space> :call CWordOff()<BAR> :noh<BAR> :nohlsearch<Bar> :echo<CR>

endif

" Search for selected text, forwards or backwards.
" from http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" clang autocomplete hotfix
let g:clang_library_path='/usr/lib/llvm-3.4/lib'
let g:clang_auto_user_options='path, .clang_complete'
let g:clang_user_options='|| exit 0'
let g:clang_complete_macros=1
" let g:clang_complete_copen=1
" let g:clang_periodic_quickfix=1
let g:clang_debug=1
noremap <leader>q :call g:ClangUpdateQuickFix()<CR>
noremap <leader>e :let g:clang_periodic_quickfix=1<CR>
noremap <leader>d :let g:clang_periodic_quickfix=0<CR>
"let g:SuperTabMappingTabLiteral='<F13>'
if 1
  " disable preview window
  set completeopt=menu,menuone,longest
else
  " If you prefer the Omni-Completion tip window to close when a selection
  " is made, these lines close it on movement in insert mode or when leaving
  " insert mode
  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif
endif

" for restructuredtext
noremap <leader>r :!rst2html %>%.html<CR><CR>

" wrap long lines
set wrap

" nice marker for wrapped lines
set showbreak=↪

" disable seek.vim falling back to substitute on <count>s
let g:seek_subst_disable = 1

" configure YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.local/share/ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_allow_changing_updatetime = 0

" configure Syntastic
" short updatetime to get responsive auto checking
set ut=200

let g:syntastic_enable_signs=1
"let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_highlighting = 1

let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['python', 'c'],
                           \ 'passive_filetypes': ['puppet'] }

let g:syntastic_c_checkers = ['ycm']

let g:netrw_liststyle = 3
