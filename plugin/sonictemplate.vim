"=============================================================================
" File: sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 25-Nov-2020.
" Version: 0.10
" WebPage: http://github.com/mattn/sonictemplate-vim
" Description: Easy and high speed coding method
" Usage:
"
"   :Template {name}
"       Load template named as {name} in the current buffer.
"
"   Or type <c-y> + t

if &compatible || (exists('g:loaded_sonictemplate_vim') && g:loaded_sonictemplate_vim)
  finish
endif
let g:loaded_sonictemplate_vim = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

exe 'command!' '-nargs=1' '-complete=customlist,sonictemplate#complete' get(g:, 'sonictemplate_commandname', 'Template') 'call sonictemplate#apply(<f-args>, "n")'

nnoremap <plug>(sonictemplate) :call sonictemplate#select('n')<cr>
inoremap <plug>(sonictemplate) <c-r>=sonictemplate#select('i')<cr>
vnoremap <plug>(sonictemplate) :<c-u>call sonictemplate#select('v')<cr>
if !hasmapto('<plug>(sonictemplate)') && get(g:, 'sonictemplate_key', 1) !=# ''
  if empty(get(g:, 'sonictemplate_key'))
    nmap <unique> <c-y>t <plug>(sonictemplate)
    imap <unique> <expr> <c-y>t pumvisible()?'<c-e><plug>(sonictemplate)':'<plug>(sonictemplate)'
    vmap <unique> <c-y>t <plug>(sonictemplate)
    nmap <unique> <c-y><c-t> <c-y>t
    imap <unique> <c-y><c-t> <c-y>t
    vmap <unique> <c-y><c-t> <c-y>t
  else
    exe 'nmap' g:sonictemplate_key '<plug>(sonictemplate)'
    exe 'imap' g:sonictemplate_key '<plug>(sonictemplate)'
    exe 'vmap' g:sonictemplate_key '<plug>(sonictemplate)'
  endif
endif

nnoremap <plug>(sonictemplate-intelligent) :call sonictemplate#select_intelligent('n')<cr>
inoremap <plug>(sonictemplate-intelligent) <c-r>=sonictemplate#select_intelligent('i')<cr>
vnoremap <plug>(sonictemplate-intelligent) <c-r>=sonictemplate#select_intelligent('v')<cr>
if !hasmapto('<plug>(sonictemplate-intelligent)') && get(g:, 'sonictemplate_intelligent_key', 1) !=# ''
  if empty(get(g:, 'sonictemplate_intelligent_key'))
    nmap <unique> <c-y>T <plug>(sonictemplate-intelligent)
    imap <unique> <expr> <c-y>T pumvisible()?'<c-e><plug>(sonictemplate-intelligent)':'<plug>(sonictemplate-intelligent)'
    vmap <unique> <c-y>T <plug>(sonictemplate-intelligent)
  else
    exe 'nmap' g:sonictemplate_intelligent_key '<plug>(sonictemplate-intelligent)'
    exe 'imap' g:sonictemplate_intelligent_key '<plug>(sonictemplate-intelligent)'
    exe 'vmap' g:sonictemplate_intelligent_key '<plug>(sonictemplate-intelligent)'
  endif
endif

inoremap <plug>(sonictemplate-postfix) <c-r>=sonictemplate#postfix()<cr>
if !hasmapto('<plug>(sonictemplate-postfix)') && get(g:, 'sonictemplate_postfix_key', 1) !=# ''
  if empty(get(g:, 'sonictemplate_postfix_key'))
    imap <unique> <expr> <c-y><c-b> pumvisible()?'<c-e><plug>(sonictemplate-postfix)':'<plug>(sonictemplate-postfix)'
  else
    exe 'imap' g:sonictemplate_postfix_key '<plug>(sonictemplate-postfix)'
  endif
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
