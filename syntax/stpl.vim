syn clear

syn match stplPattern        /^\S.*$/
syn match stplSnippet        /^\t.*$/ contains=stplPlaceHolder
syn region stplPlaceHolder    start="{{" end="}}"
hi def link     stplPattern         Special
hi def link     stplPlaceHolder     Keyword
