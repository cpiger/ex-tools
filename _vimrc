" ======================================================================================
" File         : .vimrc
" Author       : larrupingpig@gmail.com
" Last Change  : 
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" basic
"/////////////////////////////////////////////////////////////////////////////

set nocompatible " be iMproved, required

function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if !exists('g:exvim_custom_path')
    if WINDOWS()
        let g:exvim_custom_path=$VIM
        " set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        let g:ex_tools_path = g:exvim_custom_path.'/vimfiles/tools/'
    endif
endif
" scott

" put your own user name here
let g:ex_usr_name = "yang"
" let g:mapleader=","
let g:mapleader="\<Space>"

"/////////////////////////////////////////////////////////////////////////////
" General
"/////////////////////////////////////////////////////////////////////////////

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor. 
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    silent exec 'language en_US' 
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US' 
    else
        " in linux-terminal
        silent exec 'language en_US.utf8' 
    endif
endif

" try to set encoding to utf-8
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif
scriptencoding utf-8

if has('win32') || has('win64')
        let &shell='cmd.exe'
endif

"/////////////////////////////////////////////////////////////////////////////
" Bundle steup
"/////////////////////////////////////////////////////////////////////////////

" vundle#begin
filetype off " required
if has ("unix")
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc('~/.vim/bundle/')
elseif WINDOWS()
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/  
call vundle#rc('$VIM/vimfiles/bundle/') 
endif
" man.vim: invoked by :Man {name}
" source $VIMRUNTIME/ftplugin/man.vim
" noremap <leader>k :Man  3 <C-r>=expand('<cword>')<CR><CR>
" noremap <s-f11> :Man  3 <C-r>=expand('<cword>')<CR><CR>

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Plugin 'file:///$VIM/vimfiles/bundle/Vundle.vim'                   
" ---------------------------------------------------

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/L9'                   
" ---------------------------------------------------

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-config'
" ------------------------------------------------------------------ 

" ------------------------------------------------------------------ 
Plugin 'file:///$VIM/vimfiles/bundle/ex-utility'
" ------------------------------------------------------------------ 
nnoremap <unique> <silent> <Leader>bd :EXbd<CR>:bprev<CR>
nnoremap <unique> <silent> <C-l> :EXbn<CR>
nnoremap <unique> <silent> <C-h> :EXbp<CR>
" nnoremap <unique> <silent> <C-Tab> :EXbalt<CR>
" nnoremap <unique> <silent> <Leader><Tab> :EXsw<CR>
nnoremap <unique> <silent> <Leader><Tab> :EXbalt<CR>
nmap <unique> <silent> <Leader><Esc> :EXgp<CR><ESC>


vnoremap <unique> <Leader><F10> :call ex#InsertRemoveExtend()<CR>
" Desc: Insert '#if 0' and '#endif' between the selection
vnoremap <unique> <S-F10> :call ex#InsertIFZero()<CR>
nnoremap <unique> <S-F10> :call ex#RemoveIFZero()<CR>
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-aftercolors'
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-vimentry'
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-project'
" ---------------------------------------------------
let g:ex_project_stay_after_select = 0
let g:ex_project_winpos='right'
noremap <S-F12> :EXProjectToggle<CR>
noremap <F9> :EXProjectToggle<CR>
" noremap <C-F12> :EXProjectToggle<CR>
nnoremap <unique> <leader>ve :call exconfig#edit_cur_vimentry ()<CR>
hi default link ex_pj_tree_line NonText
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-gsearch'
" ---------------------------------------------------
let g:ex_gsearch_winsize = 15
call exgsearch#register_hotkey( 100, 0, '<leader>gs', ":EXGSearchToggle<CR>", 'Toggle global search window.' )
call exgsearch#register_hotkey( 101, 0, '<leader>gg', ":EXGSearchCWordW<CR>", 'Search current word.(delimited word)' )
call exgsearch#register_hotkey( 102, 0, '<leader>gw', ":EXGSearchCWordS<CR>", 'Search current word.(substring)' )
call exgsearch#register_hotkey( 103, 0, '<leader>gr', ":EXGSearchCWordR<CR>", 'Search current word.(regexp)' )
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-tags'
" ---------------------------------------------------
let g:ex_tags_winsize = 15
call extags#register_hotkey( 100, 0, '<leader>ts', ":EXTagsToggle<CR>", 'Toggle tag select window.' )
call extags#register_hotkey( 101, 0, '<leader>]', ":EXTagsCWord<CR>", 'Tag select current word.' )
" DISABLE: nnoremap <unique> <leader>] :exec 'ts ' . expand('<cword>')<CR>
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-cscope'
" ---------------------------------------------------
let g:ex_cscope_winsize = 15
call excscope#register_hotkey( 100, 0, '<leader>cs', ":EXCSToggle<CR>", 'Toggle cscope window.' )
call excscope#register_hotkey( 101, 0, '<leader>cc', ":CSCD<CR>", 'c: Find functions calling this function.' )
call excscope#register_hotkey( 102, 0, '<leader>cd', ":CSDD<CR>", 'd: Find functions called by this function.' )
call excscope#register_hotkey( 103, 0, '<leader>se', ":CSED<CR>", 'e: Find this egrep pattern.' )
call excscope#register_hotkey( 104, 0, '<leader>ct', ":CSGD<CR>", 'g: Find this definition.' )
call excscope#register_hotkey( 105, 0, '<leader>cf', ":CSIC<CR>", 'i: Find files #including this file(bufname).' )
call excscope#register_hotkey( 106, 0, '<leader>ci', ":CSID<CR>", 'i: Find files #including this file(word).' )
call excscope#register_hotkey( 107, 0, '<leader>sd', ":CSSD<CR>", 's: Find this C symbol.' )
let g:ex_symbol_select_cmd = 'CScopeSelect'
" ------------------------------------------------------------------ 
" Desc: exCscope
" c: Find functions calling this function
" d: Find functions called by this function
" e: Find this egrep pattern
" f: Find this file         (NO NEED USE THIS FUNCTION)
" g: Find this definition
" i: Find files #including this file
" s: Find this C symbol
" t: Find this text string  (NO NEED USE THIS FUNCTION)
" ------------------------------------------------------------------ 
nnoremap <unique> <silent> <Leader>cb <C-O>

" NOTE 1c CSC  CSCD  " c: Find functions calling this function
" CSC is similar with CSCD, but you need to put an argument to specified the key word.
" CSCD will treat current word as function name, find functoins calling this function, and list the result in exCscope select window.
" nnoremap <unique> <silent> <Leader>cc :CSCD<CR>

" NOTE 2d CSD  CSDD  " d: Find functions called by this function
" CSD is similar with CSDD, but you need to put an argument to specified the key word.
" CSDD will treat current word as function name, find functoins called by this function, and list the result in exCscope select window.
" nnoremap <unique> <silent> <Leader>cd :CSDD<CR>

" NOTE 3e CSE  CSED  " e: Find this egrep pattern
" CSE  will egrep pattern in {name}.
" nnoremap <unique> <silent> <Leader>se :CSED<CR>

" NOTE 4f " f: Find this file  NO USE 

" NOTE 5g CSG  CSGD  " g: Find this definition
" CSG will find definition in {name}.
" nnoremap <unique> <silent> <Leader>ct :CSGD<CR>

" NOTE 6i CSI  CSIC  CSID  " i: Find files #including this file
" CSIC will find files #including this file, and list the result in exCscope select window.
" CSID will find files #including current file under cursor (aka `<cfile>`), and list the result in exCscope select window. Recommanded mapping:
" nnoremap <unique> <silent> <Leader>cf :CSIC<CR>
" nnoremap <unique> <silent> <Leader>ci :CSID<CR>

" NOTE 7s CSS  CSSD  " s: Find this C symbol
" CSS is similar with CSSD, but you need to put an argument to specified the key word.
" CSSD will treat current word as C symbol, find and list the result in exCscope select window.
" nnoremap <unique> <silent> <Leader>sd :CSSD<CR>

" NOTE 8t " t: Find this text string NO USE
" ---------------------------------------------------------------------------------------

" //command CSDD call s:exCS_GoDirect('da')
" //command CSCD call s:exCS_GoDirect('c')
" //command CSID call s:exCS_GoDirect('i')
" //command CSIC call s:exCS_GetSearchResult(fnamemodify( bufname("%"), ":p:t" ), 'i')
" command CSSD call s:exCS_GoDirect('s')
" command CSGD call s:exCS_GoDirect('g')
" command CSED call s:exCS_GoDirect('e')
" nnoremap <unique> <silent> <S-F2> :ExcsParseFunction<CR>
" nnoremap <unique> <silent> <leader><F2> :ExcsParseFunction<CR>

nnoremap <unique> <silent> <Leader>cq :ExcsQuickViewToggle<CR>

" set cscopetag
" if has("cscope")
"   set csprg=/usr/bin/cscope
"   set csto=0
"   set cst
"   set nocsverb
" add any database in current directory
"   if filereadable("cscope.out")
"     cs add cscope.out
"     " else add database pointed to by environment
"   elseif $CSCOPE_DB != ""
"     cs add $CSCOPE_DB
"   endif
"   set csverb
" endif
set cscopequickfix=s-,c-,d-,i-,t-,e-
nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
let g:excs_backto_editbuf = 0
let g:excs_close_when_selected = 0
let g:excs_window_direction = 'bel'
let g:excs_window_width = 48
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-symbol'
" ---------------------------------------------------
call exsymbol#register_hotkey( 100, 0, '<leader>ss', ":EXSymbolList<CR>", 'List all symbols.' )
call exsymbol#register_hotkey( 101, 0, '<leader>sq', ":EXSymbolOpen<CR>", 'Open symbols window.' )
call exsymbol#register_hotkey( 102, 0, '<leader>sg', ":EXSymbolCWord<CR>", 'List symbols contains current word.' )

if has('gui_running')
    if has ('mac')
        call exsymbol#register_hotkey( 102, 0, 'Ò', ":EXSymbolList<CR>:redraw<CR>/", 'List all symbols and stay in search mode.' )
    else
        call exsymbol#register_hotkey( 102, 0, '<M-L>', ":EXSymbolList<CR>:redraw<CR>/", 'List all symbols and stay in search mode.' )
    endif
endif
let g:ex_symbol_select_cmd = 'TS'


" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-marksbrowser'
" ------------------------------------------------------------------ 
nnoremap <unique> <leader>ms :ExmbToggle<CR>
nnoremap <unique> <a-m> :ExmbToggle<CR>

let g:ex_mb_winsize = 15
let g:exmb_backto_editbuf = 0
let g:exmb_close_when_selected = 0
let g:exmb_window_direction = 'bel'

" ------------------------------------------------------------------ 
Plugin 'file:///$VIM/vimfiles/bundle/ex-visual_studio.vim'
Plugin 'file:///$VIM/vimfiles/bundle/ex-qfix'
" ------------------------------------------------------------------ 
let g:ex_qfix_winsize=15
call exqfix#register_hotkey( 100, 0, '<leader>qf', ":EXQFixToggle<CR>", 'Toggle quickfix window.' )
" call exqfix#register_hotkey( 101, 0, '<leader>qq', ":EXQFixPaste<CR>", 'Open quickfix window and paste error list from register *.' )
nnoremap <silent> <F1> :EXQFixToggle<CR>
inoremap <silent> <F1> <ESC>:EXQFixToggle<CR>
" nnoremap <silent> <F1> :QFix<CR>

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-hierarchy'
" ---------------------------------------------------
nnoremap <unique> <leader>hv :EXHierarchyCWord<CR>

" DISABLE: use tagbar instead
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-taglist'
" Plugin 'file:///$VIM/vimfiles/bundle/ex-tagbar'
" Plugin 'file:///$VIM/vimfiles/bundle/tagbar'
" ---------------------------------------------------
" nnoremap <unique> <silent> <F2> :Tlist<CR>:call Exec_3G()<CR>
nnoremap <unique> <silent> <S-F2> :Tlist<CR>:call Exec_3G()<CR>
" nnoremap <unique> <silent> <S-F2> :TagbarToggle<CR>:call Exec_3G()<CR>
nnoremap <unique> <silent> <F2> :TagbarToggle<CR>:call Exec_3G()<CR>

if has("win32")
    " let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool 
    " let Tlist_Ctags_Cmd = 'c:\WINDOWS\system32\ctags.exe' " location of ctags tool 
    let Tlist_Ctags_Cmd = $VIM.'\bin\ctags.exe' " location of ctags tool 

endif
let Tlist_Show_Menu = 0
let Tlist_Auto_Open = 0
let Tlist_Show_One_File = 1 " Displaying tags for only one file~
let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself 
let Tlist_Use_Right_Window = 0 " split to the right side of the screen 
let Tlist_Sort_Type = "order" " sort by order or name
let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
let Tlist_BackToEditBuffer = 1 " If no close on select, let the user choose back to edit buffer or not
let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 35 
let Tlist_Compact_Format = 1 " do not show help
" let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'
" very slow, so I disable this
" let Tlist_Process_File_Always = 1 " To use the :TlistShowTag and the :TlistShowPrototype commands without the taglist window and the taglist menu, you should set this variable to 1.
":TlistShowPrototype [filename] [linenumber]

" let taglist support shader language as c-like language
let tlist_hlsl_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;v:variable;f:function'


" let g:tagbar_map_preview = '<CR>'
let g:tagbar_map_jump = '<CR>'
if has('gui_running')
    let g:tagbar_map_close = '<Esc>' 
else
    let g:tagbar_map_close = '<leader><Esc>' 
endif
" let g:tagbar_map_zoomwin = '<Space>' 
let g:tagbar_map_zoomwin = 'z' 
let g:tagbar_left = 1
let g:tagbar_width = 35
let g:tagbar_zoomwidth = 80
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
" let g:tagbar_compact = 1
" let g:tagbar_expand = 1
let g:tagbar_foldlevel = 1
" let g:tagbar_autoshowtag = 1
" let g:tagbar_updateonsave_maxlines = 10000
" let g:tagbar_systemenc = 'cp936'
if has ("unix")
    let g:tagbar_iconchars = ['?', '▼'] " (default on Linux and Mac OS X)
endif
" let g:tagbar_iconchars = ['?', '?']
" let g:tagbar_iconchars = ['?', '◢']
" let g:tagbar_iconchars = ['+', '-']  (default on Windows)
let g:tagbar_singleclick = 1

" use command ':TagbarGetTypeConfig lang' change your settings 
let g:tagbar_type_javascript = {
            \ 'ctagsbin': 'ctags',
            \ 'kinds' : [
            \ 'v:global variables:0:0',
            \ 'c:classes',
            \ 'p:properties:0:0',
            \ 'm:methods',
            \ 'f:functions',
            \ 'r:object',
            \ ],
            \ }
let g:tagbar_type_c = {
            \ 'kinds' : [
            \ 'd:macros:0:0',
            \ 'p:prototypes:0:0',
            \ 'g:enums',
            \ 'e:enumerators:0:0',
            \ 't:typedefs:0:0',
            \ 's:structs',
            \ 'u:unions',
            \ 'm:members:0:0',
            \ 'v:variables:0:0',
            \ 'f:functions',
            \ ],
            \ }
