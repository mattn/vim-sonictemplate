"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 28-Oct-2011.
"
" Vim commands to load template.
"
"   :Template {name}
"       Load template named as {name} in the current buffer.

command! -nargs=1 -complete=customlist,sonictemplate#complete Template call sonictemplate#apply(<f-args>)
nnoremap <c-y>t :call sonictemplate#select()<cr>
inoremap <c-y>t <esc>:call sonictemplate#select()<cr>

" vim:ts=4:sw=4:et
