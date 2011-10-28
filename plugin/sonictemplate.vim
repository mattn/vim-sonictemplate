"=============================================================================
" File: sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 28-Oct-2011.
" Version: 0.01
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

command! -nargs=1 -complete=customlist,sonictemplate#complete Template call sonictemplate#apply(<f-args>)
nnoremap <c-y>t :call sonictemplate#select()<cr>
inoremap <c-y>t <esc>:call sonictemplate#select()<cr>

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