let g:tagbar_type_cpp = {
            \ 'kinds' : [
            \ 'd:macros:0:0',
            \ 'p:prototypes:0:0',
            \ 'g:enums',
            \ 'e:enumerators:0:0',
            \ 't:typedefs:0:0',
            \ 'n:namespaces',
            \ 'c:classes',
            \ 's:structs',
            \ 'u:unions',
            \ 'f:functions',
            \ 'm:members:0:0',
            \ 'v:variables:0:0',
            \ ],
            \ }
let g:tagbar_type_vimwiki = {
            \ 'ctagstype' : 'vimwiki',
            \ 'kinds'     : [
            \ 'h:header',
            \ ],
            \ 'sort'    : 0
            \ }


" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-showmarks'
" ex-showmarks: invoke by m... or <leader>mm, <leader>ma
" ------------------------------------------------------------------ 
" Desc: ShowMarks
"       <Leader>mt  - Toggles ShowMarks on and off.
"       <Leader>mo  - Turns ShowMarks on, and displays marks.
"       <Leader>mh  - Clears a mark.  or <leader>mc
"       <Leader>ma  - Clears all marks.
"       <Leader>mm  - Places the next available mark.
" ------------------------------------------------------------------ 
" TODO: bootleq/ShowMarks on github is well organized in code, but have lots 
" bugs, consider merge his code and fixes the bugs 
let g:showmarks_enable = 1
let g:showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:showmarks_ignore_type = 'hqm' " Ignore help, quickfix, non-modifiable buffers
" Hilight lower & upper marks
" Ignore help, quickfix, non-modifiable buffers
" Hilight lower & upper marks
let g:showmarks_textlower=">"
" let g:showmarks_textupper="*"
" let g:showmarks_textother="-"
let showmarks_hlline_lower = 1
" let showmarks_hlline_lower = 0
let showmarks_hlline_upper = 1 
" let showmarks_hlline_upper = 0 
" 禁用showmark的色彩
" hi default ShowMarksHLl ctermfg=white    ctermbg=blue   guifg=wheat    guibg=peru
" hi default ShowMarksHLu ctermfg=darkblue ctermbg=blue   cterm=bold     guifg=blue guibg=lightblue gui=bold
" hi default ShowMarksHLm ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72  guifg=Black
" hi default ShowMarksHLo ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF  guifg=Black 
" 禁用showmark的色彩 for molokai 用molokai 的nomal颜色,好像不设置这4个
" 颜色ShowMarksHLo ShowMarksHLm ShowMarksHLu ShowMarksHLl，就可以
" hi default ShowMarksHLo ctermfg=none ctermbg=234  guibg=#272822 
" hi default ShowMarksHLm ctermfg=none ctermbg=234  guibg=#272822
" hi default ShowMarksHLu ctermfg=none ctermbg=234  guibg=#272822
" hi default ShowMarksHLl ctermfg=none ctermbg=234  guibg=#272822

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-visincr'
" ---------------------------------------------------

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-matchit'
" ---------------------------------------------------
"  Desc:ex-matchit: invoke by %
" ---------------------------------------------------
"
Plugin 'file:///$VIM/vimfiles/bundle/ex-easyhl'
" ---------------------------------------------------
"  Desc:
" ---------------------------------------------------
hi ex_easyhl_cursorhl gui=none guibg=White term=none cterm=none ctermbg=white 
hi EX_HL_label1 gui=none guibg=Green term=none cterm=none ctermbg=lightcyan
" hi ex_easyhl1 gui=none guibg=LightCyan term=none cterm=none ctermbg=lightcyan
hi ex_easyhl2 gui=none guibg=LightMagenta term=none cterm=none ctermbg=lightmagenta
hi ex_easyhl3 gui=none guibg=LightRed term=none cterm=none ctermbg=lightred
hi ex_easyhl4 gui=none guibg=LightGreen term=none cterm=none ctermbg=lightgreen
nnoremap <unique> <silent><leader>s12 :%s/<c-r>q/<c-r>w/g<CR><c-o>
vnoremap <unique> <silent><leader>s12  :s/<c-r>q/<c-r>w/g<CR><c-o>

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-searchcompl'
" ---------------------------------------------------
"  Desc: searchcompl: invoke by /
" ---------------------------------------------------

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-colorschemes'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'altercation/vim-colors-solarized'
" ---------------------------------------------------

" ---------------------------------------------------
"Plugin 'bling/vim-airline'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-airline'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-airline-themes'
" ---------------------------------------------------
" let g:airline_exclude_filenames = ['','11','12','13','14','15'] " see source for current list
  " let g:airline#extensions#tabline#excludes = ['/tmp/']
" let g:airline_exclude_filetypes = [c] " see source for current list
let g:airline#extensions#tabline#enabled = 0
if has('gui_running')
    let g:airline_powerline_fonts = 1
    let g:Powerline_cache_enabled = 1
    let g:Powerline_symbols = 'fancy'
    " let Powerline_symbols = 'compatible' 
    " let g:Powerline_theme = 'skwp'
    " let g:Powerline_colorscheme = 'default'
else
    let g:airline_powerline_fonts = 0
endif

let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#excludes = ["[fuf]","[fuf]"]

" let g:airline_section_b = "%{fnamemodify(bufname('%'),':p:.:h').'/'}"
" let g:airline_section_c = '%t'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
if WINDOWS()
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.whitespace = 'Ξ'
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif

" powerline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''

" old vim-powerline symbols
if has('unix')
    let g:airline_left_sep = '⮀'
    let g:airline_left_alt_sep = '⮁'
    let g:airline_right_sep = '⮂'
    let g:airline_right_alt_sep = '⮃'
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
endif

" let g:airline_theme="wombat"
" let g:airline_theme="solarized"
" let g:airline_theme="molokai"
let g:airline_theme="powerlineish"
" let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing' ]
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#syntastic#enabled = 0


" let g:airline#extensions#tabline#left_sep = ''
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#right_sep = ''
" let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'


"let g:airline_section_warning = airline#section#create(['syntastic'])


" ---------------------------------------------------
" Plugin 'kien/ctrlp.vim'
" ---------------------------------------------------
"  Desc:  ctrlp: invoke by <ctrl-p>
" ---------------------------------------------------
let g:ctrlp_working_path_mode = ''
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
nnoremap <unique> <leader>bs :CtrlPBuffer<CR>

" ---------------------------------------------------
"Plugin 'tpope/vim-fugitive'
"Plugin 'file:///$VIM/vimfiles/bundle/vim-fugitive'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-gitgutter'      
let g:gitgutter_max_signs=50000
" Plugin 'file:///$VIM/vimfiles/bundle/gitv'              
" ---------------------------------------------------
"  Desc: vim-fugitive: invoke most by :Gdiff

" ---------------------------------------------------
" Plugin 'tpope/vim-surround'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-surround'
" ---------------------------------------------------
"  Desc: vim-surround: invoke when you select words and press 's'
" 'sb' for block
" 'si' for an if statement
" 'sw' for a with statement
" 'sc' for a comment
" 'sf' for a for statement
" ------------------------------------------------------------------ 
xmap s   <Plug>VSurround

" DISABLE { 
" let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1%}\r{% endblock %}"
" let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1%}\r{% endif %}"
" let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1%}\r{% endwith %}"
" let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1%}\r{% endcomment %}"
" let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1%}\r{% endfor %}"
" } DISABLE end 
" ---------------------------------------------------


" ---------------------------------------------------
" DISABLE:
" Plugin 'tpope/vim-dispatch'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'scrooloose/nerdtree'
" ---------------------------------------------------
"  Desc: nerdtree: invoke by :NERDTreeToggle
" ---------------------------------------------------
let g:NERDTreeWinSize = 30
let g:NERDTreeMouseMode = 1
let g:NERDTreeMapToggleZoom = '<Space>' 
"let NERDChristmasTree=1
let NERDTreeAutoCenter=1
" let NERDTreeBookmarksFile='~/.vim/NerdBookmarks.txt'
let NERDTreeMouseMode=2
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
"let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='right'
" let NERDTreeWinSize=35
let NERDTreeWinSize=35
" let g:NERDTreeWinSize = exists('g:exPJ_window_width') ? g:exPJ_window_width : 30 
" let NERDTreeIgnore=['\.vim$', '\~$','\.dsp$','\.aps$','\.dsw$','\.opt$','\.ncb$']
" let NERDTreeIgnore=['\.vim$', '\~$','\.dsp$','\.aps$','\.dsw$','\.opt$','\.ncb$']

" Open and close the NERD_tree.vim separately
" noremap <F12> <ESC>:NERDTreeToggle<CR>:silent! call nerdtree#chRootCwd()<CR>
noremap <C-F9> <ESC>:NERDTreeToggle<CR>
noremap <S-F9> <ESC>:NERDTreeToggle<CR>:silent! call nerdtree#ui_glue#chRootCwd()<CR>

" ---------------------------------------------------
" Plugin 'scrooloose/nerdcommenter'
" Plugin 'file:///$VIM/vimfiles/bundle/nerdcommenter'
" ---------------------------------------------------
" nerdcommenter: invoke by <leader>c<space>, <leader>cl, <leader>cu, <F11> or <C-F11>
"-----------------------------------------------------------------------------  
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1
let g:NERDCustomDelimiters = {
            \ 'vimentry': { 'left': '--' },
            \ }
" map <unique> <F11> <Plug>NERDCommenterAlignBoth
" map <unique> <C-F11> <Plug>NERDCommenterUncomment

let g:NERDSpaceDelims = 1
" let NERD_java_alt_style=1
let NERDCreateDefaultMappings=1
map <F4> <plug>NERDCommenterToggle
noremap <Leader>C <plug>NERDCommenterToggle
"noremap <Leader>cc <plug>NERDCommenterComment
noremap <Leader>cm <plug>NERDCommenterMinimal
"noremap <Leader>c<space> <plug>NERDCommenterToggle
" map <Leader>cm <plug>NERDCommenterMinimal
" noremap <Leader>cn <plug>NERDCommenterNested
map <Leader>cN <plug>NERDCommenterNested
map <Leader>c$ <plug>NERDCommenterToEOL
" noremap <Leader>ci <plug>NERDCommenterInvert
map <Leader>cI <plug>NERDCommenterInvert
" noremap <Leader>cs <plug>NERDCommenterSexy
map <Leader>cS <plug>NERDCommenterSexy
noremap <Leader>cy <plug>NERDCommenterYank
map <Leader>cA <plug>NERDCommenterAppend
map <Leader>cl <plug>NERDCommenterAlignLeft
" noremap <Leader>cb <plug>NERDCommenterAlignBoth
map <Leader>cB <plug>NERDCommenterAlignBoth
map <Leader>cu <plug>NERDCommenterUncomment
"切换 // 与  /**/
map <Leader>ca <plug>NERDCommenterAltDelims

let g:EnhCommentifyIdentString=''
let g:EnhCommentifyFirstLineMode='yes'
let g:EnhCommentifyRespectIndent='yes'
let g:EnhCommentifyUseBlockIndent='yes'
let g:EnhCommentifyAlignRight = 'yes'
let g:EnhCommentifyPretty = 'yes'
let g:EnhCommentifyBindInNormal = 'no'
let g:EnhCommentifyBindInVisual = 'no'
let g:EnhCommentifyBindInInsert = 'no'


" NOTE: VisualComment,Comment,DeComment are plugin mapping(start with <Plug>), so can't use remap here
" vmap <unique> <F11> <Plug>VisualComment
" nnoremap <unique> <F11> <Plug>Comment
" imap <unique> <F11> <ESC><Plug>Comment
" vmap <unique> <S-F11> <Plug>VisualDeComment
" nnoremap <unique> <S-F11> <Plug>DeComment
" imap <unique> <S-F11> <ESC><Plug>DeComment

" ======================================================== 
"  add new languages for comment
" ======================================================== 

function EnhCommentifyCallback(ft)
    " for hlsl, swig, c
    if a:ft =~ '^\(hlsl\|swig\|c\)$' " NOTE: we have to rewrite the c comment behavior. 
        let b:ECcommentOpen = '//'
        let b:ECcommentClose = ''
    elseif a:ft == 'snippet' " for snippet
        let b:ECcommentOpen = '#'
        let b:ECcommentClose = ''
    elseif a:ft == 'maxscript' " for maxscript
        let b:ECcommentOpen = '--'
        let b:ECcommentClose = ''
    endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

" ---------------------------------------------------
" Plugin 'scrooloose/syntastic'
" ---------------------------------------------------
" syntastic: invoke when you save file and have syntac-checker
" ------------------------------------------------------------------ 
" let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
" let g:syntastic_c_compiler='gcc'
let g:syntastic_c_compiler='clang'
" let g:syntastic_c_compiler='arm-hisiv200-linux-gcc'
" let g:syntastic_c_compiler_options = '-Wall -Wno-unused -Wno-comment -D_GNU_SOURCE  -DHAVE_STRNCASECMP -D__KERNEL_STRICT_NAMES -D__SYS_TIME_H -DCFG_MUTECTL_SUPPORT=0x39 -ffunction-sections -fdata-sections  -fsigned-char  -DTUNER_MXL203 -DFP_TM1618A -DCFG_CMWIFI_ETH2 -DHAVE_PORTING_DEBUG -DTF_USING -DCHIP_TYPE_hi3716mv101 -DBOARD_TYPE_hi3716mdmo3bvera -DSDK_MV300A1 -I/home/yang/GCIJob/HS3716_GD_SM_SMTF/include -I/home/yang/GCIJob/HS3716_GD_SM_SMTF/include/cas -I/home/yang/GCIJob/HS3716_GD_SM_SMTF/include/gci -I/home/yang/GCIJob/HS3716_GD_SM_SMTF/SDK/MV300A1/include '
let g:syntastic_java_javac_classpath="./:/mdata/mspace/SS01E17A/bin/classes:/opt/android-sdk/platforms/android-17/*.jar"
let g:syntastic_java_javac_config_file_enabled=1 
" this will make html file by Angular.js ignore errors
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

