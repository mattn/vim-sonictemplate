"=============================================================================
" File: sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 10-Jun-2012.
" Version: 0.10
" WebPage: http://github.com/mattn/sonictemplate-vim
" Description: Easy and high speed coding method
" Usage:
"
"   :Template {name}
"       Load template named as {name} in the current buffer.
"
"   Or type <c-y> + t

if &cp || (exists('g:loaded_sonictemplate_vim') && g:loaded_sonictemplate_vim)
  finish
endif
let g:loaded_sonictemplate_vim = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -complete=customlist,sonictemplate#complete Template call sonictemplate#apply(<f-args>, 'n')

if get(g:, 'sonictemplate_key', '') == ''
  nnoremap <plug>(sonictemplate) :call sonictemplate#select('n')<cr>
  inoremap <plug>(sonictemplate) <space><bs><c-o>:call sonictemplate#select('i')<cr>

  nmap <unique> <c-y>t <plug>(sonictemplate)
  imap <unique> <c-y>t <plug>(sonictemplate)
else
  exe "nnoremap" g:sonictemplate_key ":call sonictemplate#select('n')<cr>"
  exe "inoremap" g:sonictemplate_key "<space><bs><c-o>:call sonictemplate#select('i')<cr>"
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
