function! s:handler(item) abort
  call sonictemplate#apply(a:item, 'n')
endfunction

function! fzf#sonictemplate#run() abort
  call fzf#run(
          \ fzf#wrap({
              \ 'sink*': function('s:handler'),
              \ 'source': sonictemplate#complete("", "", 0)
			  \}))
endfunction
