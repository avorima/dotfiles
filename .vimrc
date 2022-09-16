set nocompatible

set expandtab
set softtabstop=4
set shiftwidth=4

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

set lcs=tab:»·,trail:␣,nbsp:˷
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$', -10)

if has('termguicolors')
  set termguicolors
endif
set background=dark

nnoremap <space> <nop>
let mapleader = "\<Space>"

" Mappings {{{1

" paste things continuously
xnoremap p "_dP

" replace inside visual selection boundaries
xnoremap <leader>s :s/\%V

" don't leave visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" don't short jumps in jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}zz"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{zz"<CR>

" make 'n' and 'N' behave the same way
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" substitute word under cursor on line/globally
nnoremap <leader>s :s/\C\<<C-r><C-w>\>//g<left><left>
nnoremap <leader>S :%s/\C\<<C-r><C-w>\>//g<left><left>

" }}}

" vim: sw=2 sts=2 foldmethod=marker
