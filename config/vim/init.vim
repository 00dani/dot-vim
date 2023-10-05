vim9script
set encoding=utf-8
scriptencoding utf-8

def EnsureDir(dir: string): void
  if filewritable(dir) != 2
    mkdir(dir, "p", 0700)
  endif
enddef

# These are really clever - minpac will actually be loaded on the fly only
# when you need to update or clean your packages, rather than all the time.
command! PackUpdate source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#update()
command! PackClean  source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#clean()
command! PackStatus source $XDG_CONFIG_HOME/vim/plugins.vim | minpac#status()

# If the pack directory doesn't exist, we haven't installed any packages yet,
# so let's call PackUpdate.
if !isdirectory($XDG_CACHE_HOME .. '/vim/pack')
  PackUpdate
endif

augroup transparent_term
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END

set background=dark
g:gruvbox_italic = 1
g:gruvbox_improved_strings = 1
g:gruvbox_improved_warnings = 1

if has('gui_running') || has('termguicolors')
  if $COLORTERM == 'truecolor'
    &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  endif
  set termguicolors
  silent! packadd gruvbox
  g:airline_theme = 'gruvbox'
  colorscheme gruvbox
else
  colorscheme inkpot
endif

inoremap jj <Esc>
nnoremap <C-t> :Files<CR>


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

g:airline_powerline_fonts = 1
g:airline#extensions#battery#enabled = 1

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

set keywordprg=:LspHover

source $XDG_CONFIG_HOME/vim/lsp.vim
