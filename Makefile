all : sonictemplate-vim.zip

remove-zip:
	-rm doc/tags
	-rm sonictemplate-vim.zip

sonictemplate-vim.zip: remove-zip
	zip -r sonictemplate-vim.zip autoload plugin doc template

release: sonictemplate-vim.zip
	vimup update-script sonictemplate.vim
