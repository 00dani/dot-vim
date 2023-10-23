vim9script
silent! packadd minpac
if !exists('g:loaded_minpac')
	silent !git clone https://github.com/k-takata/minpac.git $XDG_CACHE_HOME/vim/pack/minpac/opt/minpac
	augroup minpac
		autocmd!
		autocmd VimEnter * ++once minpac#update()
	augroup END
endif
packadd minpac

minpac#init({dir: $XDG_CACHE_HOME .. '/vim'})
minpac#add('k-takata/minpac', {type: 'opt'})
minpac#add('tpope/vim-sensible')
minpac#add('prabirshrestha/async.vim')

minpac#add('lifepillar/vim-gruvbox8')

if !isdirectory($VIMRUNTIME .. '/pack/dist/opt/editorconfig')
	minpac#add('editorconfig/editorconfig-vim')
endif

minpac#add('direnv/direnv.vim')
minpac#add('godlygeek/tabular')
minpac#add('jamessan/vim-gnupg')
minpac#add('junegunn/vim-easy-align')
minpac#add('lifepillar/vim-mucomplete')
minpac#add('lotabout/skim')
minpac#add('lotabout/skim.vim')
minpac#add('mhinz/vim-signify')
minpac#add('sjl/vitality.vim')
minpac#add('tpope/vim-apathy')
minpac#add('tpope/vim-commentary')
minpac#add('tpope/vim-dadbod')
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
minpac#add('LaTeX-Box-Team/LaTeX-Box')
minpac#add('vhda/verilog_systemverilog.vim')
minpac#add('sheerun/vim-polyglot')

minpac#add('eipipuz/factor.vim')

minpac#add('ehamberg/vim-cute-python')
minpac#add('Glench/Vim-Jinja2-Syntax')
minpac#add('tweekmonster/braceless.vim')

minpac#add('vito-c/jq.vim')
minpac#add('NoahTheDuke/vim-just')

minpac#add('fladson/vim-kitty')

minpac#add('fpob/nette.vim')

minpac#add('leafOfTree/vim-svelte-plugin')

if executable('task')
	minpac#add('farseer90718/vim-taskwarrior')
endif

minpac#add('pedrohdz/vim-yaml-folds')

minpac#add('alx741/yesod.vim')
minpac#add('pbrisbin/vim-syntax-shakespeare')

if has('macunix')
	minpac#add('rizzatti/dash.vim')
	# We rename this plugin to make sure it loads AFTER vim-polyglot,
	# since it won't work properly if it's loaded first.
	minpac#add('itspriddle/vim-marked', {name: 'zzvim-marked'})
endif
