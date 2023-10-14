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

if has('gui_running') || has('termguicolors')
	if $COLORTERM == 'truecolor'
		&t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
		&t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
	endif
	set termguicolors
endif

set background=dark
g:gruvbox_transp_bg = 1
g:gruvbox_italicize_strings = 0
g:gruvbox_filetype_hi_groups = 1
g:gruvbox_plugin_hi_groups = 1
colorscheme gruvbox8

inoremap jj <Esc>
nnoremap <C-t> :Files<CR>

packadd! editorconfig

if exists('+belloff')
	set belloff+=ctrlg
endif

set completeopt+=menuone

set linebreak showbreak=↩
set modelines=5
set showcmd
set wildmode=longest,full
if has('patch-8.2.4325')
	set wildoptions+=pum
endif

set tabstop=2 shiftwidth=2

if exists('+breakindent')
	set breakindent breakindentopt=sbr
endif

if exists('+relativenumber')
	set relativenumber
else
	set number
endif

for dir_name in ['backup', 'swap', 'undo']
	EnsureDir($XDG_STATE_HOME .. '/vim/' .. dir_name)
endfor

set backupdir=.,$XDG_STATE_HOME/vim/backup
set directory=.,$XDG_STATE_HOME/vim/swap
if exists('+undofile')
	set undofile
	set undodir=$XDG_STATE_HOME/vim/undo
endif

g:csv_no_conceal = 1

g:vim_svelte_plugin_use_typescript = 1

g:LatexBox_Folding = 1
g:NERDTreeHijackNetrw = 1

g:ale_set_balloons = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

g:mucomplete#can_complete = {
	default: {
		omni: (t) => strlen(&l:omnifunc) > 0 && t =~# '\m\k\%(\k\|\.\)$'
	}
}

import "./statusline.vim"
statusline.Init()

import "./lsp.vim"
lsp.LazyConfigure()

set formatexpr=lsp#lsp#FormatExpr()
set keywordprg=:LspHover
nnoremap gD <Cmd>LspGotoDeclaration<CR>
nnoremap gd <Cmd>LspGotoDefinition<CR>
nnoremap gi <Cmd>LspGotoImpl<CR>
nnoremap <C-k> <Cmd>LspShowSignature<CR>
nnoremap gr <Cmd>LspShowReferences<CR>
xnoremap <silent> <Leader>e <Cmd>LspSelectionExpand<CR>
xnoremap <silent> <Leader>s <Cmd>LspSelectionShrink<CR>
