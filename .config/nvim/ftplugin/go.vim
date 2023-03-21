if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab
setlocal shiftwidth=8
setlocal softtabstop=8

setlocal list

setlocal textwidth=120

compiler go

nnoremap <buffer> <silent> <leader>gao :call GoAlternateSwitch(1, "edit")<CR>
nnoremap <buffer> <silent> <leader>gas :call GoAlternateSwitch(1, "split")<CR>
nnoremap <buffer> <silent> <leader>gav :call GoAlternateSwitch(1, "vsplit")<CR>

nnoremap <buffer> <leader>tu :call GoRunTests('-short')<CR>
nnoremap <buffer> <leader>tr :call GoRunTests('-race', '-count=1')<CR>
nnoremap <buffer> <leader>tt :call GoRunTests()<CR>
nnoremap <buffer> <leader>to :call GoRunTestUnderCursor()<CR>

" vim: sw=2 ts=2 et
