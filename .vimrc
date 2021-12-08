set nocompatible

set expandtab
set softtabstop=4
set shiftwidth=4

set inccommand=nosplit
set nohlsearch
set hidden
set ignorecase
set smartcase
set updatetime=100

set path+=**
set suffixes+=,,

set dictionary+=/usr/share/dict/words

set viewoptions=cursor,folds,slash,unix

set splitbelow
set splitright

set number
set relativenumber
set nohlsearch

set lcs=tab:»·,trail:␣,nbsp:˷
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$', -10)

if has('termguicolors')
  set termguicolors
endif
set background=dark

function! <SID>TogglePaste()
  if &paste == 0
    set norelativenumber
    set nonumber
    set paste
  else
    set number
    set relativenumber
    set nopaste
  endif
endfunction

" Mappings {{{1
let mapleader = ','

" paste things continuously
xnoremap p "_dP

" replace inside visual selection boundaries
xnoremap <leader>s :s/\%V

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

nnoremap <silent> <F2> :call <SID>TogglePaste()<CR>
" }}}

" vim: sw=2 sts=2 foldmethod=marker
