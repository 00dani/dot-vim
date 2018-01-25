silent! packadd minpac
if !exists('*minpac#init')
  silent !git clone https://github.com/k-takata/minpac.git $XDG_CACHE_HOME/vim/pack/minpac/opt/minpac
  augroup minpac
    autocmd!
    autocmd VimEnter * call minpac#update()
  augroup END
endif

packadd minpac

call minpac#init({'dir': $XDG_CACHE_HOME . '/vim'})
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('tpope/vim-sensible')

call minpac#add('ciaranm/inkpot', {'type': 'opt', 'do': 'colorscheme inkpot'})
call minpac#add('morhetz/gruvbox', {'type': 'opt'})

call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('jamessan/vim-gnupg')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('junegunn/vim-easy-align')
call minpac#add('lifepillar/vim-mucomplete')
call minpac#add('mhinz/vim-signify')
call minpac#add('scrooloose/nerdtree')
call minpac#add('sjl/vitality.vim')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-endwise')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-rhubarb')
call minpac#add('tpope/vim-sleuth')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('wincent/loupe')
call minpac#add('wincent/terminus')
call minpac#add('w0rp/ale')

call minpac#add('LaTeX-Box-Team/LaTeX-Box')
call minpac#add('vhda/verilog_systemverilog.vim')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('sukima/xmledit')

call minpac#add('lepture/vim-jinja')

call minpac#add('alx741/yesod.vim')
call minpac#add('pbrisbin/vim-syntax-shakespeare')


if has('macunix')
  call minpac#add('itspriddle/vim-marked')
endif
