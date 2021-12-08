if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

" vim: sw=2 ts=2 et
