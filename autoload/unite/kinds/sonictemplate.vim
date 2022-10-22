" File:    sonictemplate.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: BSD style license

let s:save_cpo = &cpoptions
set cpoptions&vim

function! unite#kinds#sonictemplate#define() abort "{{{
  return s:kind
endfunction "}}}

let s:kind = {
\ 'name' : 'sonictemplate',
\ 'default_action' : 'insert',
\ 'parents' : ['file'],
\ 'action_table' : {},
\ 'alias_table' : {},
\}

let s:kind.action_table.insert = {
\ 'description' : 'insert this template',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.insert.func(candidate) abort "{{{
  call sonictemplate#apply(
\   a:candidate.word,
\   a:candidate.action__mode,
\ )
endfunction "}}}

" local functions {{{
" }}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
" __END__
