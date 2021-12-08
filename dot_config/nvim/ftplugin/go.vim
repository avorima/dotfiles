if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

setlocal list

compiler go

nnoremap <buffer> <silent> K :ALEHover<CR>

nnoremap <buffer> <leader>gao :call GoAlternateSwitch(1, "edit")<CR>
nnoremap <buffer> <leader>gas :call GoAlternateSwitch(1, "split")<CR>
nnoremap <buffer> <leader>gav :call GoAlternateSwitch(1, "vsplit")<CR>

nnoremap <buffer> <leader>gu :call GoRunTests('-short')<CR>
nnoremap <buffer> <leader>gt :call GoRunTests()<CR>

" vim: sw=2 ts=2 et
