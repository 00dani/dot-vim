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

# Git support. Fugitive is a pretty famous wrapper that adds :Git commands
# when you're in a repo, and Rhubarb is a GitHub-specific support addon for
# it. (I don't personally use GitHub much, but work does, so whatever.)
# Signify marks changed lines in the current buffer with symbols in the left
# margin, which I finde very helpful.
minpac#add('tpope/vim-fugitive')
minpac#add('tpope/vim-rhubarb')
minpac#add('mhinz/vim-signify')

# Tpope makes a *lot* of Vim plugins. Here're the others I use!

# Mapping stuff:
# Repeat a supporting plugin's custom mapping with Vim's . command. This
# functionality is invoked by many other plugins to get repeat support.
minpac#add('tpope/vim-repeat')
# Comment/uncomment operator, mapped to gc.
minpac#add('tpope/vim-commentary')
# Adjust "surroundings", like quotes and brackets.
minpac#add('tpope/vim-surround')
# Paired mappings (encode/decode, next/prev, etc.)
minpac#add('tpope/vim-unimpaired')

# Filetype support stuff:
# Set Vim's 'path' for various filetypes, so commands like gf work.
minpac#add('tpope/vim-apathy')
# Automatically insert end keywords for various filetypes.
minpac#add('tpope/vim-endwise')

# Configure indentation and related file-local settings automatically. Sleuth
# supports Editorconfig files and uses them when it can, just like the
# editorconfig-vim plugin does. However, there are some Editorconfig
# properties which editorconfig-vim supports and Sleuth doesn't, and Sleuth
# can still infer indentation settings when you don't have an .editorconfig
# file, so running both plugins side-by-side is useful.
minpac#add('tpope/vim-sleuth')


# My preferred colorscheme! gruvbox8 is a variant of the popular Gruvbox theme
# with better support for Vim 8+ features like :terminal, along with various
# other niceties. It also gracefully degrades from true colour all the way
# down to *two* colours if necessary, which is kind of impressive.
minpac#add('lifepillar/vim-gruvbox8')

# Sensible tab completion support. MUcomplete is ridiculously simple and
# basically just translates <Tab> to Vim's standard completion bindings, and
# it's *great* for my purposes.
minpac#add('lifepillar/vim-mucomplete')

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

# Access Zoxide, a frecency-powered cd command, from inside Vim.
minpac#add('nanotee/zoxide.vim')

# skim is a standalone fuzzy finder, kinda like fzf or fzy or selecta, but
# written in Rust. These two plugins teach Vim to integrate with it, so you
# can use skim's high performance fuzzy finding to locate stuff (files,
# buffers, colorschemes) inside Vim. Nice!
minpac#add('lotabout/skim')
minpac#add('lotabout/skim.vim')

# Transparently view and edit GPG-encrypted files in Vim. I find this most
# useful when working with my password-store, but obviously it's helpful
# anywhere you're using GnuPG.
minpac#add('jamessan/vim-gnupg')

# Improved in-file search behaviour: highlight the current match separately,
# default to very magic /\v regular expressions, and configure Vim's standard
# search-related settings to be a bit more intuitive.
minpac#add('wincent/loupe')
# Enhance Vim's behaviour when running in a terminal, which is the main way I
# use it. Terminus does the following:
# - sets the cursor shape according to current mode,
# - turns on full mouse support in all modes,
# - enables Vim's standard FocusGained and FocusLost events, by requesting
#   focus reporting from the terminal, and
# - binds those events to calling :checktime, so that Vim will
#   automatically reload unmodified files if they're changed externally (say,
#   by a Git checkout).
# Terminus also used to be required for bracketed paste to work properly, but
# I think Vim supports that by default now.
minpac#add('wincent/terminus')

