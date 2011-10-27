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
  return map(split(globpath(s:tmpldir, a:lead.'*.'.&ft), "\n"), 'fnamemodify(v:val, ":t:r")')
endfunction

function! s:Template(name)
  let buffer_is_not_empty = search('[^ \t]', 'wn')
  if !exists('g:template_vim_use_always') || g:template_vim_use_always == 0
    if buffer_is_not_empty
      echomsg 'This buffer is already modified.'
      return
    endif
  endif
  let f = s:tmpldir . a:name . '.' . &ft
  if !filereadable(f)
    echomsg 'Template '.a:name.' is not exists.' . f
    return
  endif
  let c = join(readfile(f, "b"), "\n")
  let c = substitute(c, '{{_name_}}', expand('%:t:r:'), 'g')
  let tmp = c
  let mx = '{{_input_:\(.\{-}\)}}'
  let vars = []
  while 1
    let match = matchstr(tmp, mx)
    if len(match) == 0
      break
    endif
    let var = substitute(match, mx, '\1', 'ig')
    if index(vars, var) == -1
      call add(vars, var)
    endif
    let tmp = tmp[stridx(tmp, match) + len(match):]
  endwhile
  for var in vars
    let val = input(var . ":")
    let c = substitute(c, '\V{{_input_:'.var.'}}', '\=val', 'g')
  endfor
  let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  if len(c) == 0
    return
  endif
  if !exists('g:template_vim_use_always') || g:template_vim_use_always == 0
    silent! %d _
    silent! put = c
    silent! normal! ggdd
    silent! call search('{{_cursor_}}', 'w')
    silent! %s/{{_cursor_}}//g
  else
    if !buffer_is_not_empty
      silent! %d _
      silent! put = c
      silent! normal! ggdd
    else
      if c[len(c)-1] == "\n"
        let c = c[:-2]
      endif
      let line = getline('.')
      let indent = substitute(line, '^\(\s*\)', '\1', '')
      if line =~ '^\s*$'
        silent! normal dd
      endif
      let c = indent . substitute(c, "\n", "\n".indent, 'g')
      silent! put! = c
    endif
    if stridx(c, '{{_cursor_}}')
      silent! call search('{{_cursor_}}', 'w')
      silent! s/{{_cursor_}}//g
    endif
  endif
endfunction

" vim:ts=4:sw=4:et
