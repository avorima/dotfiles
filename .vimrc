" Plugins {{{
call plug#begin('~/.vim/bundle')

" Plug 'sheerun/vim-polyglot'
Plug 'pearofducks/ansible-vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'vim-jp/vim-cpp', { 'for': ['c', 'cpp'] }
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-git'
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'b4b4r07/vim-hcl'
Plug 'towolf/vim-helm'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'lervag/vimtex'
Plug 'plasticboy/vim-markdown'
Plug 'vim-perl/vim-perl'
Plug 'voxpupuli/vim-puppet'
" Plug 'aliev/vim-compiler-python'
Plug 'Vimjas/vim-python-pep8-indent', { 'for': ['python'] }
Plug 'vim-python/python-syntax', { 'for': ['python'] }
Plug 'wgwoods/vim-systemd-syntax'
Plug 'hashivim/vim-terraform'
Plug 'ericpruitt/tmux.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

Plug '~/.fzf'
Plug 'jremmen/vim-ripgrep'
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kopischke/vim-stay'
Plug 'kopischke/vim-fetch'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'junegunn/limelight.vim', { 'for': 'markdown' }
Plug 'junegunn/seoul256.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'szw/vim-tags', { 'for': ['c', 'cpp', 'python', 'ruby'] }
Plug 'SirVer/ultisnips', { 'for': ['c','cpp','python','ruby','perl','go','tex'] }
Plug 'honza/vim-snippets', { 'for': ['c','cpp','python','ruby','perl','go','tex'] }
Plug 'kana/vim-textobj-user'

call plug#end()
" Plugin End }}}

" Settings {{{
set pastetoggle=<F2>

if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

set history=1000

set hidden
set backup
set backupskip="/tmp/*,.git"
set backupdir=~/.vim/backup
set directory=~/.vim/swap

if has('persistent_undo') && exists('&undodir')
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
endif

set ignorecase
set smartcase
set nohlsearch

set nrformats+=alpha
set nrformats-=octal
set nrformats-=bin

set formatoptions-=c
set formatoptions-=r
set formatoptions-=o

set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4

set scrolloff=1
set magic
set mouse=
set shortmess=atToOI
set viewoptions=cursor,folds,slash,unix
set ttyfast
set splitbelow
set splitright
set nowrap
set showmatch
set matchtime=2
set modeline

set path+=**

set tags=./tags;~

" give files without filetype suffixes lower priority
set suffixes+=,,

set grepprg=ack

let mapleader=','
" }}}

" User interface {{{
if has('termguicolors')
  set termguicolors
  let g:seoul256_srgb = 1
  let g:seoul256_background = 236
else
  let g:seoul256_background = 235
endif

colo seoul256

" mode cursors
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

set lcs=tab:»·,trail:␣,nbsp:˷
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$', -10)

set more
set textwidth=79
set colorcolumn=80
set relativenumber
set number
set noshowmode
set showcmd
set wildignore=*~,*.a,*.o,*.so,*.pyc,
      \*.jpg,*.jpeg,*.png,*.gif,*.pdf,*.git,
      \*.swp,*.swo
set wildmode=list,list:longest,full

set t_vb=
set noerrorbells
set novisualbell
" }}}

" Mappings {{{
map Q <nop>

" write to readonly file
cnoremap w!! %!sudo tee > /dev/null %

" Hex mode mapping
cnoremap hex %!xxd

" Fuzzy searching
cnoremap <leader>e e **/**/
cnoremap <leader>vs vs **/**/
cnoremap <leader>new new **/**/

" copy the found line below cursor
cnoremap $t <CR>:t''<CR>
" move the found line below cursor
cnoremap $m <CR>:m''<CR>
" delete the found line
cnoremap $d <CR>:d<CR>``