# Asynchronous Linter Engine: supports a huge range of linters for various
# filetypes, runs them in the background, and reports issues to you in the
# left margin. Many language plugins bundle their own ale_linters, making it a
# cool choice for maximum linter support.
minpac#add('dense-analysis/ale')
# A client for the Language Server Protocol. ALE provides an LSP client as
# well, but I prefer the way yegappan/lsp is configured and the two plugins
# play quite nicely together. My servers are configured in the ./lsp.vim
# module.
minpac#add('yegappan/lsp')
# The catalog of JSON Schema definitions available at https://SchemaStore.org.
# I use this to configure the JSON language server with schema validation and
# completion support, since unlike the YAML server I can't just tell it to
# please use SchemaStore.org for some reason.
minpac#add('00dani/SchemaStore.vim')

# vim-crystalline is a utility library to aid in writing your own Vim
# statusline and tabline functions. I've used it extensively in my
# ./statusline.vim module. The plugins below it provide stuff I like to have
# displayed in the statusline.
minpac#add('rbong/vim-crystalline')
minpac#add('lambdalisue/battery.vim') # System's current battery level
minpac#add('lambdalisue/glyph-palette.vim') # Appropriate colours for filetypes
minpac#add('lambdalisue/nerdfont.vim') # Icons for filetypes

# fern.vim is a lightweight and asychronous tree viewer that serves as a
# delightful little file browser. It's kinda like the popular NERDtree plugin,
# but much simpler.
minpac#add('lambdalisue/fern.vim')
minpac#add('lambdalisue/fern-hijack.vim') # Replace Netrw with Fern!
minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
minpac#add('lambdalisue/fern-git-status.vim')
minpac#add('lambdalisue/fern-ssh')

# Automatically close XML tags when you type the opening tag. Kinda like
# vim-endwise for XML. Very nice to have when working on HTML documents.
minpac#add('alvan/vim-closetag')

# Syntax and indent support for Jinja2 templates.
minpac#add('lepture/vim-jinja')

# Syntax highlighting for scripts written in jq's filter language.
minpac#add('vito-c/jq.vim')

# Syntax highlighting for justfiles, which are very similar to Makefiles, but
# different enough that using a separate filetype does make sense.
minpac#add('NoahTheDuke/vim-just')

# Syntax highlighting for kitty.conf, which is really helpful because
# kovidgoyal/kitty is my daily driver terminal emulator. Yay!
minpac#add('fladson/vim-kitty')

# Really good support for LaTeX, including enhanced syntax highlighting but
# also auto-compilation and SyncTeX search support in both directions.
minpac#add('lervag/vimtex')

# Dramatically buff Vim's built-in dictionary and thesaurus features when
# editing prose, making it much more viable for that kind of work.
minpac#add('preservim/vim-lexical')

# Syntax highlighting for .neon files, like phpstan.neon. Nette is actually a
# full-blown PHP web framework and this plugin provides other Nette tooling
# too, but I don't use Nette so it's really just providing syntax for the
# PHPStan config file in my case.
minpac#add('fpob/nette.vim')

# Syntax highlighting and other minor niceties for Typst source. Nothing too
# exciting: we also rely on communicating with typst-lsp for full language
# support functionality.
minpac#add('kaarmu/typst.vim')

# Really good semantic folding for YAML and YAML-like files. If you're
# curious: https://pedrohdz.com/posts/programming/yaml_vim_folds/
minpac#add('pedrohdz/vim-yaml-folds')

# An interactive mode for Taskwarrior, built as a Vim plugin. It's obviously
# only useful if Taskwarrior is installed.
if executable('task')
	minpac#add('blindFS/vim-taskwarrior')
endif

# Integrations with MacOS apps, which are useless if Vim's running on
# something other than MacOS.
if has('macunix')
	# Dash is a developer documentation viewer, and this plugin makes it easy to
	# search up the relevant Dash docs from inside Vim.
	minpac#add('rizzatti/dash.vim')

	# Marked is a Markdown preview window. It's nice to run this alongside your
	# Vim window when writing in Markdown, especially if you need to do weird
	# things with the syntax.
	minpac#add('itspriddle/vim-marked')
endif
