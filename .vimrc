" Plugins {{{
call plug#begin('~/.vim/bundle')

Plug 'pearofducks/ansible-vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'vim-jp/vim-cpp', { 'for': ['c', 'cpp'] }
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-git'
Plug 'b4b4r07/vim-hcl'
Plug 'towolf/vim-helm'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'lervag/vimtex'
Plug 'plasticboy/vim-markdown'
Plug 'vim-perl/vim-perl'
Plug 'voxpupuli/vim-puppet'
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
Plug 'dense-analysis/ale'
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

set updatetime=250

set path+=**

set dictionary+=/usr/share/dict/words

set tags=./tags;~

" give files without filetype suffixes lower priority
set suffixes+=,,

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
set textwidth=99
set colorcolumn=100
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
nnoremap <leader>s :s/\C\<<C-r><C-w>\>//g<left><left>
nnoremap <leader>S :%s/\C\<<C-r><C-w>\>//g<left><left>

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
nnoremap <silent> <leader>ifl ^mvw"byt;^%dd`vdd"bPa<space>&&<ESC>==

" strip trailing whitespace in file
nmap <silent> <BS><BS> :call <SID>StripTrailingWhitespace()<CR>

" Duplicate visual selection
xmap D y'>p

" set spelllang
nnoremap <leader>sle :setlocal spelllang=en<CR>
nnoremap <leader>sld :setlocal spelllang=de<CR>

function! <SID>ResizeVisualSelection(direction, side, count)
    let l:cmd = "normal! g"
    if a:direction == 1
        let l:move = "k"
    else
        let l:move = "j"
    endif

    if a:count > 1
        let l:move = a:count . l:move
    endif

    if a:side == 1
        let l:start = "`<"
        let l:end = "V`>"
    else
        let l:start = "`>"
        let l:end = "V`<"
    endif

    execute l:cmd.l:start.l:move.l:end
endfunction

" Extend or reduce visual selection up or down (works with count)
vnoremap <silent> <leader>k :<C-U>call <SID>ResizeVisualSelection(1, 1, v:count)<CR>
vnoremap <silent> <leader>j :<C-U>call <SID>ResizeVisualSelection(0, 0, v:count)<CR>
vnoremap <silent> <leader>K :<C-U>call <SID>ResizeVisualSelection(0, 1, v:count)<CR>
vnoremap <silent> <leader>J :<C-U>call <SID>ResizeVisualSelection(1, 0, v:count)<CR>
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
" }}}

" Golang {{{

" Source: https://github.com/fatih/vim-go/blob/master/autoload/go/alternate.vim
function! GoAlternateSwitch(bang, cmd) abort
  let file = expand('%')
  if empty(file)
    echoe "no buffer name"
    return
  elseif file =~# '^\f\+_test\.go$'
    let l:root = split(file, '_test.go$')[0]
    let l:alt_file = l:root . ".go"
  elseif file =~# '^\f\+\.go$'
    let l:root = split(file, '.go$')[0]
    let l:alt_file = l:root . "_test.go"
  else
    echoe "not a go file"
    return
  endif
  if !filereadable(alt_file) && !bufexists(alt_file) && !a:bang
    echoe "couldn't find file " . alt_file
    return
  elseif empty(a:cmd)
    execute ":" . "edit" . " " . alt_file
  else
    execute ":" . a:cmd . " " . alt_file
  endif
endfunction

nnoremap <leader>gao :call GoAlternateSwitch(1, "edit")<CR>
nnoremap <leader>gas :call GoAlternateSwitch(1, "split")<CR>
nnoremap <leader>gav :call GoAlternateSwitch(1, "vsplit")<CR>

" Source: https://github.com/fatih/vim-go/blob/master/autoload/go/test.vim
function! GoTestFunc(bang, ...) abort
  " search flags legend (used only)
  " 'b' search backwards instead of forward
  " 'c' accept a match at the cursor position
  " 'n' do Not move the cursor
  " 'W' don't wrap around the end of the file
  "
  " for the full list
  " :help search
  let test = search('func \(Test\|Example\)', 'bcnW')

  if test == 0
    echo "no test found immediate to cursor"
    return
  endif

  let line = getline(test)
  let name = split(split(line, " ")[1], "(")[0]
  let args = [a:bang, 0, "-run", name . "$"]

  if a:0
    call extend(args, a:000)
  else
    " only add this if no custom flags are passed
    call add(args, "-timeout=10s")
  endif

  call call("GoTestRun", args)
endfunction

function! GoTestRun(bang, compile, ...) abort
    let args = ["test"]

    " don't run the test, only compile it. Useful to capture and fix errors
    if a:compile
      let testfile = tempname() . ".test"
      call extend(args, ["-c", "-o", testfile])
    endif

    if a:0
      let goargs = a:000

      " do not expand for coverage mode as we're passing the arg ourself
      if a:1 != '-coverprofile'
        " expand all wildcards(i.e. '%' to the current file name)
        let goargs = map(copy(a:000), "expand(v:val)")
      endif

      call extend(args, goargs, 1)
    else
      " only add this if no custom flags are passed
      call add(args, "-timeout=10s")
    endif

    execute ":term go " . join(args, " ") . " ./..."
endfunction

nnoremap <leader>ta :call GoTestRun(0, 0, "-v")<CR>
nnoremap <leader>tt :call GoTestRun(0, 0)<CR>
nnoremap <leader>tf :call GoTestFunc(0, "-v")<CR>
" }}}
" }}}

" Autocommands {{{
augroup ToggleCursorLine
  autocmd!
  autocmd insertleave,winenter * set cursorline
  autocmd insertenter,winleave * set nocursorline
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
  autocmd filetype resolv setlocal commentstring=#\ %s
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

let g:python_highlight_all = 1

" ultisnips
let g:UltiSnipsExpandTrigger = "<leader><tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-n>"
let g:UltiSnipsJumpBackwardTrigger = "<C-p>"

" ale {{{

let g:ale_linters = {
      \ 'go': ['gopls'],
      \ 'tex': ['chktex'],
      \ 'plaintex': ['chktex'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'go': ['goimports'],
      \}

let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_completion_enabled = 1
let g:ale_completion_delay = 250
let g:ale_completion_max_suggestions = 20

let g:ale_set_balloons_legacy_echo = 1

set omnifunc=ale#completion#OmniFunc
set completeopt=menu,menuone,preview,noselect,noinsert

nnoremap <BS><BS> :ALEFix<CR>

nnoremap K :ALEHover<CR>

nnoremap <leader>gf :ALEFindReferences<CR>
nnoremap <leader>gs :ALESymbolSearch<CR>

nnoremap <leader>do :ALEGoToDefinition<CR>
nnoremap <leader>ds :ALEGoToDefinitionInSplit<CR>
nnoremap <leader>dv :ALEGoToDefinitionInVSplit<CR>

nnoremap <leader>to :ALEGoToTypeDefinition<CR>
nnoremap <leader>ts :ALEGoToTypeDefinitionInSplit<CR>
nnoremap <leader>tv :ALEGoToTypeDefinitionInVSplit<CR>
" }}}

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
