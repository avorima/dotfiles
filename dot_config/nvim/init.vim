" Plugins {{{1
call plug#begin('~/.config/nvim/bundle')

Plug 'towolf/vim-helm'
Plug 'hashivim/vim-terraform'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'

Plug 'editorconfig/editorconfig-vim'
Plug 'lambdalisue/suda.vim'
Plug 'junegunn/vim-easy-align'
Plug 'jremmen/vim-ripgrep'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'avorima/nvim-lightline-lsp', { 'branch': 'fix-diagnostics' }

call plug#end()
" 1}}}

set expandtab
set softtabstop=4
set shiftwidth=4

set ignorecase
set smartcase

set splitright
set splitbelow

set updatetime=250
set wildignore=*~,*.a,*.o,*.so,*.pyc,
      \*.jpg,*.jpeg,*.png,*.gif,*.pdf,*.git,
      \*.swp,*.swo
set wildmode=list,list:longest,full
set completeopt=menuone,noselect
set mouse=a

" give files without filetype suffixes lower priority
set suffixes+=,,

set dictionary=/usr/share/dict/words

" enable undo persistence
set undofile

" don't continue comment when hitting 'o'/'O' in normal mode
set formatoptions-=r
set formatoptions-=o

set lcs=tab:»·,trail:␣,nbsp:˷
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$', -10)

set nohlsearch
set number
set relativenumber

if has('termguicolors')
  set termguicolors
endif
set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

let mapleader = ','

" Mappings {{{1

" paste things continuously
xnoremap p "_dP

" replace inside visual selection boundaries
xnoremap <leader>s :s/\%V

" yank to system clipboard
vnoremap <leader>y "+y

" don't leave visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" toggle folds
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>

" close all folds
nnoremap <F3> :set foldlevel=0<CR>

" don't short jumps in jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}zz"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{zz"<CR>

" make 'n' and 'N' behave the same way
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" substitute word under cursor on line/globally
nnoremap <leader>s :s/\C\<<C-r><C-w>\>//g<left><left>
nnoremap <leader>S :%s/\C\<<C-r><C-w>\>//g<left><left>

nnoremap <silent> <F2> :call TogglePaste()<CR>

" don't accidentally go into ex-mode
nnoremap Q <nop>
nnoremap q: <nop>

" 1}}}

" Functions {{{1

function! TogglePaste()
  if &paste == 1
    set nopaste
    set number
    set relativenumber
    if &ft == "go"
      set list
    endif
  else
    set paste
    set nonumber
    set norelativenumber
    if &ft == "go"
      set nolist
    endif
  endif
  execute "Gitsigns toggle_signs"
endfunction

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

function! GoRunTests(...)
  let l:path = '.' . substitute(expand('%:p:h'), getcwd(), '', '')
  let l:cmd = "go test -cover"
  if !empty(a:000)
    let cmd = l:cmd . " " . join(a:000, " ")
  endif
  let cmd = l:cmd . " " . l:path
  echom "Running: " . l:cmd
  exe "new | term " . l:cmd
endfunction
" 1}}}

" Autocommands {{{1
augroup ToggleCursorLine
  autocmd!
  autocmd insertleave,winenter * set cursorline
  autocmd insertenter,winleave * set nocursorline
augroup END

augroup ReloadConfig
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
        exit
    endif
endfunction

function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        if confirm("parent directory '" . required_dir . "' does not exist.", "&Create it\nor &Quit?") == 2
            exit
        endif
        call mkdir(required_dir, 'p')
    endif
endfunction

augroup GlobalConfigs
  autocmd!
  " return to last edit position when opening files
  autocmd bufreadpost * if line ("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  " create intermediate directories (if necessary)
  autocmd bufnewfile * :call EnsureDirExists()
augroup END

augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter *     set list
    autocmd BufEnter *.txt set nolist
    autocmd BufEnter *     if !&modifiable | set nolist | endif
augroup END

augroup Security
  autocmd!
  " passwords/logins
  autocmd BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead ~/.netrc setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead ~/.docker/config.json setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead .envrc setlocal noswapfile nobackup noundofile
  " kubeconfigs
  autocmd BufNewFile,BufRead *kubeconfig.yaml setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead kubeconfig setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead ~/.kube/* setlocal noswapfile nobackup noundofile
  " keys and certs
  autocmd BufNewFile,BufRead ~/.ssh/* setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.key setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.pem setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.crt setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead id_* setlocal noswapfile nobackup noundofile
augroup END
" 1}}}

" Plugins {{{1

let g:rg_command = 'rg --vimgrep --hidden'
let g:rg_derive_root = 1

" overwrite ale defaults to prevent conflicts with lsp
let g:ale_linters = {
      \ 'apkbuild': [],
      \ 'csh': [],
      \ 'elixir': [],
      \ 'go': [],
      \ 'hack': [],
      \ 'help': [],
      \ 'inko': [],
      \ 'perl': [],
      \ 'perl6': [],
      \ 'python': [],
      \ 'rust': [],
      \ 'spec': [],
      \ 'svelte': [],
      \ 'text': [],
      \ 'vue': [],
      \ 'v': [],
      \ }

let g:ale_fixers = {
      \ 'json': ['jq'],
      \ }

let g:ale_disable_lsp = 1
let g:ale_virtualtext_cursor = 1

" vim-easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:easy_align_ignore_groups = ['Comment', 'String']
" 2}}}

" lightline.vim {{{2

let g:lightline#lsp#indicator_hints = "\uf110 "
let g:lightline#lsp#indicator_info = "\uf129 "
let g:lightline#lsp#indicator_warnings = "\uf071 "
let g:lightline#lsp#indicator_errors = "\uf05e "
let g:lightline#lsp#indicator_ok = "\uf00c "

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

let g:lightline.component_function = {
    \ 'gitbranch': 'fugitive#head',
    \ }

let g:lightline.active = {
    \ 'left': [
        \ [ 'mode', 'paste' ],
        \ [ 'gitbranch', 'readonly', 'filename', 'modified' ],
        \ ],
    \ 'right': [
        \ [ 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],
        \ [ 'lineinfo' ],
        \ [ 'percent' ],
        \ [ 'spell', 'fileformat', 'fileencoding', 'filetype'],
        \ ],
    \ }

call lightline#lsp#register()

let g:lightline.separator = {'left': "\ue0b0", 'right': "\ue0b2"}
let g:lightline.subseparator = {'left': "\ue0b1", 'right': "\ue0b3"}

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
      \ '?'      : ' ? '
      \ }

" Redraw the status each second
call timer_start(1000, {->execute('call lightline#update()')}, #{repeat: -1})

" 2}}}

" 1}}}

" vim: sw=2 sts=2 ts=4 foldmethod=marker
