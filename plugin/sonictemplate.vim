"=============================================================================
" File: sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 01-May-2013.
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

exe "command!" "-nargs=1" "-complete=customlist,sonictemplate#complete" get(g:, 'sonictemplate_commandname', 'Template') "call sonictemplate#apply(<f-args>, 'n')"

if get(g:, 'sonictemplate_key', '') == ''
  nnoremap <plug>(sonictemplate) :call sonictemplate#select('n')<cr>
  inoremap <plug>(sonictemplate) <c-r>=sonictemplate#select('i')<cr>
  nmap <unique> <c-y>t <plug>(sonictemplate)
  imap <unique> <c-y>t <plug>(sonictemplate)
  nmap <unique> <c-y><c-t> <plug>(sonictemplate)
  imap <unique> <c-y><c-t> <plug>(sonictemplate)
else
  exe "nnoremap" g:sonictemplate_key ":call sonictemplate#select('n')<cr>"
  exe "inoremap" g:sonictemplate_key "<c-r>=sonictemplate#select('i')<cr>"
endif
if get(g:, 'sonictemplate_intelligent_key', '') == ''
  nnoremap <plug>(sonictemplate-intelligent) :call sonictemplate#select_intelligent('n')<cr>
  inoremap <plug>(sonictemplate-intelligent) <c-r>=sonictemplate#select_intelligent('i')<cr>
  nmap <unique> <c-y>T <plug>(sonictemplate-intelligent)
  imap <unique> <c-y>T <plug>(sonictemplate-intelligent)
else
  exe "nnoremap" g:sonictemplate_intelligent_key ":call sonictemplate#select_intelligent('n')<cr>"
  exe "inoremap" g:sonictemplate_intelligent_key "<c-r>=sonictemplate#select_intelligent('i')<cr>"
endif

" TODO fix better name
if get(g:, 'sonictemplate_enable_pattern', 0) != 0
  augroup sonictemplate
    au! filetype * silent! call sonictemplate#load_pattern()
  augroup END
  inoremap <plug>(sonictemplate-pattern) <c-r>=sonictemplate#pattern()<cr>
  imap <unique> <c-y><c-b> <plug>(sonictemplate-pattern)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