"----------------------------------------------------------------------
"let g:syntastic_check_on_open = 1
"" let g:syntastic_cpp_include_dirs = ['/usr/include/']
"let g:syntastic_cpp_include_dirs = ['E:/mspace/fltkinstall/include/']
"let g:syntastic_cpp_remove_include_errors = 1
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
""set error or warning signs
"let g:syntastic_error_symbol = ''
"let g:syntastic_warning_symbol = ''
""whether to show balloons
"let g:syntastic_enable_balloons = 1
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" Eclim adt
"----------------------------------------------------------------------
" Eclim  Acp 用 eclim打开下面  
" 使用android-javacomplete插件,要在android工程下，有AndroidManifest.xml文件等，要禁用eclim插件
" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/javacomplete'
" export CLASSPATH=/opt/android-sdk/platforms/android-17/android.jar
" Plugin 'file:///$VIM/vimfiles/bundle/vim-javacomplete2'
" nnoremap <leader>js :call javacomplete#StartServer()<cr>
" ---------------------------------------------------
" autocmd Filetype java setlocal omnifunc=javacomplete#Complete |set omnifunc=javacomplete#Complete |set completefunc=javacomplete#CompleteParamsInf 
" autocmd Filetype java setlocal omnifunc=javacomplete#Complete |setlocal omnifunc=javacomplete#Complete |setlocal completefunc=javacomplete#CompleteParamsInfo
" autocmd Filetype java set completefunc=javacomplete#CompleteParamsInfo
" autocmd Filetype java call javacomplete#StartServer()|set omnifunc=javacomplete#Complete
" autocmd FileType java set omnifunc=javacomplete#Complete
" let g:acp_behaviorJavaEclimLength = 1
" function MeetsForJavaEclim(context)
" return g:acp_behaviorJavaEclimLength >= 0 &&
" \ a:context =~ '\k\.\k\{' . g:acp_behaviorJavaEclimLength . ',}$'
" endfunction
" let g:acp_behavior = {
" \ 'java': [{
" \ 'command': "\<c-x>\<c-u>",
" \ 'completefunc' : 'eclim#java#complete#CodeComplete',
" \ 'meets' : 'MeetsForJavaEclim',
" \ }]
" \ }
" " nnoremap <leader>i :JavaImport<cr>
let g:EclimProjectTreeAutoOpen=1
noremap <C-F2> :PTreeToggle<CR>

let g:adtVimAndroidPath='/opt/android-sdk/'
let g:adtVimHtmlViewer='chromium-browser'

let g:android_sdk_path="/opt/android-sdk/"
let g:android_sdk_tags="/$HOME/AndroidTags/tags"
" ------------------------------------------------------------------ 
" Desc: pythoncomplete
" ------------------------------------------------------------------ 
" DISABLE: au FileType python set completeopt=menuone,preview
" NOTE: the preview can show the internal document in a preview window, but I don't think it have too much help
au FileType python set completeopt=menuone

"-----------------------------------------------------------------------------  
" ycm
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'rdnetto/YCM-Generator'
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'
" 默认不启动eclim
" Plugin 'file:///$VIM/vimfiles/bundle/eclim'
" Plugin 'file:///$HOME/.vim/bundle/eclim'
" eclim会影响 vim-javascript的缩进
let g:EclimJavascriptIndentDisabled = 1
let g:EclimCssIndentDisabled = 1
let g:EclimDtdIndentDisabled = 1
let g:EclimHtmlIndentDisabled = 1
let g:EclimXmlIndentDisabled = 1
" Plugin 'ternjs/tern_for_vim'
"-----------------------------------------------------------------------------  
let g:EclimCompletionMethod = 'omnifunc'
" let g:EclimLogLevel = 'trace'

" let g:ycm_server_python_interpreter = 'D:/python35/python.exe'
" ji jc jd
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>

" let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
" let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf =$VIM.'\.ycm_extra_conf.py'
" 允许 vim 加载 .ycm_extra_conf.py 文件,不再提示
let g:ycm_confirm_extra_conf=0

let g:ycm_show_diagnostics_ui = 1
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 开启 YCM 基于标签引擎
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_disable_for_files_larger_than_kb = 5000
" 引入 C++ 标准库 tags
" set tags+=/data/misc/software/misc./vim/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎,设置其快捷键
" inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现,只显示补全列表
set completeopt-=preview
let g:ycm_auto_trigger = 1
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1
" let g:ycm_key_invoke_completion = '<M-;>'  
let g:ycm_key_invoke_completion = '<M-.>'  
let g:ycm_filetype_whitelist = { '*': 1 }
" \ 'java' : 1,
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'markdown' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'pandoc' : 1
        \ }

" -----------------------------------------------------------------------
"  ultisnips
" -----------------------------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsExpandTrigger="<a-k>"
let g:UltiSnipsJumpForwardTrigger="<a-d>"
let g:UltiSnipsJumpBackwardTrigger="<a-s>"
let g:UltiSnipsListSnippets="<a-e> "

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/UltiSnips"
let g:UltiSnipsSnippetsDir= $VIM . "/vimfiles/plugged/vim-snippets/UltiSnips"
" ---------------------------------------------------
" ---------------------------------------------------
" Plugin 'msanders/snipmate.vim'
" Plugin 'file:///$VIM/vimfiles/bundle/snipMate'
" ---------------------------------------------------
let g:snips_author = g:ex_usr_name
fun! GetSnipsInCurrentScope()
    let snips = {}
    for scope in [bufnr('%')] + split(&ft, '\.') + ['_']
        call extend(snips, get(s:snippets, scope, {}), 'keep')
        call extend(snips, get(s:multi_snips, scope, {}), 'keep')
    endfor
    return snips
endf 


" ---------------------------------------------------
" Plugin 'mbbill/undotree'
" Plugin 'file:///$VIM/vimfiles/bundle/undotree'
" ---------------------------------------------------
" undotree: invoke by <Leader>u
noremap <leader>ut :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 4
function g:Undotree_CustomMap()
    if has('gui_running')
        nnoremap <silent> <script> <buffer> <ESC> :call UndotreeHide()<CR>
    else
        nnoremap <silent> <script> <buffer> <leader><ESC> :call UndotreeHide()<CR>
    endif
endfunction


" ---------------------------------------------------
"Plugin 'godlygeek/tabular'
" Plugin 'file:///$VIM/vimfiles/bundle/tabular'
" ---------------------------------------------------
" tabular: invoke by <leader>= alignment-character
nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
function! g:Tabular(ignore_range) range
    let c = getchar()
    let c = nr2char(c)
    if a:ignore_range == 0
        exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
    else
        exec printf('Tabularize /%s', c)
    endif
endfunction

" ---------------------------------------------------
"Plugin 'Lokaltog/vim-easymotion'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-easymotion'
" ---------------------------------------------------
" vim-easymotion: invoke by <leader><leader> w,b,e,ge,f,F,h,i,j,k,/ 
map <leader><leader>/ <Plug>(easymotion-sn)
omap <leader><leader>/ <Plug>(easymotion-tn)
map <leader><leader>j <Plug>(easymotion-j)
map <leader><leader>k <Plug>(easymotion-k)
map <leader><leader>l <Plug>(easymotion-lineforward)
map <leader><leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" ---------------------------------------------------


" DISABLE: I'm using GistBox https://app.gistboxapp.com/ instead
" " gist-vim: Invoke by :Gist
" ---------------------------------------------------
" Plugin 'mattn/webapi-vim'
" Plugin 'mattn/gist-vim'
" ---------------------------------------------------



" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-cref'
" ---------------------------------------------------
" ex-cref: invoke by <leader>cr
" this is modified for default c syntax highlight settings 
" make it don't highlight error pattern
let c_gnu = 1
let c_no_curly_error = 1
let c_no_bracket_error = 1


" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-typescript'
" ---------------------------------------------------
"
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/ex-easygrep'      
Plugin 'file:///$VIM/vimfiles/bundle/ex-a.vim'         
" ---------------------------------------------------

" ---------------------------------------------------
"Plugin 'mattn/emmet-vim'
" Plugin 'file:///$VIM/vimfiles/bundle/emmet-vim'
" ---------------------------------------------------
" make sure emmet only enable in html,css files
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" ---------------------------------------------------
" Plugin 'nathanaelkane/vim-indent-guides'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'maksimr/vim-jsbeautify'
" Plugin 'Chiel92/vim-autoformat'
" ---------------------------------------------------
let g:html_indent_inctags = "html,body,head,tbody" 
command JSBT :call JsBeautify()

" ---------------------------------------------------
" vim-indent-guides: invoke by <leader>ig
let g:indent_guides_guide_size = 1

" ---------------------------------------------------
" Plugin 'pangloss/vim-javascript'
" Plugin 'othree/xml.vim'

" ---------------------------------------------------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

"Plugin 'kchmck/vim-coffee-script'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-coffee-script'
" ---------------------------------------------------


" ---------------------------------------------------
" DISABLE: Slow to open big css file
" Plugin 'skammer/vim-css-color'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-css-color'
" ---------------------------------------------------


" ---------------------------------------------------
"Plugin 'groenewege/vim-less'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-less'
" ---------------------------------------------------

" ---------------------------------------------------
"Plugin 'wavded/vim-stylus'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-stylus'
" ---------------------------------------------------


" ---------------------------------------------------
" vim-markdown
" Plugin 'file:///$VIM/vimfiles/bundle/vim-markdown'
" ---------------------------------------------------
let g:vim_markdown_initial_foldlevel=9999

" TEST {{{
" " test-loading
" echomsg "test-loading: .vimrc"
" Plugin 'file:///$VIM/vimfiles/bundle/test-loading'
"}}}


" ---------------------------------------------------
"Plugin 'file:///$VIM/vimfiles/bundle/Align'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/calendar.vim'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vim-easydir'
" ---------------------------------------------------

" ------------------------------------------------------------------ 
Plugin 'file:///$VIM/vimfiles/bundle/fuzzyfinder'
" ------------------------------------------------------------------ 
" plugin - FuzzyFinder  
" mru.vim   废弃，由fuf代替
" ------------------------------------------------------------------ 
"noremap <F3> :MRU<cR>
"let MRU_Max_Entries =200 
"let MRU_Auto_Close = 0 
let g:fuf_previewHeight = 0
let g:fuf_modesDisable = []
" let g:fuf_mrucmd_maxItem = 400
let g:fuf_mrufile_maxItem = 100

" let g:fuf_splitPathMatching = 1
" let g:fuf_promptHighlight = 'Question'
" let g:fuf_fuzzyRefining = 0

let g:fuf_taggedfile_cache_dir = '~/.vim-fuf-cache/taggedfile'

" nnoremap <silent> sj     :FufBuffer<CR>
nnoremap <silent> <leader>fb :FufBuffer<CR>
nnoremap <silent> <A-b> :call ex#window#goto_edit_window()<CR>:FufBuffer<CR>
" nnoremap <silent> sk     :FufFileWithCurrentBufferDir<CR>
" nnoremap <silent> sK     :FufFileWithFullCwd<CR>
" nnoremap <silent> s<C-k> :FufFile<CR>
" " nnoremap <silent> <leader>ff   :FufFile<C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
" nnoremap <silent> <A-f> :FufFile<CR>
" nnoremap <silent> <A-f>     :FufFile!<CR>
nnoremap <silent> <A-F>     :call ex#window#goto_edit_window()<CR>:FufCoverageFile<CR>
" nnoremap <silent> sl     :FufCoverageFileChange<CR>
" nnoremap <silent> sL     :FufCoverageFileChange<CR>
" nnoremap <silent> s<C-l> :FufCoverageFileRegister<CR>
" nnoremap <silent> sd     :FufDirWithCurrentBufferDir<CR>
" nnoremap <silent> sD     :FufDirWithFullCwd<CR>
" nnoremap <silent> s<C-d> :FufDir<CR>
" nnoremap <silent> <leader>de   :FufDir<C-r>=expand('%:p:~')[:-1-len(expand('%:p:~:t'))]<CR><CR>
" nnoremap <silent> <leader>fd   :FufDir<CR>
" nnoremap <silent> sn     :FufMruFile<CR>
" nnoremap <silent> <C-m> :FufMruFile!<CR>
nnoremap <silent> <leader>mr     :call ex#window#goto_edit_window()<CR>:FufMruFile<CR>
" nnoremap <silent> sN     :FufMruFileInCwd<CR>
" nnoremap <silent> sm     :FufMruCmd<CR>
" nnoremap <silent> <leader>sc   :FufMruCmd<CR>
" nnoremap <silent> su     :FufBookmarkFile<CR>
" nnoremap <silent> s<C-u> :FufBookmarkFileAdd<CR>
" vnoremap <silent> s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
" nnoremap <silent> si     :FufBookmarkDir<CR>
" nnoremap <silent> s<C-i> :FufBookmarkDirAdd<CR>
" nnoremap <silent> st     :FufTag<CR>
" nnoremap <silent> sT     :FufTag!<CR>
" nnoremap <silent> <leader>te   :FufTag! <C-r>=expand('<cword>')<CR><CR>
" nnoremap <silent> <leader>st   :FufTag!<CR>
" nnoremap <silent> s<C-]> :FufTagWithCursorWord!<CR>
" nnoremap <silent> s,     :FufBufferTag<CR>
" nnoremap <silent> s<     :FufBufferTag!<CR>
nnoremap <silent> <A-t> :call ex#window#goto_edit_window()<CR>:FufBufferTag<CR>
" vnoremap <silent> s,     :FufBufferTagWithSelectedText!<CR>
" vnoremap <silent> s<     :FufBufferTagWithSelectedText<CR>
" nnoremap <silent> s}     :FufBufferTagWithCursorWord!<CR>
" nnoremap <silent> s.     :FufBufferTagAll<CR>
nnoremap <silent> <A-T> :call ex#window#goto_edit_window()<CR>:FufBufferTagAll<CR>
" nnoremap <silent> s>     :FufBufferTagAll!<CR>
" vnoremap <silent> s.     :FufBufferTagAllWithSelectedText!<CR>
" vnoremap <silent> s>     :FufBufferTagAllWithSelectedText<CR>
" nnoremap <silent> s]     :FufBufferTagAllWithCursorWord!<CR>
" nnoremap <silent> sg     :FufTaggedFile<CR>
" nnoremap <silent> sG     :FufTaggedFile!<CR>
function! Fuf_AT()
    let project_name = vimentry#get('project_name')
    if project_name == ''
        call ex#error("No exvim project.")
        return
    endif
    call ex#window#goto_edit_window()
    exe "FufTaggedFile"
endfunction
nnoremap <silent> <leader>ft :call Fuf_AT()<CR>
nnoremap <silent> <A-f> :call Fuf_AT()<CR>
" nnoremap <silent> so     :FufJumpList<CR>
nnoremap <silent> <leader>fj :call ex#window#goto_edit_window()<CR>:FufJumpList<CR>
" nnoremap <silent> <A-o> :call ex#window#goto_edit_window()<CR>:FufJumpList<CR>
" nnoremap <silent> sp     :FufChangeList<CR>
nnoremap <silent> <leader>fc :call ex#window#goto_edit_window()<CR>:FufChangeList<CR>
" nnoremap <silent> <A-c> :call ex#window#goto_edit_window()<CR>:FufChangeList<CR>
" nnoremap <silent> sq     :FufQuickfix<CR>
" nnoremap <silent> sy     :FufLine<CR>
" nnoremap <silent> sh     :FufHelp<CR>
" nnoremap <silent> se     :FufEditDataFile<CR>
" nnoremap <silent> sr     :FufRenewCache<CR>
" F4和shift+F4调用FuzzyFinder命令行菜单""{{{
function! GetAllCommands()
    redir => commands
    silent command
    redir END
    return map((split(commands, "\n")[3:]),
                \      '":" . matchstr(v:val, ''^....\zs\S*'')')
endfunction

