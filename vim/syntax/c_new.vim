syntax clear


syntax keyword cKeyword            break case continue default do
syntax keyword cKeyword            else for goto if return switch while
syntax keyword cKeyword            typedef struct union static extern volatile register auto const
syntax keyword cKeyword            sizeof typeof

syntax keyword cBuiltin            int void short long unsigned char signed
syntax keyword cBuiltin            float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cBuiltin		size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   cBuiltin		clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   cBuiltin		mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword	cBuiltin		bool complex
  syn keyword	cBuiltin		int8_t int16_t int32_t int64_t
  syn keyword	cBuiltin		uint8_t uint16_t uint32_t uint64_t
  syn keyword	cBuiltin		int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword	cBuiltin		uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword	cBuiltin		int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword	cBuiltin		uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword	cBuiltin		intptr_t uintptr_t
  syn keyword	cBuiltin		intmax_t uintmax_t
endif
if exists("c_gnu")
  syn keyword	cBuiltin		__label__ __complex__ __volatile__
endif

syn match	cSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	cSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif

syntax region  cString     oneline start=+"+  skip=+\\"+  end=+"+ contains=cSpecial

syntax keyword cTodo contained TODO FIXME XXX
syntax cluster cCommentGroup contains=cTodo

syntax region  cComment            start="/\*"  end="\*/" contains=@cCommentGroup
syntax match   cComment            "//.*" contains=@cCommentGroup
syntax region  CComment            start="#if 0" end="#endif" contains=@cCommentGroup

syntax region  cIncludeLine oneline matchgroup=cInclude start="^#\s*include\>" matchgroup=cIncluded end="\S\+"

syntax match   cCharacter      "L\='[^']\{1,2}'"

syntax match   cCPPKeyword         contained "^#\s*\(define\>\|undef\>\)"
syntax match   cCPPKeyword         contained "^#\s*\(if\>\|ifdef\>\|ifndef\>\|elif\>\|endif\>\)"
syntax match   cDefined            contained "\h\w*"
syntax match   cDefinedSpecChar    contained "[()|]"
syntax match   cDefinedFunc        contained "defined(" contains=cDefinedSpecChar
syntax match   cDefine             "^#\s*\(define\>\|undef\>\)\s\+\h\w*" contains=cCPPKeyword,cDefined
syntax match   cDefine             "^#\s*\(else\>\|endif\>\)"
syntax match   cDefine             "^#\s*\(if\>\|ifdef\>\|ifndef\>\|elif\>\)\s\+.\+" contains=cCPPKeyword,cDefined,cDefinedFunc,cDefinedSpecChar

syntax match   cPreProc            "^#\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)"

syntax match cTypeDefStruct "typedef struct"  contained
syntax match  cStructName "^\s*typedef\s\+struct\s\+\h\w*\s*{"he=e-1  contains=cTypeDefStruct
syntax match  cStructName "^\s*typedef\s\+\h\w*\s*{"he=e-1  contains=cTypeDefStruct
syntax match  cStructName "^\s*struct\s\+\h\w*\s*{"he=e-1  contains=cTypeDefStruct

syntax match cFunctionPointerTypedef "^\s*typedef\s\+int\s\+\(\*\w*\)("he=e-1

"highlight define names
syntax match cDef "#define" contained
syntax match  cDefineName "^#define\s\+\h\w\+("he=e-1 contains=cDef
syntax match  cDefineName "^#define\s\+\h\w\+\s"he=e-1 contains=cDef

syntax match  cTagName "^}\s*\h\w*\s*;"hs=s+1,he=e-1

syntax region  cFuncLine oneline start="^\h" matchgroup=cFuncProto end="\h\w*\s*("he=e-1

syntax match cFuncDef "^\h\w*\s*("he=e-1

syntax match cClassKeyword "^\s*\(public\|private\)"

syntax sync ccomment cComment minlines=10


if !exists("did_c_syntax_inits")
  let did_c_syntax_inits = 1
  highlight link cComment           Comment
  highlight link cKeyword           Keyword
  highlight link cBuiltin           Keyword
  highlight link cString            String
  highlight link cPreProc           PreProc
  highlight link cDefineName        Function
  highlight link cDefine            Define
  highlight link cDefinedFunc       Define
  highlight link cCPPKeyword        Define
  highlight link cCharacter         String
  highlight link cInclude           Include
  highlight link cDefined           Defined
  highlight link cStructName        Function
  highlight link cTagName           Function
  highlight link cFuncProto         Defined
  highlight link cFuncDef           Function
  highlight link cClassKeyword      StorageClass
  highlight link cTodo		    Todo
  highlight link cSpecial           SpecialChar
endif

let b:current_syntax = "c"
