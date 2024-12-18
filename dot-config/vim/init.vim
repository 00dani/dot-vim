vim9script
set encoding=utf-8
scriptencoding utf-8

def EnsureDir(dir: string): void
	mkdir(dir, "p", 0700)
enddef

# These are really clever - minpac will actually be loaded on the fly only
# when you need to update or clean your packages, rather than all the time.
command! PackUpdate source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#update()
command! PackClean	source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#clean()
command! PackStatus source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#status()

# If the pack directory doesn't exist, we haven't installed any packages yet,
# so let's call PackUpdate.
if !isdirectory($XDG_CACHE_HOME .. '/vim/pack')
	PackUpdate
endif

# If both Vim and the terminal it's running in support true colour, use it.
# Otherwise we just fall back to 256-colour mode, or even the old 16-colour
# mode if necessary!
if has('termguicolors') && $COLORTERM == 'truecolor'
	set termguicolors
endif

# Colour scheme and corresponding settings. gruvbox8 happens to work on pretty
# much any setup (GUI vim, true-colour terminal, 256 colours, even a 2-colour
# term if necessary!) so we don't need to mess around too much here.
set background=dark
g:gruvbox_transp_bg = 1
g:gruvbox_italicize_strings = 0
g:gruvbox_filetype_hi_groups = 1
g:gruvbox_plugin_hi_groups = 1
colorscheme gruvbox8

# I like being able to drop out of Insert mode without reaching for the Escape
# key in the corner. Some folks use jk instead but I find jj nice and quick.
inoremap jj <Esc>

# lotabout/skim.vim's fuzzy file finder! It's basically a copy of fzf.vim, but
# it uses skim as the backend instead of fzf. Rust versions of command-line
# tools my beloved
nnoremap <C-t> :Files<CR>

# We will always have Editorconfig available as an optional package, either
# because it was bundled with Vim or because Minpac installed it that way.
packadd! editorconfig

set belloff+=ctrlg

# I like to explicitly set 'modelines' to the default 5 because some
# distributions change it to zero in the global config, and I want modelines
# to work.
set modelines=5

if has('linebreak')
	set breakindent breakindentopt=sbr
	set linebreak showbreak=↩
endif

# Setting both number and relativenumber gets you a "hybrid" setup where the
# current line's absolute number is displayed, but the other lines have
# relative numbmers displayed. It's more useful than always seeing a 0 for the
# current line.
set number relativenumber
set showcmd
set title

set completeopt+=menuone
set wildmode=longest,full
set wildoptions+=pum

# This is a window-local setting but I like 2 by default. :)
set conceallevel=2

# I like small indents. This setup supports both vim-sleuth and editorconfig,
# so files with different indent schemes will automatically be handled
# correctly, but this default is what I like personally. Also, I *vastly*
# prefer tabs over spaces for indentation, for the simple reason that if
# someone else needs a bigger indent size than I do, they can just change
# their editor's tabstop setting rather than having to reindent the whole
# file.
set tabstop=2 shiftwidth=2

for dir_name in ['backup', 'swap', 'undo']
	EnsureDir($XDG_STATE_HOME .. '/vim/' .. dir_name)
endfor

# Try to save backup and swap files alongside the original file, but if that's
# not possible (directory not writable, for example), then fall back to the
# appropriate XDG directory instead.
set backupdir=.,$XDG_STATE_HOME/vim/backup
set directory=.,$XDG_STATE_HOME/vim/swap

# I like persistent undo! If Vim was built with it, then persist undo files
# for eveything in the XDG state home. :)
if exists('+undofile')
	set undofile
	set undodir=$XDG_STATE_HOME/vim/undo
endif

g:csv_no_conceal = 1

g:GPGDefaultRecipients = [
	'Danielle McLean <dani@00dani.me>',
]

g:javascript_plugin_jsdoc = 1

g:markdown_folding = 1
g:markdown_fenced_languages = [
	'bash', 'c', 'dockerfile',
 	'ini=dosini', 'json=json5',
	'j', 'js=javascript', 'javascript',
	'python', 'php', 'scala',
]

# A really quick updatetime is preferable to get vim-signify to check for
# unsaved changes in your buffer more regularly. It's all asynchronous so
# running it more regularly ought to be fine.
set updatetime=100
g:signify_number_highlight = 1

g:ale_linters = {
	javascript: ['eslint'],
	javascriptreact: ['eslint'],
	typescript: ['eslint'],
}
g:ale_fixers = {
	python: ['ruff', 'ruff_format'],
}
g:ale_fix_on_save = 1
g:ale_set_balloons = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

# Get the correct filetype icons and matching colours when viewing a directory
# in Fern. As the name implies, this requires Nerd Fonts support, either by
# using a patched font or by having your setup substitute an icon font when
# necessary.
g:fern#renderer = 'nerdfont'
augroup glyphPalette
	autocmd!
	autocmd FileType fern g:glyph_palette#apply()
augroup END

set spelllang=en_au
g:lexical#dictionary_key = '<leader>k'
g:lexical#thesaurus = [$XDG_CACHE_HOME .. '/vim/thesaurus/mthesaur.txt']
g:lexical#thesaurus_key = '<leader>t'
augroup lexical
	autocmd!
	autocmd FileType markdown,mkd lexical#init()
	autocmd FileType tex lexical#init()
augroup END

g:mucomplete#can_complete = {
	default: {
		omni: (t) => strlen(&l:omnifunc) > 0 && (t =~# '\m\k\k$' || (g:mucomplete_with_key && t =~# '\m\S$'))
	}
}

# Configure a statusline and tabline using vim-crystalline. I tried a bunch of
# different statusline plugins and this one, which is basically just a utility
# library for writing your *own* statusline functions, worked the best for my
# purposes. Very quick, naturally very configurable, I could tell the modified
# buffer + to appear in red, all that good stuff. Yay!
import "./statusline.vim"
statusline.Init()

# Set up LSP client support. My lsp.vim module both tells yegappan/lsp which
# LSP servers it can connect to and provides a way to install those servers if
# necessary.
import "./lsp.vim"
lsp.Configure()