" 自定义命令行
let g:fuf_com_list=[':exe "FufBuffer                       " |" <A-b>    ',
            \':exe "FufFileWithCurrentBufferDir     " |" sk     ',
            \':exe "FufFileWithFullCwd              " |" sK     ',
            \':exe "FufFile                         " |" <a-f> ',
            \':exe "FufCoverageFileChange           " |" sl     ',
            \':exe "FufCoverageFileChange           " |" sL     ',
            \':exe "FufCoverageFileRegister         " |" s<C-l> ',
            \':exe "FufDirWithCurrentBufferDir      " |" sd     ',
            \':exe "FufDirWithFullCwd               " |" sD     ',
            \':exe "FufDir                          " |" s<C-d> ',
            \':exe "FufMruFile                      " |" ,mr     ',
            \':exe "FufMruFileInCwd                 " |" sN     ',
            \':exe "FufMruCmd                       " |" ,sm     ',
            \':exe "FufBookmarkFile                 " |" su     ',
            \':exe "FufBookmarkFileAdd              " |" s<C-u> ',
            \':exe "FufBookmarkFileAddAsSelectedText" |" s<C-u> ',
            \':exe "FufBookmarkDir                  " |" si     ',
            \':exe "FufBookmarkDirAdd               " |" s<C-i> ',
            \':exe "FufTag                          " |" st     ',
            \':exe "FufTag!                         " |" sT     ',
            \':exe "FufTagWithCursorWord!           " |" s<C-]> ',
            \':exe "FufBufferTag                    " |" s,     ',
            \':exe "FufBufferTag!                   " |" s<     ',
            \':exe "FufBufferTagWithSelectedText!   " |" s,     ',
            \':exe "FufBufferTagWithSelectedText    " |" s<     ',
            \':exe "FufBufferTagWithCursorWord!     " |" s}     ',
            \':exe "FufBufferTagAll                 " |" s.     ',
            \':exe "FufBufferTagAll!                " |" s>     ',
            \':exe "FufBufferTagAllWithSelectedText!" |" s.     ',
            \':exe "FufBufferTagAllWithSelectedText " |" s>     ',
            \':exe "FufBufferTagAllWithCursorWord!  " |" s]     ',
            \':exe "FufTaggedFile                   " |" sg     ',
            \':exe "FufTaggedFile!                  " |" sG     ',
            \':exe "FufJumpList                     " |" so     ',
            \':exe "FufChangeList                   " |" sp     ',
            \':exe "FufQuickfix                     " |" sq     ',
            \':exe "FufLine                         " |" sy     ',
            \':exe "FufHelp                         " |" sh     ',
            \':exe "FufEditDataFile                 " |" se     ',
            \':exe "FufRenewCache                   " |" sr     ',
            \':exe "FufDir ~/"                        |" 更换目录从家目录jml', 
            \':exe "FufFile ~/"                       |" 打开文件从家目录jml', 
            \]


nnoremap <silent> <S-F4> :call fuf#givencmd#launch('', 0, 'Select CMD>', GetAllCommands())<CR>
nnoremap <silent> <Leader>fa :call fuf#givencmd#launch('', 0, 'Select CMD>', GetAllCommands())<CR>
nnoremap <silent> <S-F3> :call fuf#givencmd#launch('', 0, 'Select CMD>', g:fuf_com_list)<CR>
nnoremap <silent> <leader>fs :call fuf#givencmd#launch('', 0, 'Select CMD>', g:fuf_com_list)<CR>


" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/mark'
nmap <unique> <a-y> <Plug>MarkSet
xmap <unique> <a-y> <Plug>MarkSet
nmap <unique> <Leader>R <Plug>MarkRegex
xmap <unique> <Leader>R <Plug>MarkRegex
nmap <unique> <A-u> <Plug>MarkClear

nmap <unique> <Leader>M* <Plug>MarkSearchCurrentNext
nmap <unique> <Leader>M# <Plug>MarkSearchCurrentPrev
nmap <unique> <Leader>M/ <Plug>MarkSearchAnyNext
nmap <unique> <Leader>M? <Plug>MarkSearchAnyPrev
nmap <unique> * <Plug>MarkSearchNext
nmap <unique> # <Plug>MarkSearchPrev
" ---------------------------------------------------

let g:mwDefaultHighlightingPalette = 'extended'
let g:mwDefaultHighlightingPalette = 'maximum'
" let g:mwDefaultHighlightingNum = 9

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/SudoEdit'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/tlib_vim'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/unite.vim'
" ---------------------------------------------------
let g:unite_split_rule='bel'
let g:unite_winheight=15

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/unite-quickrun_config'
" ---------------------------------------------------
"

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vim-addon-mw-utils'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vim-multiple-cursors'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vimproc.vim'
" ---------------------------------------------------

" Plugin 'file:///$VIM/vimfiles/bundle/vim-rails'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-instant-markdown'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-ruby'
" Plugin 'file:///$VIM/vimfiles/bundle/vim-go'


" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vim-quickrun'
" ---------------------------------------------------
" let g:quickrun-option-split=
" nnoremap <silent> <F5> :QuickRun -mode n<CR>
nnoremap <silent> <Leader><F5> :QuickRun -mode n<CR>
vnoremap <silent> <Leader><F5> :QuickRun -mode v<CR>

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vimwiki'
" ---------------------------------------------------
" noremap <silent><unique> <Leader>wt <Plug>VimwikiTabGoHome
" noremap <silent><unique> <Leader>wq <Plug>VimwikiUISelect
" noremap <silent><unique> <Leader>ww <Plug>VimwikiGoHome
let tlist_vimwiki_settings = 'wiki;h:Headers'
" vimwiki file process
au FileType vimwiki command! W call exUtility#SaveAndConvertVimwiki(0)
au FileType vimwiki command! WA call exUtility#SaveAndConvertVimwiki(1)
au FileType rst command! W call exUtility#SphinxMake('html')

let g:vimwiki_camel_case = 0
let g:vimwiki_hl_headers = 1

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/xmledit'
" ---------------------------------------------------

" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/zencoding-vim'
" ---------------------------------------------------
" let g:user_zen_leader_key = '<c-j>'

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/VimCalc'
" using echo 4+4
" ---------------------------------------------------
" let g:VCalc_WindowPosition = 'bottom'

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vim-android'
" ---------------------------------------------------
let g:gradle_path="/opt/android-studio/gradle/gradle-2.2.1"

" ---------------------------------------------------
" Plugin 'tpope/vim-repeat'
" ---------------------------------------------------
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"
"-----------------------------------------------------------------------------  
" plugin -  vimgdb
Plugin 'file:///$VIM/vimfiles/bundle/vimgdb'
"-----------------------------------------------------------------------------  
"if has ("win32")
"elseif has ("unix")
"    " "set gdbprg=arm-uclibc-linux-gdb\ --quiet
"    set gdbprg=gdb\ --quiet
"    let g:vimgdb_debug_file = ""
"    set asm=0
"    run macros/gdb_mappings.vim
"    set gdbvar=gdbvars
"endif

noremap <silent> <S-F8> :bel 56vsplit gdbvars<CR>:setlocal nobuflisted<CR>:wincmd h<CR>
" :call exUtility#GotoEditBuffer()<CR>

" let g:ConqueGdb_Leader = '''
" let g:ConqueGdb_Leader = '\'

"-----------------------------------------------------------------------------  
" plugin - CCTree.vim  
"-----------------------------------------------------------------------------  
"let  g:CCTreeDisplayMode = 3
"let  g:CCTreeWindowVertical = 1
"let  g:CCTreeCscopeDb = "cscope.out"
"let  g:CCTreeRecursiveDepth = 3
"let  g:CCTreeMinVisibleDepth = 3
"let  g:CCTreeOrientation = "topleft"
"" (standard vim options for split: [right|left][above|below])
"let  g:CCTreeWindowMinWidth = 40
"let  g:CCTreeWindowWidth = -1
"auto-select best width to fit

"-----------------------------------------------------------------------------  
Plugin 'file:///$VIM/vimfiles/bundle/ex-DirDiff'       
" Plugin 'file:///$VIM/vimfiles/bundle/vim-dirdiff'       
"-----------------------------------------------------------------------------  
" let g:DirDiffExcludes = "roc,CVS,*.lo,*.in,*.am,*.deps,*.libs,*.class,*.exe,.*.swp,.svn,*svn*,*.a,*.so,*.o,.quick_gen_project_*,.vimfiles*,*.vimentry,app-3110e"
let g:DirDiffExcludes = "*.git,*.d,*.lst,*.obj,*.Opt,*.Uv2,*.plg,CVS,*.lo,*.cmd,*.ko,*.symvers,*.order,*.mod,*.mod.c,*.save,*.cache,*.deps,*.libs,*.class,*.exe,.*.swp,.svn,*svn*,*.a,*.so,*.o,.quick_gen_project_*,.vimfiles*,*.vimentry,app-3110e"
let g:DirDiffIgnore = "Id:,Revision:,Date:"
" let g:DirDiffAddArgs = "-b -w -B" 
" let g:DirDiffAddArgs = "-b" 
let g:DirDiffAddArgs = "-w" 
" let g:DirDiffAddArgs = "-B" 
" let g:DirDiffSort = 1
" let g:DirDiffWindowSize = 14
" let g:DirDiffIgnoreCase = 0 
let g:DirDiffEnableMappings = 1

"-----------------------------------------------------------------------------  
" Plugin 'file:///$VIM/vimfiles/bundle/DoxyGen-Syntax'        
" Plugin 'file:///$VIM/vimfiles/bundle/DoxygenToolkit.vim'    
"-----------------------------------------------------------------------------  
let g:DoxygenToolkit_briefTag_pre="@brief "
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@returns   "
" let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
" let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="yang"
let g:DoxygenToolkit_licenseTag="license"

"-----------------------------------------------------------------------------  
" plugin -  MiniBufExplorer
Plugin 'file:///$VIM/vimfiles/bundle/ex-minibuf'
"-----------------------------------------------------------------------------  
let g:miniBufExplMapCTabSwitchBufs = 1
" noremap <S-F3> :TMiniBufExplorer<CR>
" noremap <S-F7> :TMiniBufExplorer<CR>
" function MiniBuf_NextPage()
" let l:nr = bufwinnr("-MiniBufExplorer-")   
" exec l:nr.'wincmd w'
" normal $
" call search('\[[0-9]*:[^\]]*\]')
" call exUtility#GotoEditBuffer()
" endfunction
" function MiniBuf_PrevPage()
" let l:nr = bufwinnr("-MiniBufExplorer-")   
" exec l:nr.'wincmd w'
" normal 0
" call search('\[[0-9]*:[^\]]*\]','b')
" call exUtility#GotoEditBuffer()
" endfunction
" nnoremap <silent> <C-Tab> :call MiniBuf_NextPage()<CR>
" nnoremap <silent> <S-Tab> :call MiniBuf_PrevPage()<CR>

" nnoremap <buffer> <TAB>   :call search('\[[0-9]*:[^\]]*\]')<CR>:<BS>
" nnoremap <buffer> <S-TAB> :call search('\[[0-9]*:[^\]]*\]','b')<CR>:<BS>
let g:miniBufExplTabWrap = 1 " make tabs show complete (no broken on two lines) 
let g:miniBufExplModSelTarget = 1 " If you use other explorers like TagList you can (As of 6.2.8) set it at 1:
let g:miniBufExplUseSingleClick = 1 " If you would like to single click on tabs rather than double clicking on them to goto the selected buffer.  
"g:miniBufExplUseSingleClick=1则导致跟vimshell patch 被输入':if bufname("%") == "-MiniBufExplorer-" <bar> call <SID>MBEClick() <bar> endif <CR>'冲突 TODO:
" let g:miniBufExplMaxSize = 1 " <max lines: default 0> setting this to 0 will mean the window gets as big as needed to fit all your buffers. 
let g:miniBufExplMaxSize = 1
" let g:miniBufExplMaxSize = <max width: 0> 
" comment out this, when we open a single file by we, we don't need minibuf opened. Minibu always open in exDev mode, in EnvironmentUpdate 
let g:miniBufExplorerMoreThanOne = 2 " Setting this to 0 will cause the MBE window to be loaded even

"let g:miniBufExplForceSyntaxEnable = 1 " There is a VIM bug that can cause buffers to show up without their highlighting. The following setting will cause MBE to
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplMapWindowNavArrows = 1

function Exec_3G()
    let aline = line(".")
    if aline <= 2
     exec   "normal 3G" 
    endif 
endfunction
" autocmd WinEnter -MiniBufExplorer-  silent wincmd j
" autocmd WinEnter -MiniBufExplorer-  call ex#window#goto_edit_window()
autocmd BufReadPost,BufAdd,BufCreate,BufWinEnter,WinEnter __Tag_List__  call Exec_3G()
autocmd CursorMoved __Tag_List__  call Exec_3G()

"-----------------------------------------------------------------------------  
" plugin -  sketck.vim
"-----------------------------------------------------------------------------  
noremap <C-F7> :call ToggleSketch()<CR>
" noremap <C-F8> :DIstart<CR>
" noremap <C-F8> :DIstop<CR>

"-----------------------------------------------------------------------------  
" Plugin 'file:///$VIM/vimfiles/bundle/vimshell.vim'
" Plugin 'Shougo/vimshell.vim'
"-----------------------------------------------------------------------------  
" noremap <silent> <F6> :VimShell -toggle -split -buffer-name=*vimshell*<CR>
" autocmd BufEnter vimshell* :AcpLock
" autocmd Bufleave vimshell* :AcpUnlock

" noremap <silent> <F6> :split \|wincmd j \|e -vimshell- \|vimshell bash<CR>
" noremap <silent> <S-F6> :vsplit \|wincmd l \|e -vimshell- \|vimshell bash<CR>

" let g:ConqueTerm_FastMode = 0
" let g:ConqueTerm_Color = 1
" let g:ConqueTerm_StartMessages = 0
" let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
" let g:ConqueTerm_Syntax = 'conque_term'
" noremap <silent> <F6> :split \|wincmd j \|b bash\ -\ 1<CR>
" noremap <silent> <S-F6> :vsplit \|wincmd l \|b bash\ -\ 1<CR>


"-----------------------------------------------------------------------------  
" plugin - VimFiler
"-----------------------------------------------------------------------------  
let g:vimfiler_as_default_explorer = 1
" let g:vimfiler_split_rule='bel'

" ------------------------------------------------------------------ 
" Desc: exMacroHighlight
" ------------------------------------------------------------------ 

nnoremap <unique> <silent> <Leader>aa :ExmhSelectToggle<CR>
nnoremap <unique> <silent> <Leader>ae :ExmhHL 1 <CR>
nnoremap <unique> <silent> <Leader>ad :ExmhHL 0 <CR>


" newexvim autocmd VimEnter * silent call exUtility#CloseWindow("project_tree.exproject")
" autocmd GUIEnter * 

