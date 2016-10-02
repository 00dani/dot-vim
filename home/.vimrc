if has('win32')
	set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
	set viminfo+=n~/.viminfo
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-sensible'

Plug 'ciaranm/inkpot'
Plug 'ervandew/supertab'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wincent/terminus'

Plug 'sukima/xmledit'

if has('macunix')
  Plug 'itspriddle/vim-marked'
endif

call plug#end()

colorscheme inkpot
inoremap jj <Esc>
set tabstop=2 shiftwidth=2
