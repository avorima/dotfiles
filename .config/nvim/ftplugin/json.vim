if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap <buffer> <silent> <BS><BS> :ALEFix<CR>