" let g:SrcExpl_gobackKey = '<SPACE>'
" let g:SrcExpl_jumpKey = '<CR>'
let g:SrcExpl_winHeight = 12
let g:SrcExpl_updateTags = 0
let g:SrcExpl_updateTagsCmd ="Update"
nnoremap <unique> <leader>si :SrcExplToggle<CR>
nnoremap <unique> <A-F3> :SrcExplToggle<CR>
let g:SrcExpl_isUpdateTags = 0 

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/ack.vim'                       
" Plugin 'file:///$VIM/vimfiles/bundle/ag'
" ---------------------------------------------------
" noremap <F3> :LAck <C-r>=expand('<cword>')<CR><CR> 
" vmap <F3> <C-C>:LAck <C-R>='"'.substitute(escape(@*,'\/'),'\n','\\n','g').'"'<CR><CR>
" let g:ackprg = 'ag --nogroup --nocolor --column'
" or:
" let g:ackprg = 'ag --vimgrep'
" let g:ag_lhandler="lopen"
let g:ag_lhandler="lopen"
" let g:ag_lhandler="belowright lopen"
noremap <leader>ag :LAg  <C-r>=expand('<cword>')<CR><CR>
" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vimcaps'               
" ---------------------------------------------------

" ---------------------------------------------------
"Plugin 'file:///$VIM/vimfiles/bundle/vim-neco-calc'         
" Plugin 'file:///$VIM/vimfiles/bundle/neco-ghc'             
"Plugin 'file:///$VIM/vimfiles/bundle/neco-look'            
" Plugin 'file:///$VIM/vimfiles/bundle/context_filetype.vim'
" ---------------------------------------------------
"
" ---------------------------------------------------
"Plugin 'file:///$VIM/vimfiles/bundle/vim-logcat'            
" ---------------------------------------------------
"
" ---------------------------------------------------
"Plugin 'file:///$VIM/vimfiles/bundle/pythoncomplete.vim'     
" Plugin 'davidhalter/jedi-vim'
" ---------------------------------------------------
"
" ---------------------------------------------------
"Plugin 'file:///$VIM/vimfiles/bundle/vim-escalt'         
" Plugin 'file:///$VIM/vimfiles/bundle/vim-expand-region'                     
 " Plugin 'file:///$VIM/vimfiles/bundle/vim-bookmarks'         
let g:bookmark_no_default_key_mappings=1
  " call unite#custom#profile('source/vim_bookmarks', 'context', {
    " \   'winheight': 13,
    " \   'direction': 'botright',
    " \   'start_insert': 0,
    " \   'keep_focus': 1,
    " \   'no_quit': 1,
    " \ })
"Plugin 'file:///$VIM/vimfiles/bundle/fencview'          
"Plugin 'file:///$VIM/vimfiles/bundle/vim-genutils'
" Plugin 'file:///$VIM/vimfiles/bundle/cpp-vim'
"Plugin 'file:///$VIM/vimfiles/bundle/TeTrIs.vim'             
"Plugin 'file:///$VIM/vimfiles/bundle/vim-chardet'
"Plugin 'file:///$VIM/vimfiles/bundle/hexHighlight.vim'  
"Plugin 'file:///$VIM/vimfiles/bundle/vim-swigjs'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/vimcdoc'               
" Plugin 'file:///$VIm/vimfiles/bundle/vim-man'
" Plugin 'file:///$HOME/.vim/bundle/vim-man'
" ---------------------------------------------------
map K <Nop>
map <leader>k <Plug>(Man)

" ---------------------------------------------------
" Plugin 'file:///$VIM/vimfiles/bundle/phpcomplete.vim'
" ---------------------------------------------------

" ---------------------------------------------------
"Plugin 'git://github.com/rkulla/pydiction'
" ---------------------------------------------------

" ---------------------------------------------------
" Plugin 'junegunn/vim-easy-align'
" ---------------------------------------------------
" ---------------------------------------------------
Plugin 'file:///$VIM/vimfiles/bundle/zzplugins'
Plugin 'file:///$VIM/vimfiles/bundle/my-colors'            
Plugin 'file:///$VIM/vimfiles/bundle/my-syntax'            
" Desc: my old plugins collection to this dir
" python.vim             
" weather.vim
" colorizer.vim         
" filetype.vim
  
" vundle#end
filetype plugin indent on " required
syntax on " required

call plug#begin('$VIM/vimfiles/plugged')
Plug 'majutsushi/tagbar'
" Plug 'majutsushi/tagbar', { 'on':  'TagbarToggle' }
Plug 'scrooloose/nerdcommenter', { 'on': '<plug>NERDCommenterToggle'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'thinca/vim-quickrun', { 'on':  'QuickRun' }
" Plug 'ervandew/ag'
Plug 'rking/ag.vim'
" Plug 'mileszs/ack.vim', {'on': ['Ack', 'LAck']}
Plug 'rdnetto/YCM-Generator', { 'on':  'YcmGenerateConfig' }
Plug 'honza/vim-snippets'
Plug 'ternjs/tern_for_vim', { 'on': 'TernType' }
" ---------------------------------------------------
" "Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
"" Disable AutoComplPop.
" 70f4
" Plug 'Shougo/neocomplete.vim'
" Plug 'SirVer/ultisnips'
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3

" " Define dictionary.
" let g:neocomplete#sources#dictionary#dictionaries = {
   " \ 'default' : '',
   " \ 'vimshell' : $HOME.'/.vimshell_hist',
   " \ 'scheme' : $HOME.'/.gosh_completions'
       " \ }

" " Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
   " let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" " Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()

" " Recommended key-mappings.
" " <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
 " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
 " " For no inserting <CR> key.
 " "return pumvisible() ? "\<C-y>" : "\<CR>"
" endfunction
" " <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" " <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" " Close popup by <Space>.
" "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" " AutoComplPop like behavior.
" "let g:neocomplete#enable_auto_select = 1

" " Shell like behavior(not recommended).
" "set completeopt+=longest
" "let g:neocomplete#enable_auto_select = 1
" "let g:neocomplete#disable_auto_complete = 1
" "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" " Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
 " let g:neocomplete#sources#omni#input_patterns = {}
" endif
" "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" " For perlomni.vim setting.
" " https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"------------------------------------------------------------------------
" 7F4
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'Valloric/YouCompleteMe', { 'on': [] }
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| autocmd! load_us_ycm
augroup END
let g:ycm_keep_logfiles = 1
let g:ycm_log_level = 'debug'
noremap <C-F8> :YcmRestartServer<CR>
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'}
Plug 'skywind3000/asyncrun.vim', {'on': 'AsyncRun' }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Lokaltog/vim-easymotion'
" Plug 'mattn/emmet-vim', { 'on': 'Emmet' }
Plug 'mattn/emmet-vim'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'duggiefresh/vim-easydir'
Plug 'junegunn/fzf.vim', { 'on': 'Files'}
Plug 'chrisbra/SudoEdit.vim'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'terryma/vim-multiple-cursors'
Plug 'maksimr/vim-jsbeautify'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-rails'
Plug 'suan/vim-instant-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'fatih/vim-go'
Plug 'fatih/vim-go-tutorial'
" Plug 'vimwiki/vimwiki', { 'on': 'VimwikiIndex' }
Plug 'vimwiki/vimwiki'
Plug 'sukima/xmledit'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/DoxyGen-Syntax'
Plug 'vim-scripts/sketch.vim'
Plug 'vim-scripts/DrawIt'
Plug 'triglav/vim-visual-increment'
Plug 'vim-scripts/DoxygenToolkit.vim'
" Plug 'kien/ctrlp.vim'
Plug 'wesleyche/SrcExpl'
Plug 'vim-jp/vim-cpp'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'asins/vimcdoc'
Plug 'vim-utils/vim-man'
Plug 'shawncplus/phpcomplete.vim'
Plug 'hdima/python-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'gregsexton/gitv'
Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
" xmap ea <Plug>(EasyAlign)
xmap <c-e> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ea <Plug>(EasyAlign)
nmap <c-e> <Plug>(EasyAlign)
Plug 'Shougo/vimshell.vim', { 'on': 'VimShell' }
Plug 'eagletmt/neco-ghc'
Plug 'Shougo/context_filetype.vim'
 " 与youcompleteme的python补全冲突
" Plug 'davidhalter/jedi-vim'
Plug 'terryma/vim-expand-region'
Plug 'MattesGroeger/vim-bookmarks'
" Plug 'kendling/visual_studio.vim'
Plug 'pangloss/vim-javascript'
Plug 'othree/xml.vim'
Plug 'kchmck/vim-coffee-script'
" DISABLE: Slow to open big css file
" Plug 'skammer/vim-css-color'
Plug 'groenewege/vim-less'
Plug 'wavded/vim-stylus'
Plug 'plasticboy/vim-markdown'
" Plug 'godlygeek/tabular'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
Plug 'osyo-manga/unite-quickrun_config'
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mbbill/fencview'
Plug 'ujihisa/neco-look'
Plug 'vim-scripts/hexHighlight.vim'
Plug 'vim-scripts/Pydiction'
Plug 'vim-scripts/TeTrIs.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'taku-o/vim-chardet'
Plug 'blockloop/vim-swigjs'
Plug 'clones/vim-genutils'
Plug 'thinca/vim-logcat'
" Plug 'vim-scripts/Align'
Plug 'eagle0701/vim-escalt'
Plug 'fsouza/pythoncomplete.vim'
call plug#end()


" ---------------------------------------------------
if !exists('g:LookupFile_TagExpr')
  let g:LookupFile_TagExpr = '&tags'
endif
" exEnvironmentSetting post update
" NOTE: this is a post update environment function used for any custom environment update 
" function g:exES_PostUpdate()
function g:Exvim_post_init()

    " let g:exvim_folder = './.exvim.'.project_name
    let project_name = vimentry#get('project_name')
    let g:ex_project_name = vimentry#get('project_name')
    if project_name == ''
        let g:ex_project_exdir = './'
        let g:ex_qfix_file = './error.qfix'
        let g:ex_error_file = './error.err'
        call ex#hint("No project name, Use ./ .")
    else
        let g:ex_project_exdir = './.exvim.'.project_name
        let g:ex_qfix_file = g:ex_project_exdir.'/error.qfix'
        let g:ex_error_file = g:ex_project_exdir.'/error.err'
    endif
    call exqfix#set_qfix_file(g:ex_qfix_file)

    let project_maker = vimentry#get('project_maker')
    let g:ex_project_maker = vimentry#get('project_maker')
    if project_maker == ''
        call ex#hint("Use default makeprg.")
    else
        let &makeprg = project_maker
    endif

    let project_cflags = vimentry#get('project_cflags')
    if project_cflags != ''
        let g:c_cflags = project_cflags
    endif

    let project_filenametags= vimentry#get('project_filenametags')
    if project_filenametags!= ''
        let g:filenametags=project_filenametags 
    else
        let g:filenametags= '&tags'
    endif


    let project_syntastic_cpp_flags = vimentry#get('project_syntastic_cpp_flags')
    if project_syntastic_cpp_flags != ''
        let g:syntastic_c_compiler_options = project_syntastic_cpp_flags
        let g:syntastic_cpp_compiler_options = project_syntastic_cpp_flags
        " let g:clang_user_options = g:clang_user_options . g:syntastic_c_compiler_options
        " let g:clang_user_options = g:clang_user_options . g:syntastic_c_compiler_options
    endif

    let project_syntastic_java_javac_classpath = vimentry#get('project_syntastic_java_javac_classpath')
    if project_syntastic_java_javac_classpath!= ''
        let g:syntastic_java_javac_classpath = project_syntastic_java_javac_classpath 
        " let g:JavaComplete_LibsPath = project_syntastic_java_javac_classpath
        let g:java_classpath = project_syntastic_java_javac_classpath
        " let $CLASSPATH=project_syntastic_java_javac_classpath
    endif

    " let project_debuger = vimentry#get('project_debuger')
    " if project_debuger != ''
        " let &gdbprg = project_debuger
    " else
        " let &gdbprg = gdb
    " endif

    " set tag file path
    if exists( 'g:exES_Tag' )
        "let &tags = &tags . ',' . g:exES_Tag
        let &tags = escape(g:exES_Tag, " ")
    endif

    " set vimwiki
    if exists( 'g:exES_wikiHome' )
        " clear the list first
        if exists( 'g:vimwiki_list' ) && !empty(g:vimwiki_list)
            silent call remove( g:vimwiki_list, 0, len(g:vimwiki_list)-1 )
        endif

        " assign vimwiki pathes, 
        " NOTE: vimwiki need full path.
        let g:vimwiki_list = [ { 'path': fnamemodify(g:exES_wikiHome,":p"), 
                    \ 'path_html': fnamemodify(g:exES_wikiHomeHtml,":p"),
                    \ 'html_header': fnamemodify(g:exES_wikiHtmlHeader,":p") } ]

        " create vimwiki files
        " call exUtility#CreateVimwikiFiles ()
    endif

    let &dict = &dict . ',' . g:ex_project_exdir . '/symbols'

    " exvim工程，则默认启动,太慢
    " silent exec 'YcmRestartServer'
endfunction
" noremap <a-r>  :call g:exES_PostUpdate()<cr>
noremap <leader>rs :call g:exvim_post_init()<cr>
noremap <c-f6> :YcmRestartServer<cr>

"/////////////////////////////////////////////////////////////////////////////
" Default colorscheme setup
"/////////////////////////////////////////////////////////////////////////////
if has('gui_running')
    set background=dark
else
    set background=dark
    set t_Co=256 " make sure our terminal use 256 color
    let g:solarized_termcolors = 256
endif
colorscheme solarized
" colorscheme exlightgray
" colorscheme exlightgray
" colorscheme torte
" colorscheme softbluev2
let g:molokai_original = 1
colorscheme molokai
" colorscheme molokai
"/////////////////////////////////////////////////////////////////////////////
" local setup
"/////////////////////////////////////////////////////////////////////////////
"-----------------------------------------------------------------------------  
" General -   
"-----------------------------------------------------------------------------  
" set guiheadroom=-20
" set lines=999 columns=999

" winpos  900  0
winpos  1250  0
" set lines=50 columns=300
" set lines=80 columns=180
set lines=60 columns=350


" winpos 780 0 
" set lines=41 columns=85

" au GUIEnter * winpos 780 0|winsize 80 41
" au GUIEnter * winpos 950 250  winsize 100 35
au GUIEnter * winpos 1250 0|winsize 80 41

set nocompatible         " Use Vim settings, rather then Vi settings (much better!). This must be first, because it changes other options as a side effect.
set langmenu=none        " always use English menu
" set termencoding=utf-8   "tenc==termencoding
set encoding=utf-8       "enc == encoding
" set encoding=cp936       "enc == encoding 同时会导致powerline 出错，
set fenc=utf-8           "fenc == fileencoding
" set fileencodings=ucs-bom,utf-8,cp936 "fencs==fileencodings
set fileencodings=utf-8,gbk,gb2312,gb18030,cp936,latin1
" set fileencodings=utf-bom,utf-8,gbk,gb2312,gb18030,cp936,latin1
" set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1
set ambiwidth=double
let g:fencview_autodetect = 0    "会导致<leader>gg 出问题？
language messages en_US.UTF-8     " language messages zh_CN.utf-8
"/////////////////////////////////////////////////////////////////////////////
" General
"/////////////////////////////////////////////////////////////////////////////

"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search 
" set path=.,/usr/include/*,, " where gf, ^Wf, :find will search   default on Unix: ".,/usr/include,," 
set path=.
" set path+=/usr/include/
" set path+=/usr/include/libgnomeui-2.0/
" set path+=/usr/include/libgnomeui-2.0/libgnomeui/
" set path+=/usr/local/include/
" set path+=/usr/lib/gcc/i686-redhat-linux/4.6.3/include 
" set path+=/home/yang/soft/src/cpp_src/

" -I/usr/include/c++/4.6.3
" -I/usr/include/c++/4.6.3/i686-redhat-linux
" -I/usr/include/c++/4.6.3/backward 
" -I/usr/lib/gcc/i686-redhat-linux/4.6.3/include 
" -I/usr/local/include 
" -I/usr/include/

autocmd FileType c,cpp silent call SetENV_C()
autocmd FileType java silent call SetENV_JAVA()
autocmd FileType python silent call SetENV_PYTHON()

" set tags+=./tags,./../tags,./**/tags,tags " which tags files CTRL-] will find 
set tags=./tags
" set tags+=/usr/include/.vimfiles..vimentry/tags
" set tags+=/usr/local/include/.vimfiles..vimentry/tags
" set tags+=/usr/lib/gcc/i686-redhat-linux/4.6.3/include/.vimfiles..vimentry/tags
" set tags+=/home/yang/soft/src/cpp_src/.vimfiles..vimentry/tags
" set tags+=/opt/hisi-linux/x86-arm/.vimfiles.hsv200/tags
" set tags+=/usr/include/boost/.vimfiles.boost/tags
" set tags+=/home/yang/QtSDK/Desktop/Qt/473/gcc/include/.vimfiles.qt_desktop/tags
" set tags+=/home/yang/soft/src/qtsrc473/src/vimfiles.qtsrc/tags
function SetENV_C()
    set dictionary=$VIM/vimfiles/tools/dicts/cpp.dict
    set dictionary+=$VIM/vimfiles/tools/dicts/dict.dict
    set dictionary+=$VIM/vimfiles/tools/dicts/mfc.dict
    " set tags+=D:/WinInc/tags