" Reformat file
nmap <F7> mzgg=G`z

" toggle folds
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>

" close all folds
nnoremap <F3> :set foldlevel=0<CR>

if exists('$TMUX')
  " remap tmux navigator movements
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
  nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
  nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
  nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
  nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>
else
  nnoremap <silent> <C-h> <C-W>h
  nnoremap <silent> <C-j> <C-W>j
  nnoremap <silent> <C-k> <C-W>k
  nnoremap <silent> <C-l> <C-W>l
endif

" don't store {} in jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}zz"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{zz"<CR>

" restore previous selection
" nmap gv `[v`]

" open/close quickfix window
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

" yank, cut and paste with system register
nnoremap <leader>p :set paste<CR>"+p:set nopaste<CR>
nnoremap <leader>y "+y
nnoremap <leader>x "+x

" undo vim-surround VSurround command, i.e. ( a ) => (a)
nnoremap <leader>di( vi(<ESC>g`>xg`<x
nnoremap <leader>di{ vi{<ESC>g`>xg`<x
nnoremap <leader>di[ vi[<ESC>g`>xg`<x

" squash newlines under cursors
nnoremap <leader>dd cip<ESC>
" squash newlines in file
nnoremap <leader>%dd :g/^\_$\n\_^$/d<CR>

" add/remove newlines above and below current line
nnoremap <leader><space><space> mmO<ESC>jo<ESC>k`m
nnoremap <leader><space>d mm{dd}dd`m

" make n and N behave the same way for *,#,/,?
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" substitude word under cursor on line/globally
"nmap S   :%s//g<LEFT><LEFT>
"xmap S   :s//g<LEFT><LEFT>
nnoremap <leader>s :s/\<<C-r><C-w>\>//g<left><left>
nnoremap <leader>S :%s/\<<C-r><C-w>\>//g<left><left>

" faster upper/lowercase
nnoremap <leader>uc gUiw
nnoremap <leader>lc guiw

" reverse word / line
nnoremap riw viwc<C-O>:set revins<CR><C-R>"<ESC>:set norevins<CR>
nnoremap ris ^v$hc<C-O>:set revins<CR><C-R>"<ESC>:set norevins<CR>

" add and remove folds
vnoremap <space> zf
vnoremap d<space> zE

" paste things continuously
xnoremap p "_dP

" replace inside visual selection boundaries
xmap <leader>s :s/\%V

" don't leave visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" delete block/function
nnoremap <silent> <leader>db ]}mb[{^d'b:delmarks b<CR>

nnoremap <leader>ifl ^mvw"byt;^%dd`vdd"bPa<space>&&<ESC>==

nmap <silent> <BS><BS> :call <SID>StripTrailingWhitespace()<CR>

nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Duplicate visual selection
xmap D y'>p

nnoremap <leader>sle :setlocal spelllang=en<CR>
nnoremap <leader>sld :setlocal spelllang=de<CR>
" }}}

" Functions {{{
" Lightline Helpers {{{
function! LightlineFugitive()
  try
    if exists('*fugitive#head')
      let l:mark = "\ue0a0"
      let l:_ = fugitive#head()
      return strlen(_) ? l:mark . l:_ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &ro ? "\ue0a2" : ''
endfunction

function! LightlineFileformat()
  return winwidth('.') > 90 ? (&ff . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightlineFileencoding()
  return winwidth('.') > 80 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightlineFiletype()
  return winwidth('.') > 70 ? (strlen(&ft) ? &ft . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! LightlineMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

" }}}

" Helper functions {{{
function! JoinWithLeader(count, leaderText)
  let l:linecount = a:count
  " default number of line to join is 2
  if l:linecount < 2
    let l:linecount = 2
  endif
  echo l:linecount . " lines joined"
  " clear errmsg so we can determine if the search fails
  let v:errmsg = ''

  " save off the search register to restore it later because we will clobber
  " it with a substitute command
  let l:savesearch = @/

  while l:linecount > 1
    " do a J for each line (no mappings)
    normal! J
    " remove the comment leader from the current cursor position
    silent! execute 'substitute/\%#\s*\%('.a:leaderText.'\)\s*/ /'
    " check v:errmsg for status of the substitute command
    if v:errmsg =~ 'Pattern not found'
      " just means the line wasn't a comment - do nothing
    elseif v:errmsg != ''
      echo "Problem with leader pattern for JoinWithLeader()!"
    else
      " a successful substitute will move the cursor to line beginning,
      " so move it back
      normal ! ``
    endif
    let l:linecount = l:linecount - 1
  endwhile
  " restore the @/ register
  let @/ = l:savesearch
endfunction

" eliminate comment leader when joining comment lines
function! MapJoinWithLeaders(leaderText)
  let l:leaderText = escape(a:leaderText, '/')
  " visual mode is easy - just remove comment leaders from beginning of lines
  " before using J normally
  exec "vnoremap <silent> <buffer> J :<C-U>let savesearch=@/<Bar>'<+1,'>".
        \'s/^\s*\%('.
        \l:leaderText.
        \'\)\s*/<space>/e<Bar>'.
        \'let @/=savesearch<Bar>unlet savesearch<CR>'.
        \'gvJ'
  " normal mode is harder because of the optional count - must use a function
  exec "nnoremap <silent> <buffer> J :<C-U>call JoinWithLeader(v:count, '".l:leaderText."')<CR>"
endfunction

function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
        exit
    endif
endfunction

function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
             \       "&Create it\nor &Quit?", 2)

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'",
            \            "&Quit\nor &Continue anyway?", 1)
        endtry
    endif
endfunction

function! <SID>StripTrailingWhitespace()
  if &modifiable
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
    set nohlsearch
  endif
endfunction
" }}}
" }}}

" Autocommands {{{
augroup ToggleCursorLine
  autocmd!
  autocmd insertleave,winenter * set cursorline
  autocmd insertenter,winleave * set nocursorline
augroup END

augroup StripTrailingWhitespace
  autocmd!
  autocmd bufleave * call <SID>StripTrailingWhitespace()
augroup END

augroup ReloadVimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

augroup GlobalConfigs
  autocmd!
  " return to last edit position when opening files
  autocmd bufreadpost * if line ("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  " create intermediate directories (if necessary)
  autocmd bufnewfile * :call EnsureDirExists()
augroup END

augroup FiletypeConfigs
  autocmd!
  autocmd bufnewfile,bufreadpre *.tt     setfiletype tt2
  autocmd bufnewfile,bufreadpre *.tt2    setfiletype tt2html
  autocmd bufnewfile,bufreadpre *.psgi   setfiletype perl
  autocmd bufnewfile,bufreadpre cpanfile setfiletype perl
  autocmd bufnewfile,bufreadpre *.t      setfiletype perl
  autocmd bufnewfile,bufreadpre *.conf   setfiletype cfg
  autocmd bufnewfile,bufreadpre *.yp     setfiletype yacc
  autocmd filetype gitcommit setlocal spell
  autocmd filetype markdown setlocal spell
augroup END

augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter *       set list
    autocmd BufEnter *.txt   set nolist
    autocmd BufEnter *       if !&modifiable | set nolist | endif
augroup END
" }}}

" Plugins {{{
" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:easy_align_ignore_groups = ['Comment', 'String']

" vim-gitgutter
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
nmap <leader>hv <Plug>GitGutterPreviewHunk

" nerdtree
nnoremap <leader>5 :NERDTreeToggle<CR>

" perl-tags-vim
let g:PT_use_ppi = 1

" ultisnips
let g:UltiSnipsExpandTrigger = "<leader><tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-n>"
let g:UltiSnipsJumpBackwardTrigger = "<C-p>"

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"
let g:go_fmt_command = "goimports"

" vim-textobj-user {{{

" al/il for line objects
call textobj#user#plugin('line', {
\   '-': {
\       'select-a-function': 'CurrentLineA',
\       'select-a': 'al',
\       'select-i-function': 'CurrentLineI',
\       'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return non_blank_char_exists_p ? ['v', head_pos, tail_pos] : 0
endfunction
" }}}

" vim-tags {{{
let g:vim_tags_auto_generate = 1
let g:vim_tags_ctags_binary = '/usr/bin/ctags'
let g:vim_tags_use_vim_dispatch = 1
let g:vim_tags_use_language_field = 1
let g:vim_tags_cache_dir = expand($HOME . '/.vim/cache')
" }}}

" lightline.vim {{{
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \     'left': [
      \         [ 'mode', 'paste' ],
      \         [ 'readonly', 'fugitive' ],
      \         [ 'filename' ],
      \     ],
      \     'right': [
      \         [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \         [ 'lineinfo' ],
      \         [ 'percent' ],
      \         [ 'fileformat', 'fileencoding', 'filetype' ],
      \     ]
      \ },
      \ 'component': {
      \     'paste': '%{&paste ? "!" : ""}'
      \ },
      \ 'component_function': {
      \     'fugitive'     : 'LightlineFugitive',
      \     'readonly'     : 'LightlineReadonly',
      \     'bufferline'   : 'LightlineBufferline',
      \     'fileformat'   : 'LightlineFileformat',
      \     'fileencoding' : 'LightlineFileencoding',
      \     'filetype'     : 'LightlineFiletype',
      \ },
      \ 'component_expand': {
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \     'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'lightline_checking': 'left',
      \     'lightline_warnings': 'warning',
      \     'lightline_errors': 'error',
      \     'lightline_ok': 'left',
      \ },
      \ 'separator': {
      \     'left': "\ue0b0", 'right': "\ue0b2"
      \ },
      \ 'subseparator': {
      \     'left': "\ue0b1", 'right': "\ue0b3"
      \ }
      \ }

let g:lightline.mode_map = {
      \ 'n'      : ' N ',
      \ 'i'      : ' I ',
      \ 'R'      : ' R ',
      \ 'v'      : ' V ',
      \ 'V'      : 'V-L',
      \ 'c'      : ' C ',
      \ "\<C-v>" : 'V-B',
      \ 's'      : ' S ',
      \ 'S'      : 'S-L',
      \ "\<C-s>" : 'S-B',
      \ '?'      : '       '
      \ }
" }}}

" goyo.vim {{{
function! s:goyo_enter()
  " ensure :q quits
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd quitpre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  " hide tmux
  if exists('$TMUX')
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif

  set noshowcmd
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  " show tmux
  if exists('$TMUX')
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif

  set showcmd
  set scrolloff=5
  Limelight!

  " quit vim if this is the only remaining bufferj
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! user GoyoEnter nested call <SID>goyo_enter()
autocmd! user GoyoLeave nested call <SID>goyo_leave()
" }}}

" tmuxline.vim {{{
let g:tmuxline_preset = {
        \'a'    : '#S',
        \'c'    : ['#(whoami)', '#(uptime | cut -d " " -f 3,4,5 | sed "s/[, ]*$//g")'],
        \'win'  : ['#I', '#W'],
        \'cwin' : ['#I', '#W', '#F'],
        \'y'    : ['%R', '%a', '%Y-%m-%d'],
        \'z'    : '#H' }
" }}}
" }}}

" vim: sw=2 tw=99 cc=100 foldmethod=marker:
