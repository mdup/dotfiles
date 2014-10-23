scriptencoding utf-8
" ^^ Please leave the above line at the start of the file.

" Default configuration file for Vim
" $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/files/vimrc-r4,v 1.3 2010/04/15 19:30:32 darkside Exp $

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
    set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
    set fileencodings=euc-kr
    set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
    set fileencodings=euc-jp
    set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
    set fileencodings=big5
    set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
    set fileencodings=gb2312
    set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
    set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
    " If we have to add this, the default encoding is not Unicode.
    " We use this fact later to revert to the default encoding in plaintext/empty
    " files.
    let g:added_fenc_utf8 = 1
    set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
    set fileencodings+=default
endif
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
    set t_Sb=^[4%dm
    set t_Sf=^[3%dm
    set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
    " Set useful keys that vim doesn't discover via termcap but are in the
    " builtin xterm termcap. See bug #122562. We use exec to avoid having to
    " include raw escapes in the file.
    exec "set <C-Left>=\eO5D"
    exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
    filetype plugin on

    " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
    " indent settings. Some people don't like these, so we won't turn them on by
    " default.
    " filetype indent on
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
    if executable("/bin/bash")
        set shell=/bin/bash
    elseif executable("/bin/sh")
        set shell=/bin/sh
    endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
    let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

    augroup gentoo
        au!

        " Gentoo-specific settings for ebuilds.  These are the federally-mandated
        " required tab settings.  See the following for more information:
        " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
        " Note that the rules below are very minimal and don't cover everything.
        " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
        " filetype and indent settings for all things Gentoo.
        au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
        au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

        " In text files, limit the width of text to 78 characters, but be careful
        " that we don't override the user's setting.
        autocmd BufNewFile,BufRead *.txt
                    \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
                    \     setlocal textwidth=78 |
                    \ endif

        " When editing a file, always jump to the last cursor position
        autocmd BufReadPost *
                    \ if ! exists("g:leave_my_cursor_position_alone") |
                    \     if line("'\"") > 0 && line ("'\"") <= line("$") |
                    \         exe "normal g'\"" |
                    \     endif |
                    \ endif

        " When editing a crontab file, set backupcopy to yes rather than auto. See
        " :help crontab and bug #53437.
        autocmd FileType crontab set backupcopy=yes

        " If we previously detected that the default encoding is not UTF-8
        " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
        " characters at all) isn't a Unicode file, but is in the default encoding.
        " Except of course if a byte-order mark is in effect.
        autocmd BufReadPost *
                    \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" &&
                    \    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
                    \       set fileencoding= |
                    \ endif

    augroup END

endif " has("autocmd")
" }}}

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :

set expandtab
"set shiftwidth=2
"set tabstop=2
set shiftwidth=4
set tabstop=4
nmap <C-S-K> <C-]>
set textwidth=80

set enc=utf8

nmap <C-@> <C-x><C-o>
imap <C-@> <C-x><C-o>

map <C-right> :tabn<CR>
map <C-left> :tabp<CR>

" colorscheme zellner

" ctags & taglist-plugin
let Tlist_Ctags_Cmd="/opt/local/bin/ctags"
nnoremap <silent> <F8> :TlistToggle<CR>
"let Tlist_Auto_Open=1
let updatetime=1

nnoremap <C-Left> <C-w><Left>
nnoremap <C-Right> <C-w><Right>
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>

nnoremap <C-h> <C-w><Left>
nnoremap <C-l> <C-w><Right>
nnoremap <C-k> <C-w><Up>
nnoremap <C-j> <C-w><Down>

nnoremap <C-S-Left> <C-w>H
nnoremap <C-S-Right> <C-w>L
nnoremap <C-S-Up> <C-w>K
nnoremap <C-S-Down> <C-w>J

nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up> <C-w>+
nnoremap <S-Down> <C-w>-

imap jk <Esc>


" snipMate
filetype plugin on

"snipMate and Autocompl
"let g:acp_behaviorSnipmateLength=1

" highlighting colors
hi Pmenu    ctermfg=0 ctermbg=4
hi PmenuSel cterm=bold ctermfg=7 ctermbg=1
"au BufWritePost *.c,*.cpp,*.h silent! !/opt/local/bin/ctags -R & "TO BE reenabled when exuberant ctags is reinstalled
autocmd BufNewFile,BufRead *.json set ft=javascript "enable json hl

" sudo editing http://stackoverflow.com/a/726920/899752
cmap w!! w !sudo tee %

" cursor colors
highlight Cursor guifg=yellow guibg=magenta
highlight iCursor guifg=yellow guibg=purple
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon200
set guicursor+=i:blinkon100

set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L


" set Leader key. Forgot how to use it? http://usevim.com/2012/07/20/vim101-leader/
let mapleader=","



"
" Those were added when I installed Vundle.
"

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
" Git management
Plugin 'tpope/vim-fugitive'
" L9 library for other plugins
Plugin 'L9'
" Command-T
Plugin 'git://git.wincent.com/command-t.git'
" Alternative to Command-T: Ctrl-P
"Plugin 'ctrlp'
" NERDCommenter
Plugin 'scrooloose/nerdcommenter'
" Fuzzy completion
"Bundle 'Valloric/YouCompleteMe'
" Color schemes
Plugin 'flazz/vim-colorschemes'
" Syntastic
Plugin 'scrooloose/syntastic'
" CMake
"Bundle 'jalcine/cmake.vim'
" C++11 Syntax highlighter
Bundle 'octol/vim-cpp-enhanced-highlight'
" Show marks
Plugin 'kshenoy/vim-signature'
" Parentheses, braces, brackets editing
Plugin 'surround.vim'
" Rename current buffer.
Plugin 'Rename.vim'
" Rust syntax files
Plugin 'wting/rust.vim'
" TOML syntax files
Bundle 'cespare/vim-toml'
" NERDTree
Bundle 'scrooloose/nerdtree'
" NERDTree-tabs
Bundle 'jistr/vim-nerdtree-tabs'
" EasyMotion, move quick to char
Bundle 'Lokaltog/vim-easymotion'
" MiniBufferExplorer, buffer list on the top
"Plugin 'fholgado/minibufexpl.vim'
" Minimap?
Plugin 'severin-lemaignan/vim-minimap'
" Rainbow parentheses
Plugin 'kien/rainbow_parentheses.vim'
call vundle#end()
filetype plugin indent on

" Color scheme indication must come after plugin information.
" And cursor color must come after color scheme.
"colors solarized
"colors wombat
if has("gui_running")
    highlight Cursor guifg=yellow guibg=magenta    highlight iCurs
    or guifg=yellow guibg=purple
    command! ResetCursorColor execute "highlight Cursor guifg=yellow guibg=magenta | highlight iCursor guifg=yellow guibg=purple"
    " GUI Theme here:
    colors solarized
    set bg=dark
else
    " 256 colors: use if you're not running native solarized in the terminal,
    " but still want to emulate the color scheme without modifying the term
    " settings.
    "set t_Co=256
    "let g:solarized_termcolors=256
    " Terminal (non-gui) Theme here:
    colors solarized
    set bg=dark
    "colors wombat
endif

" YouCompleteMe
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
" TAB makes the popup appear.
imap <C-Space> <C-N>

"set complete=.,b,u,]
"set wildmode=longest,list:longest
set completeopt=menu,preview
" turn on debug info
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_confirm_extra_conf = 0 " disable this annoying popup
nnoremap <silent> <Leader>e :YcmDiags<CR>

" Syntastic / C++
let g:syntastic_enable_highlighting=1
let g:syntastic_auto_loc_list=0
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1
"let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': [],
            \ 'passive_filetypes': ['puppet'] }
let g:syntastic_enable_rust_checker = -1

" Line numbers.
:set number " aka :set nu
":set nonumber or :set nonu to disable
":set relativenumber is cool
nnoremap <C-N> :set rnu!<CR>

" The backquote doesn't work very well. We change ' to ` because
" they do roughly the same thing, but ` is more precise in where the cursor
" jumps.
map ' `

" 80-character wide is the rule.
:set colorcolumn=81
highlight ColorColumn guibg=#393333

" Shortcut to :noh
nnoremap <silent> <Leader>n :noh<CR>
"
" Trailing whitespace are evil: highlight em. Make a command to remove them:
" ,t
" FIXME: this doesn't work on newly open file; .vimrc has to be resourced.
match ErrorMsg '\s\+$'
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
nnoremap <silent> <Leader>w :call TrimWhiteSpace()<CR>

" Map for changing between tabs.
nnoremap <M-Left> :tabprevious<CR>
nnoremap <M-Right> :tabnext<CR>

" Make 'star' only search for a word, not jump to the next occurrence.
"nnoremap * *N

" `gf` opens in the current buffer, so this one will open in a new vsplit:
:nnoremap <Leader>f :vertical wincmd f<CR>

" Enable man viewer. Use :Man <whatever>
runtime! ftplugin/man.vim

" NERDTree-tabs
" See meaning of bindings at https://github.com/jistr/vim-nerdtree-tabs
let g:nerdtree_tabs_open_on_console_startup=0
nnoremap <silent> <Leader>ss :NERDTreeFocusToggle<CR> " should be most used
nnoremap <silent> <Leader>so :NERDTreeTabsOpen<CR>
nnoremap <silent> <Leader>sc :NERDTreeTabsClose<CR>
nnoremap <silent> <Leader>st :NERDTreeTabsToggle<CR>
nnoremap <silent> <Leader>sf :NERDTreeTabsFind<CR>
"nnoremap <silent> <Leader>sO :NERDTreeMirrorOpen<CR>
nnoremap <silent> <Leader>sT :NERDTreeMirrorToggle<CR>
nnoremap <silent> <Leader>sO :NERDTreeSteppedOpen<CR>
nnoremap <silent> <Leader>sC :NERDTreeSteppedClose<CR>

" MiniBufferExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
map <Leader>me :MBEOpen<cr>
map <Leader>mc :MBEClose<cr>
map <Leader>mt :MBEToggle<cr>
map <Leader>mm :MBEFocus<cr>

" Command T
nnoremap <silent> <Leader>t :CommandT<CR>    " actually comes by default
nnoremap <silent> <leader>b :CommandTMRU<cr> " actually comes by default

" Rainbow parentheses
let g:rbpt_loadcmd_toggle = 1