endfunction
function SetENV_JAVA()
    set dictionary=$HOME/.vim/tools/dicts/java.dict
    set dictionary+=$HOME/.vim/tools/dicts/dict.dict
    " set tags+=/opt/jdk1.6.0_45/.vimfiles.jdk/tags
endfunction
function SetENV_PYTHON()
    set dictionary=$VIM/vimfiles/tools/dicts/python.dict
    set dictionary+=$VIM/vimfiles/tools/dicts/dict.dict
    set dictionary+=$VIM/vimfiles/plugged/pydiction/complete-dict
    " set tags+=/opt/jdk1.6.0_45/.vimfiles.jdk/tags
endfunction
let g:pydiction_location=$VIM.'\vimfiles/plugged/pydiction/complete-dict'

set backup " make backup file and leave it around 
"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search 
set backup " make backup file and leave it around 

" setup back and swap directory
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup' 
let swap_dir = data_dir . 'swap' 
if finddir(data_dir) == ''
    silent call mkdir(data_dir)
endif
if finddir(backup_dir) == ''
    silent call mkdir(backup_dir)
endif
if finddir(swap_dir) == ''
    silent call mkdir(swap_dir)
endif
unlet backup_dir
unlet swap_dir
unlet data_dir

set backupdir=$HOME/.data/backup " where to put backup file 
set directory=$HOME/.data/swap " where to put swap file 

" setup back and swap directory
set backup " make backup file and leave it around 
" set noswf
set undofile
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup' 
let swap_dir = data_dir . 'swap' 
let undo_dir = data_dir . 'undo' 

if finddir(data_dir) == ''
    silent call mkdir(data_dir)
endif
if finddir(backup_dir) == ''
    silent call mkdir(backup_dir)
endif
if finddir(swap_dir) == ''
    silent call mkdir(swap_dir)
endif
if finddir(undo_dir) == ''
    silent call mkdir(undo_dir)
endif
set backupdir=$HOME/.data/backup " where to put backup file 
set directory=$HOME/.data/swap " where to put swap file 
set undodir  =$HOME/.data/undo " where to put undo file 
unlet data_dir
unlet backup_dir
unlet swap_dir
unlet undo_dir

" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=5000 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)
set nomore

"/////////////////////////////////////////////////////////////////////////////
" xterm settings
"/////////////////////////////////////////////////////////////////////////////

behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
    set mouse=a
endif

"/////////////////////////////////////////////////////////////////////////////
" Variable settings ( set all )
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Visual
" ------------------------------------------------------------------ 

set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor 
set nowrap " do not wrap text

" only supoort in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

" set default guifont
if has('gui_running')
    augroup ex_gui_font
        " check and determine the gui font after GUIEnter. 
        " NOTE: getfontname function only works after GUIEnter.  
        au!
        au GUIEnter * call s:set_gui_font()
    augroup END

    " set guifont
    function! s:set_gui_font()
        if has('gui_gtk2')
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ 12
            else
                set guifont=Luxi\ Mono\ 12
            endif
        elseif has('x11')
            " Also for GTK 1
            set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
        elseif OSX()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h15
            endif
        elseif WINDOWS()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                " set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI
                set guifont=DejaVu_Sans_Mono_for_Powerline:h11:cANSI:qDRAFT  
                " set guifont=AAA_Yahei_Mono_Monaco_Powerline:h11:cANSI:qDRAFT 
                " set guifont=Hack:h11:cANSI:qDRAFT    
                " set guifont=Ubuntu_Mono_derivative_Powerlin:h11:cANSI:qDRAFT 
                " set guifont=InputMonoCondensed:h11:cANSI:qDRAFT 
                set guifontwide=AAA_Yahei_Mono_Monaco_Powerline:h11:cANSI:qDRAFT 
                " set guifontwide=幼圆:b:h11:cGB2312  
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h11:cANSI
            elseif getfontname( 'Consolas' ) != ''
                set guifont=Consolas:h11:cANSI " this is the default visual studio font
            else
                set guifont=Lucida_Console:h11:cANSI
            endif
        endif
    endfunction
endif






" ------------------------------------------------------------------ 
" Desc: Vim UI
" ------------------------------------------------------------------ 

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

" set window size (if it's GUI)
if has('gui_running')
    " set window's width to 130 columns and height to 40 rows
    if exists('+lines')
        set lines=40
    endif
    if exists('+columns')
        set columns=130
    endif

    " DISABLE
    " if WINDOWS()
    "     au GUIEnter * simalt ~x " Maximize window when enter vim
    " else
    "     " TODO: no way right now
    " endif
endif

set showfulltag " show tag with function protype.

" ------------------------------------------------------------------ 
" Desc: Text edit
" ------------------------------------------------------------------ 

set ai " autoindent 
set si " smartindent 
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

" official diff settings
set diffexpr=g:MyDiff()
function! g:MyDiff()
    let opt = '-a --binary -w '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
endfunction

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=

" ------------------------------------------------------------------ 
" Desc: Fold text
" ------------------------------------------------------------------ 

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------ 
" Desc: Search
" ------------------------------------------------------------------ 

set showmatch " show matching paren 
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case 
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Auto Command
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------ 

if has('autocmd')

    augroup ex
        au!

        " ------------------------------------------------------------------ 
        " Desc: Buffer
        " ------------------------------------------------------------------ 

        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full) 
        au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

        " DISABLE { 
        " NOTE: will have problem with exvim, because exvim use exES_CWD as working directory for tag and other thing
        " Change current directory to the file of the buffer ( from Script#65"CD.vim"
        " au   BufEnter *   execute ":lcd " . expand("%:p:h") 
        " } DISABLE end 

        " ------------------------------------------------------------------ 
        " Desc: file types 
        " ------------------------------------------------------------------ 

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:// 
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f:// 
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        au FileType lua set comments=f:--

        " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
        au FileType python,coffee call s:check_if_expand_tab()
    augroup END

    function! s:check_if_expand_tab()
        let has_noexpandtab = search('^\t','wn')
        let has_expandtab = search('^    ','wn')

        "
        if has_noexpandtab && has_expandtab
            let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
                        \ '1. expand (tab=space, recommended)', 
                        \ '2. noexpand (tab=\t, currently have risk)',
                        \ '3. do nothing (I will handle it by myself)'])
            let tab_space = printf('%*s',&tabstop,'')
            if idx == 1
                let has_noexpandtab = 0
                let has_expandtab = 1
                silent exec '%s/\t/' . tab_space . '/g'
            elseif idx == 2
                let has_noexpandtab = 1
                let has_expandtab = 0
                silent exec '%s/' . tab_space . '/\t/g'
            else
                return
            endif
        endif

        " 
        if has_noexpandtab == 1 && has_expandtab == 0  
            echomsg 'substitute space to TAB...'
            set noexpandtab
            echomsg 'done!'
        elseif has_noexpandtab == 0 && has_expandtab == 1
            echomsg 'substitute TAB to space...'
            set expandtab
            echomsg 'done!'
        else
            " it may be a new file
            " we use original vim setting
        endif
    endfunction
endif

"/////////////////////////////////////////////////////////////////////////////
" Key Mappings
"/////////////////////////////////////////////////////////////////////////////
" NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

" Don't use Ex mode, use Q for formatting
map Q gq  

" define the copy/paste judged by clipboard
if &clipboard ==# 'unnamed'
    " fix the visual paste bug in vim
    " vnoremap <silent>p :call g:()<CR>
else
    " general copy/paste.
    " NOTE: y,p,P could be mapped by other key-mapping
    map <leader>y "*y
    map <leader>p "*p
    map <leader>P "*P
endif

" copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :let @*=fnamemodify(bufname('%'),":p:h")<CR>

" copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :let @*=fnamemodify(bufname('%'),":p:t")<CR>

" copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c 
nnoremap <silent> <leader>y3 :let @*=fnamemodify(bufname('%'),":p")<CR>

" F8 or <leader>/:  Set Search pattern highlight on/off
" nnoremap <F8> :let @/=""<CR>
nnoremap <leader>/ :let @/=""<CR>
" nnoremap <leader>/ :let @/=""<CR>
" DISABLE: though nohlsearch is standard way in Vim, but it will not erase the 
"          search pattern, which is not so good when use it with exVim's <leader>r 
"          filter method
" nnoremap <F8> :nohlsearch<CR>
" nnoremap <leader>/ :nohlsearch<CR>

" map Ctrl-Tab to switch window
nnoremap <S-Up> <C-W><Up>
nnoremap <S-Down> <C-W><Down>
nnoremap <S-Left> <C-W><Left>
nnoremap <S-Right> <C-W><Right>
nnoremap <A-k> <C-W><Up>
nnoremap <A-j> <C-W><Down>
nnoremap <A-h> <C-W><Left>
nnoremap <A-l> <C-W><Right>
nnoremap <leader>gk <C-W><Up>
nnoremap <leader>gj <C-W><Down>
nnoremap <leader>gh <C-W><Left>
nnoremap <leader>gl <C-W><Right>

" easy buffer navigation
" NOTE: if we already map to EXbn,EXbp. skip setting this
if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
    nnoremap <C-l> :bn<CR>
endif
if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
    noremap <C-h> :bp<CR>
endif

" easy diff goto
noremap <C-k> [c
noremap <C-j> ]c

" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

" TODO: I should write a better one, make it as plugin exvim/swapword
" VimTip 329: A map for swapping words
" http://vim.sourceforge.net/tip_view.php?tip_id=
" Then when you put the cursor on or in a word, press "\sw", and
" the word will be swapped with the next word.  The words may
" even be separated by punctuation (such as "abc = def").
nnoremap <silent> <leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

"/////////////////////////////////////////////////////////////////////////////
" local setup
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 
set completeopt=menu,longest
" set completeopt=menuone,longest
" set complete-=i  " Don't scan include files
" set complete=.,w,b,u,U,k,s,i,d,t
set complete=.,w,b,u,k,s,i,d,t
set magic
set noerrorbells
set novisualbell
set t_vb=
set mat=2    "How many tenths of a second to blink
set hlsearch "Highlight search things
set winaltkeys=no
set smarttab
set cursorline
set history=400     "Sets how many lines of history VIM har to remember
filetype plugin on  "Enable filetype plugin
filetype indent on
set updatetime=1000 " default = 4000
set autoread        " auto read same-file change ( better for vc/vim change )
set textwidth=120   "设置最大列数，超出后自动换行

" set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci-c:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175  
"Have the mouse enabled all the time:
set mouse=a
" set autochdir
" set guitablabel=%N/\ %t\ %M
" set bg=dark
syntax enable  "Enable syntax hl
" if has("gui_running")
" set cursorline
" hi cursorline guibg=#333333
" hi CursorColumn guibg=#333333
" endif
" hi cursorline guibg=NONE gui=underline

autocmd FileType python setlocal et sta sw=4 sts=4
set shiftwidth=4
set tabstop=4            " Set tabstop to 4 characters
set expandtab            " Set expandtab on, the tab will be change to space automaticaly
set softtabstop=4    
set nf=                  " Set Number format to null(default is octal) , when press CTRL-A on number
set ve=block             " In Visual Block Mode, cursor can be positioned where there is no actual character
set nofen                "Enable folding, I find it very useful
"set foldcolumn=2          "导致vim左边多一个白色的边
" set foldmethod=syntax  fdn=6
set foldmethod=manual
" noremap zc zf%
noremap <leader>zc zf%
" set foldlevel=2
" set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999
set wildmenu             " turn on wild menu, try typing :h and press <Tab> 
set showcmd	             " display incomplete commands
set cmdheight=1          " 1 screen lines to use for the command-line 
set ruler                " show the cursor position all the time
set hid                  " allow to change buffer without saving 
set shortmess=atI        " shortens messages to avoid 'press a key' prompt 
set lazyredraw           "set lz" do not redraw while executing macros (much faster) 
set display+=lastline    " for easy browse last line with wrap text
set showfulltag          " show tag with function protype.
set guioptions-=m
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions+=acit    "不用弹出对话框窗口的交互模式，只在命令行交互，3x 百合仙子
"set noic               "Ignore case in search patterns.  Also used when searching in the tags file.  Also see 'smartcase'.
set clipboard=unnamed
"au GUIEnter * simalt ~x
set laststatus=2        " always have status-line
if version >= 700
    au InsertEnter * hi StatusLine guibg=#818D29 guifg=#FCFCFC gui=none
    au InsertLeave * hi StatusLine guibg=#EEEEEE guifg=#363636 gui=none
endif

" set formatoptions+=rmM
set fo=croqn2mM1
" set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
" set statusline=%n\ %<%f\ %L行\ %{&modified?'[+]':&modifiable\|\|&ft=~'^\\vhelp\|qf$'?'':'[-]'}%h%r%{&fenc=='utf-8'\|\|&fenc==''?'':'['.&fenc.']'}%{&ff=='unix'?'':'['.&ff.']'}%{&bomb?'[BOM]':''}%{&eol?'':'[noeol]'}%=\ 0x%-4.4B\ \ \ \ %-14.(%l,%c%V%)\ %P  “仙子的
"Tab complete now ignores these file types



