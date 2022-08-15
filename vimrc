filetype on
set exrc
set t_Co=256
set nocompatible
set autoread
set cursorline
" smartindent should be used together with autoindent
set autoindent
set smartindent
syn on
filetype plugin on
filetype plugin indent on

" wrap long lines
set wrap
" nice marker for wrapped lines
set showbreak=↪

" source plugin configuration (vim-plug)
source ~/.vim/vimrc_bundle

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
else
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_left_sep = ">"
  let g:airline_right_sep = "<"
  let g:airline_symbols.branch = "|/"
  let g:airline_symbols.linenr = "#"
  let g:airline_symbols.maxlinenr = ""
  let g:airline_symbols.whitespace = "s"
  let g:airline_symbols.readonly = "r"
endif
" configure colorscheme -- solarized light works ok with my colorscheme
let g:solarized_termcolors=256
let g:airline_theme="solarized"
" keymap needs to be explicitly disabled now. TBD: do we want this
let g:airline#extensions#keymap#enabled = 0
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

" default to user completion
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-u>"

function! SetJinjaFt()
  " expand: grab filename (:t) without last extension (:r) and then the extension (:e) of buffer name (%)
  let ftype = expand('%:t:r:e') . ".ansible"
  let &ft = l:ftype
endfunc

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
    autocmd BufNewFile,BufRead *.pp set ft=puppet
    autocmd BufNewFile,BufRead Dockerfile* set ft=dockerfile
    " assume that yaml may contain jinja snippets
    autocmd BufNewFile,BufRead *.yml set ft=yaml.ansible
    autocmd BufNewFile,BufRead *.yaml set ft=yaml.ansible
    autocmd BufNewFile,BufRead *.js set ft=javascript
    autocmd BufNewFile,BufRead *.tla set ft=tla
    autocmd BufNewFile,BufRead *.j2 set ft=jinja
    " use ansible jinja mixin for *.<ext>.j2 -> ft=<ext>.ansible
    autocmd BufNewFile,BufRead *.*.j2 call SetJinjaFt()
    " use ansible jinja mixin for *.<ext>.jinja -> ft=<ext>.ansible
    autocmd BufNewFile,BufRead *.*.jinja call SetJinjaFt()
    autocmd BufNewFile,BufRead *.*.jinja2 call SetJinjaFt()
    autocmd BufNewFile,BufRead *.json set ft=json
    autocmd BufNewFile,BufRead *.jsonnet set ft=jsonnet
    autocmd BufNewFile,BufRead *.libjsonnet set ft=jsonnet
    autocmd BufNewFile,BufRead *.libsonnet set ft=jsonnet
    " assume that we have jinja snippets in our puppet ruby code
    autocmd BufNewFile,BufRead *puppet*/*.rb set ft=ruby.ansible
    autocmd BufNewFile,BufRead *.adoc,*.asciidoc set ft=asciidoctor
    autocmd Filetype adoc.ansible set ft=asciidoctor.ansible
    autocmd Filetype asciidoc.ansible set ft=asciidoctor.ansible
    autocmd Filetype xml set ts=8 et sts=2 sw=2
    autocmd Filetype lisp set ts=8 et sts=2 sw=2
    autocmd Filetype python set ts=8 et sts=4 sw=4 tw=100
    autocmd Filetype python let g:python_highlight_all=1
"    autocmd FileType python let g:black_linelength = 100
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
    autocmd FileType tla set et sw=4
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
    autocmd FileType gitcommit set spell
    autocmd FileType javascript set ts=8 et sts=4 sw=4
    autocmd FileType yml.ansible set ft=yaml.ansible
    autocmd FileType yaml set ts=2 et sts=2 sw=2
    autocmd FileType yaml.ansible set ts=2 et sts=2 sw=2
    autocmd FileType ruby set ts=2 et sts=2 sw=2
    autocmd FileType ruby.ansible set ts=2 et sts=2 sw=2
    autocmd FileType json set ts=2 et sts=2 sw=2
    autocmd FileType jsonnet set ts=2 et sts=2 sw=2
    autocmd FileType terraform set et ts=2 sts=2 sw=2
    autocmd FileType asciidoctor set et ts=2 sts=2 sw=2 spell tw=0
    autocmd FileType typescript set et ts=2 sts=2 sw=2
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  augroup END
endif

" indentation keystrokes in visual
vmap <Tab> >
vmap <S-Tab> <LT>

" follow link with C-f
map <C-f> <C-]>

" sudo write
ca w!! w !sudo tee >/dev/null "%"<CR>

" noautocmd write
ca nw noautocmd w<CR>

" highlight blanks at end of line.
set list
set listchars=tab:\ \ ,trail:·

" set tab to be shiftwidth wide and respect expandtab
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
  if $WSL == 1 && $COLORTERM == ""
    set bg=dark
    " Windows terminal needs this?
    set t_ut=
    color xoria256
  else
    :source ~/.vim/bundle/guicolorscheme.vim/plugin/guicolorscheme.vim
    GuiColorScheme simu-gcs
  endif
endif


" enable search highlighting
set hlsearch

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
let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-10.so.1'
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
  set completeopt=menu,menuone
else
  " If you prefer the Omni-Completion tip window to close when a selection
  " is made, these lines close it on movement in insert mode or when leaving
  " insert mode
  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif
endif

" for restructuredtext
noremap <leader>r :!rst2html %>%.html<CR><CR>

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
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_python_pyflakes_exec = 'pyflakes3'

let g:netrw_liststyle = 3

" LaTeX wordcount (needs detex which should come with your LaTeX distribution)
" from http://tex.stackexchange.com/questions/534/is-there-any-way-to-do-a-correct-word-count-of-a-latex-document
command! -range=% WC <line1>,<line2>w !detex | wc -w

" easy-align config: start interactive EasyAlign with 'ga' in visual and normal mode
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" asciidoc stuff (from https://github.com/habamax/vim-asciidoctor)
" Function to create buffer local mappings and add default compiler
fun! AsciidoctorMappings()
    nnoremap <buffer> <leader>oo :AsciidoctorOpenRAW<CR>
    nnoremap <buffer> <leader>op :AsciidoctorOpenPDF<CR>
    nnoremap <buffer> <leader>oh :AsciidoctorOpenHTML<CR>
    nnoremap <buffer> <leader>ox :AsciidoctorOpenDOCX<CR>
    nnoremap <buffer> <leader>ch :Asciidoctor2HTML<CR>
    nnoremap <buffer> <leader>cp :Asciidoctor2PDF<CR>
    nnoremap <buffer> <leader>cx :Asciidoctor2DOCX<CR>
    nnoremap <buffer> <leader>p :AsciidoctorPasteImage<CR>
    " :make will build pdfs
    compiler asciidoctor2pdf
endfun

" Call AsciidoctorMappings for all `*.adoc` and `*.asciidoc` files
augroup asciidoctor
    au!
    au FileType asciidoctor call AsciidoctorMappings()
augroup END

augroup autoformat
   autocmd BufWritePre *.libjsonnet call jsonnet#Format()
   autocmd BufWritePre *.py call black#Black()
augroup END

let g:asciidoctor_fenced_languages = ['python', 'yaml', 'json']
let g:asciidoctor_img_paste_command = 'xclip -selection clipboard -t image/png -o > %s%s'
let g:asciidoctor_img_paste_pattern = 'img_%s_%s.png'
let g:asciidoctor_pdf_extensions = ['asciidoctor-diagram']

" Jsonnet formatting config
let g:jsonnet_fmt_options = '--pad-arrays'

" Black options
let g:black_quiet = 1
let g:black_skip_magic_trailing_comma = 0

" Rust.vim options
let g:rustfmt_autosave = 1

""" Javascript/Typescript config
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

augroup jstsrs
  au FileType javascript,typescript,rust inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  au FileType javascript,typescript,rust inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  au FileType javascript,typescript,rust inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  au FileType javascript,typescript,rust nmap <silent> gd <Plug>(coc-definition)
  au FileType javascript,typescript,rust nmap <silent> gy <Plug>(coc-type-definition)
  au FileType javascript,typescript,rust nmap <silent> gi <Plug>(coc-implementation)
  au FileType javascript,typescript,rust nmap <silent> gr <Plug>(coc-references)

  au FileType javascript,typescript,rust nnoremap <silent> K :call <SID>show_documentation()<CR>

  au FileType javascript,typescript,rust command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
  au FileType javascript,typescript,rust nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
augroup END

" do showcmd late, as it apparently doesn't work if it's done before airline
set showcmd
