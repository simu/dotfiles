"=============================================
"    Name: ptn.vim
"    File: ptn.vim
" Summary: for all the patterns
"  Author: Rykka G.F
"  Update: 2012-09-13
"=============================================
let s:cpo_save = &cpo
set cpo-=C


" Always use magic
if !&magic
    set magic
endif

let s:v_char = '[-+?|){}%@&]\|\%(\%(\\\@<!\\\)\@<!%\)\@<!(\|\%(\%(\\\@<!\\\)\@<!@\)\@<![<=>]'
fun! s:escape_v2m(ptn) "{{{
    " XXX: not working with many '\\'
    " substitute \v patten , return \m patten
    " add '\' to all match
    let ptn = substitute(a:ptn , s:v_char, '\\\0' ,'g')
    " remove '\\' but not '\\\' of all match
    " Oops. here we would encounter the endless check of '\\' if endless '\\'
    let ptn = substitute(ptn , '\\\@<!\\\\\('.s:v_char.'\)', '\1' ,'g')
    return ptn
endfun "}}}

fun! riv#ptn#escape(str) "{{{
    return escape(a:str, '.^$*[]\@+=~')
endfun "}}}
fun! s:normlist(list,...) "{{{
    " return list with words
    return filter(map(a:list,'matchstr(v:val,''\w\+'')'), ' v:val!=""')
endfun "}}}

fun! riv#ptn#match_object(str,ptn,...) "{{{

    let start = a:0 ? a:1 : 0
    let s = {}

    let idx = match(a:str,a:ptn,start)
    if idx == -1
        return s
    endif

    let s.start  = idx
    let s.groups = matchlist(a:str,a:ptn,start)
    let s.str    = s.groups[0]
    let s.end    = s.start + len(s.str)
    return s
endfun "}}}
fun! riv#ptn#match_obj_list(str,ptn) "{{{
    " return a list contain all match object in str.
    let obj_list =[]
    let idx = 0
    while idx != -1
        let obj = riv#ptn#match_object(a:str,a:ptn,idx)
        if empty(obj)
            break
        else
            call add(obj_list, obj)
            let idx = obj.end
        endif
    endwhile
    return obj_list
endfun "}}}

fun! riv#ptn#get_WORD_idx(line, col) "{{{
    " if cursor is in a WORD ,return it's idx , else return -1
    let ptn = printf('\%%%dc.', a:col)
    if matchstr(a:line, ptn)=~'\S'
        return match(a:line, '\S*'.ptn)
    else
        return -1
    endif
endfun "}}}
fun! riv#ptn#get_phase_idx(line, col) "{{{
    " if cursor is in a phase ,return it's idx , else return -1
    let ptn = printf('`[^`]*\%%%dc[^`]*`__\?\|\%%%dc`[^`]*`__\?', a:col, a:col)
    return match(a:line, ptn)
endfun "}}}
fun! riv#ptn#get_inline_markup_obj(line, col, bgn) "{{{
    " if cursor is in a phase ,return it's idx , else return -1
    let ptn = '\v%<'.a:col.'c%(^|\s)([`*])\S.{-}%(\S)@<=\1_{,1}' . g:_riv_p.ref_end .   '%>'.a:col.'c'
    return riv#ptn#match_object(a:line, ptn, a:bgn)
endfun "}}}

fun! riv#ptn#get_WORD_obj(line,col) "{{{
    let ptn = printf('\%%%dc.',a:col)
    if matchstr(a:line, ptn)=~'\S'
        return riv#ptn#match_object(a:line, '\S*'.ptn)
    else
        return {}
    endif
endfun "}}}