" set sb

set wildignore=*.o,*.obj,*.bak,*.exe,*~
set so=7                "Set 7 lines to the curors - when moving vertical..  minimal number of screen lines to keep above and below the cursor 
"set whichwrap+=<,>,h,l     "Bbackspace and cursor keys wrap to
set backspace=2            " set backspace=indent,eol,start  allow backspacing over everything in insert mode " indent options

" set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,+0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30 
" set cinoptions+=j1

" let java_comment_strings=1
" let java_highlight_java_lang_ids=1
" let java_mark_braces_in_parens_as_errors=1
" let java_highlight_all=1
" let java_highlight_debug=1
" let java_ignore_javadoc=1
" let java_highlight_java_lang_ids=1
" let java_highlight_functions="style"
" let java_minlines = 150

" see help cinoptions-values for more details " default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e      "default
set modeline        " au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
set showmode
set imcmdline
set incsearch       " do incremental searching
set ignorecase    " Set search/replace pattern to ignore case  这个参数也会导致vjde无法补全 
set smartcase       " Set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.
"set ghr=400
set ghr=0
set showmatch      " show matching paren  设置匹配模式
set matchtime=0    " 0 second to show the matching paren ( much faster )
set nu             " Show LineNumber
" NOTE: viminfo
" for MS-DOS, Windows and OS/2: '20,<50,s10,h,rA:,rB:,
" for Amiga: '20,<50,s10,h,rdf0:,rdf1:,rdf2:
" for others: '20,<50,s10,h
set viminfo+=! " make sure it can save viminfo 
filetype on " enable file type detection 
filetype plugin on " enable loading the plugin for appropriate file type 
"set isk+=$,%,#,- " none of these should be word dividers 
" noremap <silent><leader>rs :source ~/.vimrc<cr>   
if has ("unix")
    noremap <leader>ee :e! ~/.vimrc<cr>
else
    noremap <leader>ee :e! $VIM\_vimrc<cr>
endif
" autocmd! bufwritepost .vimrc silent source ~/.vimrc "When .vimrc is edited, reload it

" source $VIMRUNTIME/vimrc_example.vim
behave xterm  " set mouse behavior as xterm


" set makeef=error.err " the errorfile for :make and :grep 
" set makeef=.exvim.hs/error.qfix " the errorfile for :make and :grep 
" set makeprg=make
" set makeprg=make\ 2>&1\\\|tee\ errors.qfix
let g:ex_project_maker = 'make'
" function I_lMk()
    " " :cd %:p:h
    " lmake
    " exec "normal \<c-o>"
    " lopen
    " exec "normal G"
    " exec "normal ?err"
" endfunction
" function I_lMkClean()
    " " :cd %:p:h
    " make clean
" endfunction
function IBuild()
    if WINDOWS()
        " exec "!".g:ex_project_maker. " > ".g:ex_qfix_file. " 2>&1 "
        exec "!".g:ex_project_maker. " > ".g:ex_error_file. " 2>&1 "
    elseif has ("unix")
        " exec "!".g:ex_project_maker. " 2>&1 |tee ".g:ex_qfix_file
        exec "!".g:ex_project_maker. " 2>&1 |tee ".g:ex_error_file
    endif

    " exec "cgetfile ".g:ex_qfix_file
    " exec "copen" 
    " exec "w! ".g:ex_qfix_file
    " exec "close"
    " silent exec 'QFix '. g:ex_qfix_file
    " call search('error')


    exec "cgetfile ".g:ex_error_file
    exec "copen" 
    let qfixlist = getbufline(bufnr('%'), 1, "$")
    call writefile(qfixlist, g:ex_qfix_file)
    exec "close"
    silent exec 'QFix '. g:ex_qfix_file

    " silent redir! >qfix_list
    " exec "cgetfile ".g:ex_qfix_file
    " silent! exec 'cl'
    " silent! exec "copen" 
    " silent redir END
    " silent exec 'QFix qfix_list' 

    " call exqfix#open(g:ex_qfix_file)
    " silent exec '1,$d _'
    " silent put! = qfix_list
    
    " silent exec 'QFix '. g:ex_qfix_file
endfunction

function IBuildClean()
    exec "!".g:ex_project_maker." clean "
endfunction

noremap <unique> <silent> <leader><F1>  :call IBuild()<cr>
noremap <unique> <silent> <S-F1>  :call IBuildClean()<cr>

" function I_Make()
" " :cd %:p:h
" :make
" endfunction
" function I_MakeClean()
" " :cd %:p:h
" :make clean
" endfunction
" noremap <unique> <silent> <leader><F1>  :call I_Make()<cr>
" " noremap <unique> <silent> <C-F1>  :call I_MakeClean()<cr>
" noremap <unique> <silent> <leader><F2>  :call I_MakeClean()<cr>
" command CL call I_MakeClean()

" noremap <unique> <silent> <leader><F2>  :copen<cr>
" noremap <unique> <silent> <S-F2>  :cclose<cr>

" au QuickfixCmdPost make exec 'QF error.err'
" au QuickfixCmdPost grep exec 'botright copen'
" au QuickfixCmdPost lgrep exec 'lopen'
" set this to use id-utils for global search
" map <F3> :lgrep! 
function! LMGrep(args)
    execute "silent! lgrep " . a:args
    botright lopen
    exec "redraw!"
endfunction

function! LMGrepAdd(args)
    execute "silent! lgrepadd " . a:args
    botright lopen
    exec "redraw!"
endfunction

command! -nargs=* -complete=file LMGrep call LMGrep(<q-args>)
command! -nargs=* -complete=file LMGrepAdd call LMGrepAdd(<q-args>)

nnoremap <silent> <F3> :LQFix<CR>
" nnoremap <silent> <F3> :CQFix<CR>
" ------------------------------------------------------------------ 
" NOTE: F10 looks like have some feature, when noremap with F10, the noremap will take no effects
" Don't use Ex mode, use Q for formatting
" noremap Q gq    

" F8:  Set Search pattern highlight on/off
" nnoremap <unique> <F8> :let @/=""<CR>
" nnoremap <unique> <F8> :nohl<CR>

" nnoremap <unique> <silent><F8> :let @/=""<CR>
" :SearchReset<CR>


" Move in fold
" noremap <unique> z<Up> zk
" noremap <unique> z<Down> zj
" if has("gui_running") "  the <alt> key is only available in gui mode.
" noremap <unique> <A-Up> zk
" noremap <unique> <A-Down> zj
" endif

" Easy Diff goto
" noremap <unique> <C-Up> [c
" noremap <unique> <C-k> [c
" noremap <unique> <C-Down> ]c
" noremap <unique> <C-j> ]c

" Fold close & Fold open
noremap <unique> <kPlus> zo
noremap <unique> <kMinus> zc

" noremap Up & Down to gj & gk, helpful for wrap text edit
" noremap <unique> <Up> gk
" noremap <unique> <Down> gj

" noremap for completion see :help ins-completion for whole completions
" search tags 
" inoremap <unique> <c-]> <C-X><C-]>
" search in current files, preview first. remove the original c-p
" inoremap <unique> <c-p> <C-X><C-P>

" VimTip 329: A noremap for swapping words
" http://vim.sourceforge.net/tip_view.php?tip_id=
" Then when you put the cursor on or in a word, press "\sw", and
" the word will be swapped with the next word.  The words may
" even be separated by punctuation (such as "abc = def").
" nnoremap <unique> <silent><leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

" perforce key mapping
" TODO: should go to exSourceControl someday. { 
" let g:proj_run1='!p4 edit %f'
" nnoremap <Leader>po :silent !p4 edit %<CR>
" nnoremap <Leader>pr :silent !p4 revert %<CR>
command Checkout silent exec '!p4 edit ' . fnamemodify( bufname('%'), ':p' )
command Revert silent exec '!p4 revert ' . fnamemodify( bufname('%'), ':p' )
command Add silent exec '!p4 add ' . fnamemodify( bufname('%'), ':p' )
command Delete silent exec '!p4 delete ' . fnamemodify( bufname('%'), ':p' )
command Changelist :silent !p4 change
command ShowChangelist :!p4 changes -s pending -u jwu
" } TODO end 

" ------------------------------------------------------------------ 
" Auto Command
" ------------------------------------------------------------------ 
" ------------------------------------------------------------------ 
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------ 
" ------------------------------------------------------------------ 
" Desc: file types 
" ------------------------------------------------------------------ 
" VimTip 311: Open the folder containing the currently open file
" http://vim.sourceforge.net/tip_view.php?tip_id=
" 
" Occasionally, on windows, I have files open in gvim, that the folder for 
" that file is not open. This key noremap opens the folder that contains the 
" currently open file. The expand() is so that we don't try to open the 
" folder of an anonymous buffer, we would get an explorer error dialog in 
" that case.
" 

" DISABLE: auto highlight cursor word
" let g:ex_auto_hl_cursor_word = 1

" set exvim language noremap
" newexvim call exUtility#AddLangMap ( 'exvim', 'javascript', ['as'] )
" newexvim call exUtility#AddLangMap ( 'exvim', 'maxscript', ['ms'] )
" To let the extension language works correctly, you need to put tools/ctags/.ctags into your $HOME directory
" set ctags language noremap
" newexvim call exUtility#AddLangMap ( 'ctags', 'maxscript', ['ms'] )

" ------------------------------------------------------------------ 
map <Leader><F12> :call HexHighlight()<Return>
" map <C-F12> :call HexHighlight()<Return>

let g:user_zen_leader_key = '<c-z>'
"-----------------------------------------------------------------------------  
let maplocalleader = '\'
"-----------------------------------------------------------------------------  
" if has('win32')
" au GUIEnter * simalt ~x
" else
" au GUIEnter * call MaximizeWindow()
" endif

" function! MaximizeWindow()
" silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
" endfunction


" if expand("%")==""
" cd /
" endif

nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>
noremap <leader>qa :qa<CR>
noremap <leader>qq :q!<CR>

" nnoremap <silent><Leader><ESC> :q<cr>
"noremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" ------------------------------------------------------------------------------
" smart quickfix  ,F1 编译(lmake)  F1 调出quicfix (lopen) ESC 关闭
" ------------------------------------------------------------------------------
" function! QFixToggleC()
" call exUtility#GotoEditBuffer()
" silent! lclose
" endfunction

" function! QFixToggleO()
" call exUtility#GotoEditBuffer()
" silent! lopen
" endfunction

" command -bang -nargs=? QFix call QFixToggle(<bang>0)
" function! QFixToggle(forced)
" if exists("g:qfix_win") && a:forced == 0
" call QFixToggleC()
" unlet g:qfix_win
" else
" call QFixToggleO()
" let g:qfix_win = bufnr("$")
" endif
" endfunction

" nnoremap <silent> <F1> :QFix<CR>
" ------------------------------------------------------------------------------
" 根据buf号，快速切换buf           
" ------------------------------------------------------------------------------
"function! BufPos_ActivateBuffer(num)
"    " call exUtility#GotoEditBuffer() 
"    if a:num == 0
"        " echo "No buffer " . a:num "!"
"        echo " "
"        return
"    endif
"    if a:num > bufnr("$")
        " echo "No buffer " . a:num "!"
            " else
"        if buflisted(a:num) && getbufvar(a:num, "&modifiable") 
"            " if '*vimshell*'==bufname(a:num)
"            " echo "can's switch to buffer ".bufname(a:num)"!"
"            " else
"            call ex#window#goto_edit_window()
"            exe "buffer " . a:num
"            " endif
            " endif
"    endif
"endfunction
" nnoremap <silent> <space> :<C-U>call BufPos_ActivateBuffer(v:count)<CR>
" nnoremap <silent> <tab> :<C-U>call BufPos_ActivateBuffer(v:count)<CR>
" nnoremap <silent>, :<C-U>call BufPos_ActivateBuffer(v:count)<CR>
imap <a-.> <c-x><c-k>
" nnoremap <tab> <c-^>
nnoremap <silent> <tab> :<C-U>call MyTabSwitchBuffer(v:count)<CR>
function! MyTabSwitchBuffer(num)
    let l:origBuf  = bufnr('%')
    if a:num == 0
        if bufname("#") == "" || bufname("#") == "-MiniBufExplorer-"
            if bufnr('#') < l:origBuf
                exec "normal \<C-^>"
                silent exec "bp"
                if bufnr('%') == l:origBuf
                    silent exec "bp"
                endif
            else
                exec "normal \<C-^>"
                silent exec "bn"
                if bufnr('%') == l:origBuf
                    silent exec "bn"
                endif
            endif
        else
            exec "normal \<C-^>"
        endif
    else
        if bufname(a:num ) == "" || bufname(a:num ) == "-MiniBufExplorer-" || bufname(a:num ) == "[fuf]" || bufname(a:num ) == "-GSearch-" || bufname(a:num ) == "-Marks-" || bufname(a:num ) == "-Tags-"
            echomsg 'Do not switch to ' . bufname(a:num) .' !'
        else
            exe "buffer " . a:num
        endif
    endif
endfunction  
" ------------------------------------------------------------------------------
"  ctags
" ------------------------------------------------------------------------------
" let g:ctags_options='--c-kinds=+lpx --c++-kinds=+lpx --fields=+ialS --extra=+qf --languages=c,c++,c#,java,python,vim,matlab,make,sh,XML, --langmap=c++:+.,c:+.C,c++:+.H,c++:+.inl,c++:+.ipp,python:+.pyw,c:+.hlsl,c:+.vsh,c:+.psh,c:+.fx,c:+.fxh,c:+.cg,c:+.shd,c:+.glsl, -I EXTERN=extern -I __nonull -I __dead2 -I __pure2 -I __unused -I __packed -I __aligned -I __section -I __always_inline -I __nonnull -I __wur -I __THROW'
let g:ctags_options='--c-kinds=+lpx --c++-kinds=+lpx --fields=+ialS --extra=+qf  -I EXTERN=extern -I __nonull -I __dead2 -I __pure2 -I __unused -I __packed -I __aligned -I __section -I __always_inline -I __nonnull -I __wur -I __THROW'

" function! UpdateTags()
" !rm -f cscope.* tags
" !find $PWD -name "*"  > cscope.files   
" !ctags  --c++-kinds=+px --fields=+ialS --extra=+qf  --langmap=Sh:+".env..rules.patch.conf.inc.README(README)..",make:+".mak"".make""([Mm]akefile).am""([Mm]akefile).in""([Mm]akefile).vc""([Mm]akefile).."  -I "__nonull __dead2 __pure2 __unused __packed __aligned __section __always_inline __nonnull __wur __THROW"  --sort=foldcase   -L  cscope.files
" !cscope -kb -i cscope.files
" endfunction  
function! UpdateTags()
    !rm -f cscope.* tags
    !find $PWD -name "*"  > cscope.files   
    !ctags  --c++-kinds=+px --fields=+ialS --extra=+qf   --langmap=c++:+"." -I "__nonull __dead2 __pure2 __unused __packed __aligned __section __always_inline __nonnull __wur __THROW"     -L  cscope.files
    !cscope -kb -i cscope.files
