set encoding=utf-8
scriptencoding utf-8

function! s:ensure_dir(dir)
  if filewritable(a:dir) != 2
    call mkdir(a:dir, "p", 0700)
  endif
endfunction

" These are really clever - minpac will actually be loaded on the fly only
" when you need to update or clean your packages, rather than all the time.
command! PackUpdate source $XDG_CONFIG_HOME/vim/plugins.vim | call minpac#update()
command! PackClean  source $XDG_CONFIG_HOME/vim/plugins.vim | call minpac#clean()

" If the pack directory doesn't exist, we haven't installed any packages yet,
" so let's call PackUpdate.
if !isdirectory($XDG_CACHE_HOME . '/vim/pack')
  PackUpdate
endif

" Use Inkpot, since it's gorgeous, but with a transparent background instead
" of a solid black one.
augroup transparent_term
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE
augroup END
silent! colorscheme inkpot

inoremap jj <Esc>
nnoremap <C-t> :Files<CR>

set belloff+=ctrlg
set completeopt+=menuone

set linebreak showbreak=↩
set showcmd
set wildmode=longest,full

set tabstop=2 shiftwidth=2

if exists('+breakindent')
  set breakindent breakindentopt=sbr
endif

if exists('+relativenumber')
  set relativenumber
else
  set number
endif

for s:dir in ['backup', 'swap', 'undo']
  call s:ensure_dir($XDG_CACHE_HOME . '/vim/' . s:dir)
endfor

set backupdir=.,$XDG_CACHE_HOME/vim/backup
set directory=.,$XDG_CACHE_HOME/vim/swap
if exists('+undofile')
  set undofile
  set undodir=$XDG_CACHE_HOME/vim/undo
endif

let g:airline_powerline_fonts = 1
let g:LatexBox_Folding = 1
let g:NERDTreeHijackNetrw = 1
