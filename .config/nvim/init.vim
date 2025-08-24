" Plugins {{{1
call plug#begin('~/.config/nvim/bundle')

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'

Plug 'towolf/vim-helm'
" Plug 'segeljakt/vim-silicon'
" Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
" Plug 'editorconfig/editorconfig-vim'

Plug 'lambdalisue/suda.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'debugloop/telescope-undo.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'lewis6991/gitsigns.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'

Plug 'savq/melange'

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
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
set mouse=a

" give files without filetype suffixes lower priority
set suffixes+=,,

set dictionary=/usr/share/dict/words

" enable undo persistence
set undofile

" don't continue comments
set formatoptions-=r
set formatoptions-=o

set lcs=tab:»·,trail:␣,nbsp:˷
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$', -10)

set nohlsearch
set number
set relativenumber

set termguicolors
colorscheme melange

nnoremap <space> <nop>
let mapleader = "\<Space>"

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

" don't keep short jumps in jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}zz"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{zz"<CR>

" make 'n' and 'N' behave the same way
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" substitute word under cursor on line/globally
nnoremap <leader>s :s/\C\<<C-r><C-w>\>//g<left><left>
nnoremap <leader>S :%s/\C\<<C-r><C-w>\>//g<left><left>

nnoremap <silent> <F2> :call TogglePaste()<CR>

" 1}}}

" Functions {{{1

function StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

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

function! s:goup(path) abort
  let l:path = a:path
  while 1
    let l:current = l:path . '/go.mod'
    if filereadable(l:current)
      let l:git_dir = l:path . '/.git/'
      if isdirectory(l:git_dir)
        " If the go.mod is at the same level as the .git directory we don't
        " need to change directories
        return ''
      endif
      return l:path
    endif
    let l:next = fnamemodify(l:path, ':h')
    if l:next ==# l:path
      break
    endif
    let l:path = l:next
  endwhile
  return ''
endfunction

function! GoRunTests(...)
  let l:pkgroot = s:goup(expand('%:p:h'))
  if !empty(l:pkgroot)
    exe 'lcd' l:pkgroot
  endif
  let l:path = '.' . substitute(expand('%:p:h'), getcwd(), '', '')
  if !empty(l:pkgroot)
    exe 'lcd' '-'
  endif

  let l:cmd = "go test -cover -timeout=60s"
  if !empty(l:pkgroot)
    let cmd = "cd " . l:pkgroot . " && " . l:cmd
  endif
  if !empty(a:000)
    let cmd = l:cmd . " " . join(a:000, " ")
  endif
  let cmd = l:cmd . " " . l:path
  echom "Running: " . l:cmd
  exe "new | term " . l:cmd
endfunction

function! GoRunTestUnderCursor()
  let wordUnderCursor = expand("<cword>")
  call GoRunTests("-run=" . wordUnderCursor)
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
  " kubeconfigs and kubectl tempfiles
  autocmd BufNewFile,BufRead *kubeconfig.yaml setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead kubeconfig setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead ~/.kube/* setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead /tmp/kubectl-edit*.yaml setlocal noswapfile nobackup noundofile
  " keys and certs
  autocmd BufNewFile,BufRead ~/.ssh/* setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.key setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.pem setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *.crt setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead id_* setlocal noswapfile nobackup noundofile
  autocmd BufNewFile,BufRead *values-secrets.yaml setlocal noswapfile nobackup noundofile
augroup END

augroup Filetypes
  autocmd!
  autocmd BufNewFile,BufRead .envrc setfiletype sh
  autocmd BufNewFile,BufRead /etc/pacman.conf setlocal commentstring=#\ %s
  autocmd filetype yaml nnoremap <buffer> <silent> <BS><BS> :call StripTrailingWhitespace()<CR>
augroup END

augroup FileTemplates
  autocmd!
  autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh
augroup END

" 1}}}

" Plugins {{{1

highlight! default link TreesitterContextLineNumber CursorLineNr

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:easy_align_ignore_groups = ['Comment', 'String']

" 1}}}

" vim: sw=2 sts=2 ts=4 foldmethod=marker
