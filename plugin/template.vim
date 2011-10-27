" template.vim: Vim commands to load template.
"
" This filetype plugin adds one command for the buffers:
"
"   :Template {name}
"
"       Load template named as {name} in the current buffer.
"       Template file is stored in ~/.vim/template.
"       If you are using pathogen.vim, template folder is located at following. 
"
"         ~/.vim/bundle/template-vim
"             plugin
"               template.vim # This file.
"             template
"               main.go
"               package.go
"               package.perl
"               script.perl
"

command! -nargs=1 -complete=customlist,TemplateComplete Template call s:Template(<f-args>)

let s:tmpldir = expand('<sfile>:p:h:h') . '/template/'

function! TemplateComplete(lead, cmdline, curpos)
  return map(split(globpath(s:tmpldir, '*.'.&ft), "\n"), 'fnamemodify(v:val, ":t:r")')
endfunction

function! s:Template(name)
  if search('[^ \t]', 'w') != 0
    echomsg 'This buffer is already modified.'
    return
  endif
  let f = s:tmpldir . a:name . '.' . &ft
  if !filereadable(f)
    echomsg 'Template '.a:name.' is not exists.' . f
    return
  endif
  let c = join(readfile(f, "b"), "\n")
  let c = substitute(c, '{{_name_}}', expand('%:t:r:'), 'g')
  let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  let tmp = c
  let mx = '{{_input_:\(.\{-}\)}}'
  let vars = {}
  while 1
    let match = matchstr(tmp, mx)
    if len(match) == 0
      break
    endif
    let token = substitute(match, mx, '\1', 'ig')
    let vars[token] = 1
    let tmp = tmp[stridx(tmp, match) + len(match):]
  endwhile
  for key in keys(vars)
    let val = input(key . ":")
    let c = substitute(c, '\V{{_input_:'.key.'}}', '\=val', 'g')
  endfor
  silent! %d _
  silent! put = c
  silent! normal! ggdd
  silent! call search('{{_cursor_}}', 'w')
  silent! %s/{{_cursor_}}//g
endfunction

" vim:ts=4:sw=4:et