fun! riv#ptn#init() "{{{
    
    let s:p = g:_riv_p
    let s:s = g:_riv_s
    let s:t = g:_riv_t

    " Patterns:  "{{{2
    " Basic: "{{{3
    let s:p.blank = '^\s*$'
    let s:p.indent = '^\s*'
    let s:p.space_bgn = '^\_s\|^$'
    let s:p.no_space_bgn = '^\S'

    " Section: "{{{3
    " Although most puncutation can be used, only use some of them.
    " the '::' and '..' are not considered as section punct
    let s:p.section = '\v^%(([=`''"~^_*+#-])\1+|([:.])\2{2,})\s*$'


    " Table: "{{{3
    " +--------+     \s*+\%([-=]\++\)\+\s*
    " |  Grid  |     \s*|.\{-}|\s*
    " +====+===+
    " |    |   |
    " +----+   |     \s*+\%([-=]\++\)\+.\{-}|\s*        \s*|.\{-}+\%([-=]\++\)\+\s*
    " |    |   |
    " +----+---+
    "                ^\s*\%(|\s.\{-}\)\=+\%([-=]\++\)\+\%(.\{-}\s|\)\=\s*$
    let tbl_fence = '%(\|\s.{-})=\+%([-=]+\+)+%(.{-}\s\|)='
    let tbl_sepr  = '%(\|\s.{-})=\+%(-+\+)+%(.{-}\s\|)='
    let tbl_head  = '%(\|\s.{-})=\+%(\=+\+)+%(.{-}\s\|)='
    let tbl_line  = '\|\s.{-}\s\|'
    let tbl_all   = tbl_fence . '|' . tbl_line

    let tbl_wrap = '\v^\s*%s\s*$'

    let s:p.table_fence = printf(tbl_wrap, tbl_fence)
    let s:p.table_sepr = printf(tbl_wrap, tbl_sepr)
    let s:p.table_head = printf(tbl_wrap, tbl_head)
    let s:p.table_line  = printf(tbl_wrap, tbl_line)
    let s:p.table  =  printf(tbl_wrap, tbl_all)
    let s:p.table_cell = '\v\|@<=[^|]+\|@='

    let s:p.cell  = '\v\|\s\zs'
    let s:p.cell0 = '\v^\s*\|\s\zs'

    " ======  ===============
    let s:p.simple_table  = '^\s*=\+\s\+=[=[:space:]]\+\s*$'
    " '-------' &&  '-----  ----------'
    let s:p.simple_table_span = '^\s*-\+\(\s\+-\+\)*\s*$'
    


    " List: "{{{3
    let bullet = '[*+-]'
    " not '\c' as it changes whole patten
    let enum1  = '%(\d+|[#[:alpha:]]|[IMLCXVDimlcxvd]+)[.)]'
    let enum2  = '[(]%(\d+|[#[:alpha:]]|[IMLCXVDimlcxvd]+)[)]'
    let field  = ':[^:]+:'

    let b_e_list = '%('.bullet.'|'.enum1.'|'.enum2.')'
    let all_list   = '%('.bullet.'|'.enum1.'|'.enum2.'|'.field.')'
    
    let list_wrap = '\v^\s*%s\s+'

    let s:p.bullet_list = printf(list_wrap, bullet)
    let s:p.enum1_list = printf(list_wrap, enum1)
    let s:p.enum2_list = printf(list_wrap, enum2)
    let s:p.field_list = printf(list_wrap, field)
    let s:p.field_list_full= '\v^\s*:[^:]+:\s+\ze\S.+[^:]$'

    let s:p.b_e_list = printf(list_wrap, b_e_list)
    let s:p.all_list = printf(list_wrap, all_list)


    let white_wrap = '\v^(\s*)(%s)(\s+)'
    let s:p.list_white = printf(white_wrap, all_list)

    "      (indent)
    " sub1 bullet
    " sub2 #. 1. d)
    " sub3 a. z. a)
    " sub4 ii.
    " sub5 (#)
    " sub6 (a)
    " sub7 (ii)
    " sub8 (space)
    let s:p.list_checker =  '\v^\s*%('
                    \.'([*+-])'
                    \.'|(%(#|\d+)[.)])'
                    \.'|([(]%(#|\d+)[)])'
                    \.'|([[:alpha:]][.)])'
                    \.'|([(][[:alpha:]][)])'
                    \.'|([IMLCXVDimlcxvd]+[.)])'
                    \.'|([(][IMLCXVDimlcxvd]+[)])'
                    \.')(\s+)'

    "}}}3
    " Todo Items: "{{{3
    " - [x] 2012-03-04 ~ 2012-05-06 The Todo Timestamp with start and end.
    " - [x] [#A] 2012-03-04 ~ 2012-05-06 Piority
    " - TODO 2012-01-01
    " - DONE 2012-01-01 ~ 2012-01-02 
    
    " Generate keywords "{{{
    let td_key_list  = split(g:riv_todo_keywords,';')
    let g:_riv_t.td_ask_keywords = ["Choosing a keyword group:"] +
                \  map(range(len(td_key_list)), 
                \ '(v:val+1).".". td_key_list[v:val]')
    let g:_riv_t.td_keyword_groups = map(td_key_list, 
                \ 's:normlist(split(v:val,'',''))')
    
    let td_lv_ptn = '['.join(split(g:riv_todo_levels,','),'').']'
    " '[ ]', '[o]', '[X]'
    let g:_riv_t.todo_levels = map(split(g:riv_todo_levels,','),'"[".v:val."]"')
    let g:_riv_t.todo_all_group = insert(copy(g:_riv_t.td_keyword_groups), 
                \  g:_riv_t.todo_levels , 0 )

    " A todo group dic for query grp and idx
    let g:_riv_t.td_group_dic = {}
    for i in range(len(g:_riv_t.todo_all_group))
        for j in range(len(g:_riv_t.todo_all_group[i]))
            let g:_riv_t.td_group_dic[g:_riv_t.todo_all_group[i][j]] = [i,j]
        endfor
    endfor


    "}}}
    
    " it's 'AA|BB|CC|DD'
    let td_keywords = join(s:normlist(split(g:riv_todo_keywords,'[,;]')),'|')
    let td_key_done =  join(map(copy(g:_riv_t.td_keyword_groups),'v:val[-1]'),'|')
    let g:_riv_t.todo_done_key =  td_key_done

    let td_box = '\['.td_lv_ptn.'\]'
    let td_box_done = '\['.g:_riv_t.todo_levels[-1].'\]'
    let td_b_k_done = '(%('.td_box_done.'|%('.td_key_done.'))\s+)'

    let td_prior = '(\[#[[:alnum:]]\]%( |$))'
    let s:p.td_prior = '\[#\zs[[:alnum:]]\ze\]'
    let td_prior1 = '\[#'.s:t.prior_str[0].'\]%( |$)'
    let td_prior2 = '\[#'.s:t.prior_str[1].'\]%( |$)'
    let td_prior3 = '\[#'.s:t.prior_str[2].'\]%( |$)'

    let td_list = printf('(^\s*%s\s+)', all_list )
    let td_tms = '(\d{4}-\d{2}-\d{2}%( |$))'
    let td_tms_end = '(\~ \d{4}-\d{2}-\d{2}%( |$))'
    
    let s:p.td_keywords = '\v\C%('.td_keywords.')'

    let s:p.todo_box = '\v'. td_list . td_box. '\s+'
    let s:p.todo_key = '\v\C'. td_list . s:p.td_keywords.'\s+'


    let td_b_k = '(%(' . td_box. '|%('. td_keywords.'))\s+)'

    " sub1 list sub2 box and key
    let s:p.todo_b_k = '\v\C'. td_list . td_b_k
    let s:p.todo_done = '\v\C'. td_list . td_b_k_done
    
    " 1:list, 2:b_k, 3:piority, 4:tms, 5:tms_end
    let todo_all = td_list . td_b_k . td_prior . '=%(' . td_tms . td_tms_end . '=)='
    let s:p.todo_all = '\v\C' . todo_all
    let s:p.todo_check = '\v\C'. td_list .'%('. td_b_k . td_prior . '=%(' . td_tms . td_tms_end . '=)=)='

    let s:p.todo_prior1 = '\v\C'.td_list . td_b_k . td_prior1
    " sub4 timestamp bgn
    let s:p.todo_tm_bgn  = s:p.todo_b_k . td_prior .  td_tms
    " sub5 timestamp end
    let s:p.todo_tm_end  = s:p.todo_tm_bgn . td_tms_end

    " Explicit mark: "{{{3
    " Only support the exp without padding space for convenience
    let s:p.exp_mark = '^\.\.\%(\s\|$\)'

    " Block: "{{{3
    " NOTE: The literal block should not be matched with the
    " directives like '.. xxx::'
    let s:p.literal_block = '::\s*$'
    let s:p.line_block = '^\s*|\s.*[^|]\s*$'
    let s:p.doctest_block = '^>>> '
    
    " Links: "{{{3
    " 
    " URI: "{{{4
    "       http://xxx.xxx.xxx file:///xxx/xxx/xx
    "       mailto:xxx@xxx.xxx
    "       submatch with uri body.
    "standlone link patterns: www.xxx-x.xxx/?xxx
    
    let link_mail = '<[[:alnum:]_-]+%(\.[[:alnum:]_-])*\@[[:alnum:]]%([[:alnum:]-]*[[:alnum:]]\.)+[[:alnum:]]%([[:alnum:]-]*[[:alnum:]])=>'
    let link_url  = '<%(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
    let link_www  = '<www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
    let link_uri  = link_url .'|'. link_www .'|'.link_mail

    let s:p.link_mail = '\v'.link_mail
    let s:p.link_uri  = '\v'.link_uri


    " File:  "{{{4

    " 1. The local link that only works in vim. No converting.
    " It's file name with specified extensions in a word(blank,parenthe)
    " xxx.vim xxx.rst ~/xxx.vim ~/.xxx.rst xxx/xxx.vim xxx/  ~/xxx/
    "
    " 2. The file link for converting. also works in vim.
    "     
    "    1. moinmoin style
    "       [[xxx]] => xxx.rst
    "       [[xxx/]] => xxx/index.rst
    "       [[/xxx]] => DOC_ROOT/xxx.rst
    "       [[/xxx/]] => DOC_ROOT/xxx/index.rst
    "
    "    2. sphinx style
    "       :doc:`xxx.rst`   
    "       :file:`/xxx/xxx.rst`
    "
    " NOTE:  the [[/xxx.rst]] for converting are not the same with 
    "        /xxx.rst for linking which will link to xxx.rst in the
    "        root of your disk.
    "        This first one is DOC_ROOT for Compatibility with the sphinx and
    "        moinmoin style.
    
    let fname_bgn = '%(^|\s|[''"([{<,;!?])'
    let fname_end = '%($|\s|[''")\]}>:.,;!?])'
    
    let g:_riv_t.file_ext_lst = s:normlist(split(g:riv_file_link_ext,','))

    " let file_end = '%($|\s)'

    let s:p.file_ext_ptn = 'rst|'.join(g:_riv_t.file_ext_lst,'|')
    let file_name = '[[:alnum:]~./][[:alnum:]~:./\\_-]*'
    
    " The link for ext file, for in vim only.
    if g:riv_file_ext_link_hl == 1
        let ext_file_link  = '\v' . fname_bgn
                    \. '@<=' . file_name
                    \.'%(\.%('. s:p.file_ext_ptn .')|/)\ze'
                    \.fname_end 
    else
        let ext_file_link  = '^^'
    endif
    let s:p.ext_file_link  = '\v'. ext_file_link

    if g:riv_file_link_style == 1
        " moinmoin style
        " [[*]]  [[xxx/]] [[*.vim]]
        let link_file = fname_bgn.'@<=\[\[' 
                    \. file_name .'\]\]@='. fname_end 
    elseif g:riv_file_link_style == 2 
        " sphinx style
        " :doc:`file` for rst document
        " :file:`file.vim` for file link
        let link_file = fname_bgn.'@<=:%(doc|file):`' 
                    \. file_name .'`\ze'. fname_end 
    else
        let link_file = '^^'
    endif

    let s:p.link_file = '\v'. link_file

    " Reference: "{{{4
    "  xxx_
    " `xxx xx`_
    "  xxx__
    " [#]_ [*]_  [#xxx]_  [3]_    and citation [xxxx]_
    let ref_name = '[[:alnum:]]+%([_.-][[:alnum:]]+)*'
    let ref_end = '%($|\s|[''")\]}>/:.,;!?\\-])'

    let s:p.ref_name = ref_name
    let s:p.ref_end = ref_end
    
    let ref_normal = '<'.ref_name.'_\ze'
    let ref_phase  = '`[^`\\]*%(\\.[^`\\]*)*`_\ze'
    let ref_anonymous = '%(<'.ref_name.'|`[^`\\]*%(\\.[^`\\]*)*`)__\ze'
    let ref_footnote = '\[%(\d+|#|\*|#='.ref_name.')\]_\ze'

    let s:p.link_ref_normal = '\v'.ref_normal . ref_end
    let s:p.link_ref_phase  = '\v'.ref_phase . ref_end
    let s:p.link_ref_anonymous = '\v'.ref_anonymous . ref_end
    let s:p.link_ref_footnote = '\v'.ref_footnote . ref_end

    let link_reference = '%('.ref_normal.'|'.ref_phase.'|'.ref_anonymous
                \.'|'.ref_footnote.')'.ref_end

    let s:p.link_reference = '\v'.link_reference

    " Target: "{{{4
    " .. [xxx]  or  [#xxx]  or  [1] with one space
    " _`xxx xxx`
    " .. _xxx:
    " .. __:   or   __
    " `xxx  <xxx>`
    let tar_footnote = '^\.\.\s\zs\[%(\d+|#|#='.ref_name .')\]\ze\_s'
    let tar_inline = '%(\s|\_^)\zs_`[^:\\]+\ze:\_s`'
    let tar_normal = '^\.\.\s\zs_[^:\\]+\ze:\_s'
    let tar_anonymous = '^\.\.\s__:\_s\zs|^__\_s\zs'
    let tar_embed  = '^%(\s|\_^)_`.+\s<\zs.+\ze>`'

    let s:p.link_tar_footnote = '\v'.tar_footnote
    let s:p.link_tar_inline = '\v'.tar_inline
    let s:p.link_tar_normal = '\v'.tar_normal
    let s:p.link_tar_anonymous = '\v'.tar_anonymous

    let s:p.link_tar_embed  = '\v'.tar_embed

    let link_target = tar_normal
            \.'|'. tar_inline .'|'. tar_footnote .'|'. tar_anonymous
    let s:p.link_target = '\v'.link_target


    " sub match for all_link:
    " 1 link_tar
    " 2 link_ref
    " 3 link_uri
    "   4 link_uri_body
    " 5 link_file
    let s:p.link_all = '\v('. link_target 
                \ . ')|(' . link_reference
                \ . ')|(' . link_uri 
                \ . ')|(' . link_file
                \ . ')|(' . ext_file_link
                \. ')'
    "}}}4
    "
    " Miscs: 
    " indent.vim
    let s:p.indent_stoper = s:p.all_list.'|^\s*\.\.\s|^\S'
    "}}}3
    
    " Syntax Patterns: "{{{2
    " Todo Helper: "{{{3
        let riv_file = '^\S*'
    let riv_lnum = '\s+\d+ \|'
    let riv_end = '\ze%(\s|$)'

    let s:s.rivFile = riv_file
    let s:s.rivLnum = '\v'.riv_lnum

    let help_list = '\s*'.all_list.'\s+'
    let help_todo = help_list. td_b_k . td_prior . '=%('
                \. td_tms . td_tms_end . '=)='
    let help_done = help_list. td_b_k_done . td_prior . '=%('
                \. td_tms . td_tms_end . '=)='
    let s:p.help_todo_done = '\v\C'.riv_file . riv_lnum
                \ . help_list . td_b_k_done
    let s:p.help_prior1 = '\v\C'.help_list. td_b_k . td_prior1
    let s:p.help_prior2 = '\v\C'.help_list. td_b_k . td_prior2
    let s:p.help_prior3 = '\v\C'.help_list. td_b_k . td_prior3

    let s:s.rivTodo = '\v\C('. riv_file . riv_lnum .')@<='. help_todo
    let s:s.rivDone = '\v\C('. riv_file . riv_lnum .')@<='.help_done
    
    let s:s.rivTodoList = '\v'.help_list
    let s:s.rivTodoItem = '\v'.td_b_k
    let s:s.rivTodoPrior = '\v'.td_prior
    let s:s.rivTodoTmBgn = '\v'.td_tms
    let s:s.rivTodoTmEnd = '\v'.td_tms_end
    
    " Syntax After: "{{{3
    let s:s.rstFileLink = s:p.link_file
    let s:s.rstFileExtLink = s:p.ext_file_link

    let s:s.rstTodoRegion = '\v\C'.td_list .'@<='. td_b_k . td_prior . '=%(' 
                \. td_tms . td_tms_end . '=)='
    let s:s.rstDoneRegion = '\v\C'.td_list .'@<='. td_b_k_done . td_prior . '=%('
                \. td_tms . td_tms_end . '=)='
    let s:s.rstTodoItem  = s:s.rivTodoItem
    let s:s.rstTodoPrior = s:s.rivTodoPrior
    let s:s.rstTodoTmBgn = s:s.rivTodoTmBgn
    let s:s.rstTodoTmEnd = s:s.rivTodoTmEnd

    "}}}
    "}}}
endfun "}}}

fun! riv#ptn#strip(str) "{{{
    return matchstr(a:str, '^\s*\zs.\{-}\ze\s*$')
endfun "}}}


fun! riv#ptn#exp_con_idt(line) "{{{
    return matchend(a:line, g:_riv_p.exp_mark)+1
endfun "}}}

fun! riv#ptn#get(ptn,row) "{{{
    
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')
    call cursor(row,1)

    while getline(row) !~ a:ptn && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        let [row, col] = searchpos(idt_ptn, 'b',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}

fun! s:get_exp(row) "{{{
    " return the row contain current exp contex 
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')
    call cursor(row,1)

    while getline(row) !~ s:p.exp_mark && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        let [row, col] = searchpos(idt_ptn, 'b',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
    
endfun "}}}
fun! s:get_block(row) "{{{
    " return the row contain current block contex
    
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')
    call cursor(row,1)

    while getline(row) !~ s:p.literal_block && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        let [row, col] = searchpos(idt_ptn, 'b',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}

fun! riv#ptn#fix_sft(c_col,f_col,sft) "{{{
    if (a:sft > 0 && a:c_col < a:f_col && a:c_col+a:sft >= a:f_col)
        \|| (a:sft < 0 && a:c_col > a:f_col && a:c_col+a:sft <= a:f_col)
        return a:f_col
    else
        return a:c_col + a:sft
    endif
endfun "}}}
fun! riv#ptn#fix_sfts(col,f_cols,sft) "{{{
    " find the first f_col close to col
    let b_col = a:col
    if a:sft >= 0
        for f_col in sort(a:f_cols)
            if a:col < f_col
                let b_col = f_col
                break
            endif
        endfor
    else
        for f_col in reverse(sort(a:f_cols))
            if a:col > f_col
                let b_col = f_col
                break
            endif
        endfor
    endif

    return riv#ptn#fix_sft(a:col,b_col,a:sft)
endfun "}}}

" Test 
if expand('<sfile>:p') == expand('%:p') 
    " echo '-p xxx   efefe' =~ '\v^\s*%(-\w%( \w+)=|--[[:alnum:]_-]+%(\=\w+)=|/\u)%(, %(-\w%( \w+)=|--[[:alnum:]_.-]+%(\=\w+)=|/\u))*%(  |\t)\ze\s*\S'
    call riv#ptn#init()
    " echo riv#ptn#match_obj_list("hello3fefew34",'\d')
endif

let &cpo = s:cpo_save
unlet s:cpo_save
