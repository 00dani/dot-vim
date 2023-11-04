vim9script
silent! packadd minpac

# Automatically bootstrap Minpac if necessary. Once it's installed it knows
# how to manage and update itself, but Vim doesn't know how to install it
# without our help. ;)
if !exists('g:loaded_minpac')
	silent !git clone https://github.com/k-takata/minpac.git $XDG_CACHE_HOME/vim/pack/minpac/opt/minpac
	augroup minpac
		autocmd!
		autocmd VimEnter * ++once minpac#update()
	augroup END
endif
packadd minpac

# Minpac is told to install into the XDG cache home because if we do blow away
# that directory, it can and will simply reinstall everything I've configured
# it to install the next time Vim is launched.
minpac#init({dir: $XDG_CACHE_HOME .. '/vim'})
minpac#add('k-takata/minpac', {type: 'opt'})

# tpope/vim-sensible is a collection of default Vim settings that "everyone
# can agree on", and is an excellent starting point for anyone's Vim config.
# We'd like it to load first, before any other plugins. However somewhat
# confusingly, Vim's native 'packages' feature adds plugins from pack/*/start
# to 'runtimepath' in REVERSE alphabetical order, so we have to put
# vim-sensible at the end of the alphabet like so to get it loaded first.
minpac#add('tpope/vim-sensible', {name: 'zz-vim-sensible'})
minpac#add('prabirshrestha/async.vim')

minpac#add('lifepillar/vim-gruvbox8')

# Project handling. Direnv is a tool for setting project-local environment
# variables as you cd around, and Editorconfig is a generic format telling
# text editors what your preferred indent size and stuff are for the given
# project. Both are very helpful to have integrated with Vim.
minpac#add('direnv/direnv.vim')
if !isdirectory($VIMRUNTIME .. '/pack/dist/opt/editorconfig')
	# If this Vim doesn't already provide Editorconfig as part of its runtime,
	# install it ourselves, using exactly the same package name and type (opt, so
	# that it can be loaded with :packadd).
	minpac#add('editorconfig/editorconfig-vim', {name: 'editorconfig', type: 'opt'})
endif

minpac#add('godlygeek/tabular')
minpac#add('jamessan/vim-gnupg')
minpac#add('lifepillar/vim-mucomplete')
minpac#add('lotabout/skim')
minpac#add('lotabout/skim.vim')
minpac#add('mhinz/vim-signify')
minpac#add('tpope/vim-apathy')
minpac#add('tpope/vim-commentary')
minpac#add('tpope/vim-endwise')
minpac#add('tpope/vim-eunuch')
minpac#add('tpope/vim-fugitive')
minpac#add('tpope/vim-repeat')
minpac#add('tpope/vim-rhubarb')
minpac#add('tpope/vim-sleuth')
minpac#add('tpope/vim-surround')
minpac#add('tpope/vim-unimpaired')

minpac#add('wincent/loupe')
minpac#add('wincent/terminus')
minpac#add('w0rp/ale')

minpac#add('yegappan/lsp')
minpac#add('00dani/SchemaStore.vim')

minpac#add('rbong/vim-crystalline')
minpac#add('lambdalisue/battery.vim')
minpac#add('lambdalisue/glyph-palette.vim')
minpac#add('lambdalisue/nerdfont.vim')

minpac#add('lambdalisue/fern.vim')
minpac#add('lambdalisue/fern-hijack.vim')
minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
minpac#add('lambdalisue/fern-git-status.vim')
minpac#add('lambdalisue/fern-ssh')

minpac#add('alvan/vim-closetag')

minpac#add('vito-c/jq.vim')
minpac#add('NoahTheDuke/vim-just')

minpac#add('fladson/vim-kitty')

minpac#add('fpob/nette.vim')

if executable('task')
	minpac#add('blindFS/vim-taskwarrior')
endif

minpac#add('pedrohdz/vim-yaml-folds')

if has('macunix')
	minpac#add('rizzatti/dash.vim')
	minpac#add('itspriddle/vim-marked')
endif