endfunction  
function! UpdateTagsDepth1()
    !rm -f cscope.* tags
    !find $PWD  -maxdepth 1 -name "*"   > cscope.files   
    !ctags  --c++-kinds=+px --fields=+ialS --extra=+qf   --langmap=c++:+"."  -I "__nonull __dead2 __pure2 __unused __packed __aligned __section __always_inline __nonnull __wur __THROW"    -L  cscope.files
    !cscope -kb -i cscope.files
endfunction  
function! UpdateTagsR()
    !rm -f cscope.* tags
    !find $PWD -name "*"  > cscope.files   
    !ctags  --c++-kinds=+px --fields=+ialS --extra=+qf  --langmap=c++:+"."  -I "__nonull __dead2 __pure2 __unused __packed __aligned __section __always_inline __nonnull __wur __THROW"    -L  cscope.files
    "!cscope -kb -i cscope.files
endfunction  
nnoremap <silent> <leader>up   :Update<CR>

" function UpdateAll()
" :Update
" " :UpdateTypesFile!
" :UpdateTypesFileOnly  
" endfunction
" nnoremap <silent> <leader>ap :call UpdateAll()<CR>
" autocmd VimLeave * :!echo -ne "\e]12;green\007"
" autocmd VimLeave * :!echo -ne "\e]12;black\007"

" 防止退出时终端乱码
" 这里两者都需要。只前者标题会重复，只后者会乱码
set t_fs=(B
set t_IE=(B
" set t_AB=^[[48;5;%dm
" set t_AF=^[[38;5;%dm

" set t_k1=O*P
" set t_k2=O*Q
" set t_k3=O*R
" set t_k4=O*S
" set t_k5=O*S [15~

set selection=old

" au BufEnter *.txt setlocal ft=txt
" au BufEnter *.wiki set nocursorline

" let g:tabular_loaded = 1


let g:TypesFileDoNotGenerateTags = 1
" let b:TypesFileIncludeLocals = 1

let g:Myalign_def = {
            \   'css': ['WP0p1l:', ':\@<=', 'v \v^\s*/\*|\{|\}'],
            \ }
" 对齐命令[[[2
function Lilydjwg_Align(type) range
    try
        let pat = g:Myalign_def[a:type]
    catch /^Vim\%((\a\+)\)\=:E716/
        echohl ErrorMsg
        echo "对齐方式" . a:type . "没有定义"
        echohl None
        return
    endtry
    call Align#AlignPush()
    call Align#AlignCtrl(pat[0])
    if len(pat) == 3
        call Align#AlignCtrl(pat[2])
    endif
    exe a:firstline.','.a:lastline."call Align#Align(0, '". pat[1] ."')"
    call Align#AlignPop()
endfunction
function Lilydjwg_Align_complete(ArgLead, CmdLine, CursorPos)
    return keys(g:Myalign_def)
endfunction

command -nargs=1 -range -complete=customlist,Lilydjwg_Align_complete LA <line1>,<line2>call Lilydjwg_Align("<args>")

" let g:TypesFileDoNotGenerateTags = 1
" let g:TypesCTagsFile =string(eval(g:exES_VimfilesDirName).'/tags_type')
" let g:TypesFileIncludeLocals = 1

function! QtCppIndent()
    " Patterns used to recognise labels and search for the start
    " of declarations
    let labelpat='signals:\|slots:\|public:\|protected:\|private:\|Q_OBJECT'
    let declpat='\(;\|{\|}\)\_s*.'
    " If the line is a label, it's a no brainer
    if match(getline(v:lnum),labelpat) != -1
        return 0
    endif
    " If the line starts with a closing brace, it's also easy: use cindent
    if match(getline(v:lnum),'^\s*}') != -1
        return cindent(v:lnum)
    endif
    " Save cursor position and move to the line we're indenting
    let pos=getpos('.')
    call setpos('.',[0,v:lnum,1,0])
    " Find the beginning of the previous declaration (this is what
    " cindent will mimic)
    call search(declpat,'beW',v:lnum>10?v:lnum-10:0)
    let prevlnum = line('.')
    " Find the beginning of the next declaration after that (this may
    " just get us back where we started)
    call search(declpat,'eW',v:lnum<=line('$')-10?v:lnum+10:0)
    let nextlnum = line('.')
    " Restore the cursor position
    call setpos('.',pos)
    " If we're not after a label, cindent will do the right thing
    if match(getline(prevlnum),labelpat)==-1
        return cindent(v:lnum)
        " It will also do the right thing if we're in the middle of a
        " declaration; this occurs when we are neither at the beginning of
        " the next declaration after the label, nor on the (non-blank) line
        " directly following the label
    elseif nextlnum != v:lnum && prevlnum != prevnonblank(v:lnum-1)
        return cindent(v:lnum)
    endif
    " Otherwise we adjust so the beginning of the declaration is one
    " shiftwidth in
    return &shiftwidth
endfunc
"这个会导致c++ public关键字缩进有问题
" set indentexpr=QtCppIndent()

" -----------------------------------------------------------------
" 二进制 vim -b 二进制文件
" 十六进制 先以二进制打开文件，再在命令模式键入 :%!xxd
" command TOBIN silent exec '%!xxd'
"To hex modle
let s:hexModle = "N"
function! ToHexModle()
    if s:hexModle == "Y"
        %!xxd -r
        let s:hexModle = "N"
    else
        %!xxd
        let s:hexModle = "Y"
    endif
endfunction

map <leader>hx :call ToHexModle()<cr>

function! DoPrettyXML()
    silent %!xmllint --format  --encode UTF-8 -
endfunction
command! PrettyXML call DoPrettyXML()
" au FileType xml exe ":silent 1,$!xmllint \"%\" --format --recover"
" au FileType xml exe ":silent 1,$!tidy --input-xml true --indent yes 2>/dev/null"
" au FileType xml exe ":silent 1,$!XMLLINT_INDENT='    ' xmllint --format --encode UTF-8 --recover - 2>/dev/null"


function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        " echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    " exec('leftabove  '.a:pfx.'open')
    exec(a:pfx.'open')
    if winnr() != winnr
        " wincmd p
    endif
endfunction

function! TQFix()
    :LQFix
    :CQFix
endfunction


command -bang -nargs=? LQFix call ToggleList("Location List", 'l')
command -bang -nargs=? CQFix call ToggleList("Quickfix List", 'c')
command -bang -nargs=? TQFix call TQFix()

" nnoremap <silent> <F1> :TQFix<CR>
" nnoremap <silent> <F1> :LQFix<CR>
nnoremap <silent> <C-F1> :CQFix<CR>
" nnoremap <silent> <S-F1> :LQFix<CR>
" nnoremap <silent> <F1> :CQFix<CR>
nmap <silent> <leader>lo :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>co :call ToggleList("Quickfix List", 'c')<CR>
map <leader>er /error<CR>

command -nargs=? Sw :w !sudo tee %


let g:EasyGrepWindow=1
let g:EasyGrepReplaceWindowMode=2


" function CleanupStuff()
" silent! exec 'bdelete *vimshell*'
" endfunction
" autocmd VimLeavePre * call CleanupStuff()
au BufWinLeave  silent! mkview
au BufWinEnter  silent! loadview

" set splitbelow
" set splitright

"-----------------------------------------------------------------------------  
" keymaps -   
"-----------------------------------------------------------------------------  
" smart coding map
" noremap <leader>bb <esc>F(a
inoremap <a-h> <esc>:call BackBra()<CR>a
inoremap <a-l> <esc>:call EndBra()<CR>a
" inoremap <a-l> <ESC>f)a
inoremap <a-e> <ESC>
function BackBra()

    let cursor_pos = getpos('.')
    let cur_pos = cursor_pos[2]-1

    let start = 1
    let i = 0
    let mylist = []

    while start < cur_pos && i != -1
        let i = match(getline("."), "[([{<'\"]", start)
        if i != -1 && i < cur_pos
            let mylist += [i]
        endif
        let start = i+1
    endw

    " let mylist = []
    " let i = stridx(getline("."),'(')
    " let j = stridx(getline("."),'[')
    " let k = stridx(getline("."),'{')
    " let l = stridx(getline("."),'"')
    " let m = stridx(getline("."),"'")
    " let n = stridx(getline("."),'<')
    " if i != -1 && i < cur_pos
    " let mylist += [i]
    " endif
    " if j != -1 && j < cur_pos
    " let mylist += [j]
    " endif
    " if k != -1 && k < cur_pos
    " let mylist += [k]
    " endif
    " if l != -1 && l < cur_pos
    " let mylist += [l]
    " endif
    " if m != -1 && m < cur_pos
    " let mylist += [m]
    " endif
    " if n != -1 && n < cur_pos
    " let mylist += [n]
    " endif
    let c = max(mylist)
    " echo c
    if c != 0
        let d = c+1
        call cursor('.', d)
    endif

endfunction

function EndBra()
    let cursor_pos = getpos('.')
    let cur_pos = cursor_pos[2]-1

    let start = cur_pos 
    let end = strlen(getline("."))
    let i = cur_pos
    let mylist = []

    while start < end && i != -1
        let i = match(getline("."), "[])}>'\"]", start)  
        if i != -1 && i > cur_pos
            let mylist += [i]
        endif
        let start = i+1
    endw

    " let mylist = []
    " let i = strridx(getline("."),')')
    " let j = strridx(getline("."),']')
    " let k = strridx(getline("."),'}')
    " let l = strridx(getline("."),'"')
    " " let m = match(getline("."),''')
    " let m = strridx(getline("."),"'")
    " let n = strridx(getline("."),'>')

    " if i != -1 && i > cur_pos
    " let mylist += [i]
    " endif
    " if j != -1 && j > cur_pos
    " let mylist += [j]
    " endif
    " if k != -1 && k > cur_pos
    " let mylist += [k]
    " endif
    " if l != -1 && l > cur_pos
    " let mylist += [l]
    " endif
    " if m != -1 && m > cur_pos
    " let mylist += [m]
    " endif
    " if n != -1 && n > cur_pos
    " let mylist += [n]
    " endif
    let c = min(mylist)
    " echo c
    if c != 0
        let d = c + 1
        call cursor('.', d)
    endif

endfunction

" noremap <A-w> :w<CR>
" inoremap <A-w> <ESC>:w<CR>
noremap <A-w> :w!<CR>
inoremap <A-w> <ESC>:w!<CR>
" nnoremap <leader>cd :cd %:p:h<cr><cr>
" 切换到当前文件目录
nnoremap <S-space> :cd %:p:h<cr>  
" noremap  ' <c-w>
" noremap :q <cr>:q!<cr>
vnoremap g) <esc>`>a)<esc>`<i(<esc>
vnoremap g] <esc>`>a]<esc>`<i[<esc>
vnoremap g} <esc>`>a}<esc>`<i{<esc>
vnoremap g" <esc>`>a"<esc>`<i"<esc>
vnoremap g' <esc>`>a'<esc>`<i'<esc>

noremap <leader>sp  "+p
noremap <leader>sy  "+y

noremap <leader>pa  "ap
noremap <leader>ya  "ay
noremap <leader>pb  "bp
noremap <leader>yb  "by
noremap <leader>pc  "cp
noremap <leader>yc  "cy
noremap <leader>pd  "dp
noremap <leader>yd  "dy
noremap <leader>pe  "ep
noremap <leader>ye  "ey
noremap <leader>pf  "fp
noremap <leader>yf  "fy
noremap <leader>pg  "gp
noremap <leader>yg  "gy




" 在,gg里搜索结果里继续搜索时用,* 不要用,*
vnoremap <Leader># "9y?<C-R>='\V'.substitute(escape(@9,'\?'),'\n','\\n','g')<CR><CR>
vnoremap <Leader>* "9y/<C-R>='\V'.substitute(escape(@9,'\/'),'\n','\\n','g')<CR><CR>
" vnoremap <Leader># "9y?<C-R>=substitute(escape(@9,'\?'),'\n','\\n','g')<CR><CR>
" vnoremap <Leader>* "9y/<C-R>=substitute(escape(@9,'\/'),'\n','\\n','g')<CR><CR>

nnoremap <silent><leader>hl :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

function! PreviewDown()
    if !&previewwindow
        silent! wincmd P
    endif
    if &previewwindow
        silent! wincmd J
        silent! wincmd p
    endif
endf
" au BufWinEnter * call PreviewDown() 

command Astyle silent exec '%!astyle --style=kr'
" nnoremap <leader>as :Astyle<cr>  
" nnoremap <a-a> :Astyle<cr>  

set nomore 

" 函数定义 ，] 返回历史列表用,tt   直接返回用bs
" marker用,ms

" set shortmess+=A
" let g:indentLine_color_term = 239,
" let g:indentLine_color_gui = '#A4E57E' 
" let g:indentLine_char = '┆'
" let g:indentLine_char = '|'  

" nn <leader>t1 1gt
" nn <leader>t2 2gt
" nn <leader>t3 3gt
" nn <leader>t4 4gt
" nn <leader>t5 5gt
" nn <leader>t6 6gt
" nn <leader>t7 7gt
" nn <leader>t8 8gt
" nn <leader>t9 9gt
" nn <leader>t0 :tablast<CR>

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! SuperESC()
    wincmd j
    exec "normal \<ESC>"
    silent exec "cclose"
    silent exec "lclose"
    silent exec "pclose"
    silent exec "UniteClose"
endfunction

noremap <S-ESC> :call SuperESC()<CR>
imap <S-ESC> <ESC>:call SuperESC()<CR>

function! Pathogensplit(path) abort " {{{1
  if type(a:path) == type([]) | return a:path | endif
  let split = split(a:path,'\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val,''\\\([\\,]\)'',''\1'',"g")')
endfunction " }}}1
function! Pathogenseparator() abort " {{{1
  return !exists("+shellslash") || &shellslash ? '/' : '\'
endfunction " }}}1
function! Pathogenhelptags() abort " {{{1
  let sep = Pathogenseparator()
  for glob in Pathogensplit(&rtp)
    for dir in split(glob(glob), "\n")
      if (dir.sep)[0 : strlen($VIMRUNTIME)] !=# $VIMRUNTIME.sep && filewritable(dir.sep.'doc') == 2 && !empty(filter(split(glob(dir.sep.'doc'.sep.'*'),"\n>"),'!isdirectory(v:val)')) && (!filereadable(dir.sep.'doc'.sep.'tags') || filewritable(dir.sep.'doc'.sep.'tags'))
        silent! execute 'helptags' pathogen#fnameescape(dir.'/doc')
      endif
    endfor
  endfor
endfunction " }}}1

command! -bar Helptags :call Pathogenhelptags()

set nrformats=alpha,octal,hex
" vim:ts=4:sw=4:sts=4 et fdm=marker:
