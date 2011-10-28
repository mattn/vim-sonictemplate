"=============================================================================
" template.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 28-Oct-2011.
"
" Vim commands to load template.
"
"   :Template {name}
"       Load template named as {name} in the current buffer.

command! -nargs=1 -complete=customlist,template#complete Template call template#apply(<f-args>)
inoremap <c-y>t <esc>:call template#select()<cr>

" vim:ts=4:sw=4:et
