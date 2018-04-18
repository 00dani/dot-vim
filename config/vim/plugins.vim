if exists('+packpath')
  silent! packadd minpac
  if !exists('*minpac#init')
    silent !git clone https://github.com/k-takata/minpac.git $XDG_CACHE_HOME/vim/pack/minpac/opt/minpac
    augroup minpac
      autocmd!
      autocmd VimEnter * call minpac#update()
    augroup END
  endif

  function! Plug(...)
    call call('minpac#add', a:000)
  endfunction

  function! PlugEnd()
  endfunction

  packadd minpac

  call minpac#init({'dir': $XDG_CACHE_HOME . '/vim'})
else
  if !filereadable($XDG_CACHE_HOME . '/vim/autoload/plug.vim')
    silent !curl -fLo $XDG_CACHE_HOME/vim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    augroup vimplug
      autocmd VimEnter * PlugInstall
    augroup END
  endif

  function! Plug(name, ...)
    call plug#(a:name)
  endfunction

  function! PlugEnd()
    call plug#end()
  endfunction

  call plug#begin($XDG_CACHE_HOME . '/vim/plugged')
endif

call Plug('k-takata/minpac', {'type': 'opt'})
call Plug('tpope/vim-sensible')
call Plug('prabirshrestha/async.vim')

call Plug('ciaranm/inkpot', {'type': 'opt', 'do': 'colorscheme inkpot'})
call Plug('morhetz/gruvbox', {'type': 'opt'})

call Plug('editorconfig/editorconfig-vim')
call Plug('jamessan/vim-gnupg')
call Plug('junegunn/fzf')
call Plug('junegunn/fzf.vim')
call Plug('junegunn/vim-easy-align')
call Plug('lifepillar/vim-mucomplete')
call Plug('mhinz/vim-signify')
call Plug('scrooloose/nerdtree')
call Plug('sjl/vitality.vim')
call Plug('tpope/vim-commentary')
call Plug('tpope/vim-endwise')
call Plug('tpope/vim-fugitive')
call Plug('tpope/vim-repeat')
call Plug('tpope/vim-rhubarb')
call Plug('tpope/vim-sleuth')
call Plug('tpope/vim-surround')
call Plug('tpope/vim-unimpaired')
call Plug('vim-airline/vim-airline')
call Plug('vim-airline/vim-airline-themes')
call Plug('wincent/loupe')
call Plug('wincent/terminus')
call Plug('w0rp/ale')

call Plug('LaTeX-Box-Team/LaTeX-Box')
call Plug('vhda/verilog_systemverilog.vim')
call Plug('sheerun/vim-polyglot')
call Plug('sukima/xmledit')

call Plug('lepture/vim-jinja')

call Plug('ternjs/tern_for_vim', {'do': {-> async#job#start(['npm', 'install'], {})}})

call Plug('alx741/yesod.vim')
call Plug('pbrisbin/vim-syntax-shakespeare')

if has('macunix')
  call Plug('itspriddle/vim-marked')
endif

call PlugEnd()
