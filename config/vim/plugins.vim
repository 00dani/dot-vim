if exists('+packpath')
  silent! packadd minpac
  if !exists('g:loaded_minpac')
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
call Plug('ConradIrwin/vim-bracketed-paste')
call Plug('prabirshrestha/async.vim')

call Plug('ciaranm/inkpot', {'type': 'opt', 'do': 'colorscheme inkpot'})
call Plug('morhetz/gruvbox', {'type': 'opt'})

call Plug('direnv/direnv.vim')
call Plug('editorconfig/editorconfig-vim')
call Plug('godlygeek/tabular')
call Plug('jamessan/vim-gnupg')
call Plug('junegunn/vim-easy-align')
call Plug('lifepillar/vim-mucomplete')
call Plug('lotabout/skim')
call Plug('lotabout/skim.vim')
call Plug('mhinz/vim-signify')
call Plug('scrooloose/nerdtree')
call Plug('sjl/vitality.vim')
call Plug('tpope/vim-apathy')
call Plug('tpope/vim-commentary')
call Plug('tpope/vim-dadbod')
call Plug('tpope/vim-endwise')
call Plug('tpope/vim-eunuch')
call Plug('tpope/vim-fugitive')
call Plug('tpope/vim-repeat')
call Plug('tpope/vim-rhubarb')
call Plug('tpope/vim-sleuth')
call Plug('tpope/vim-surround')
call Plug('tpope/vim-unimpaired')

call Plug('wincent/loupe')
call Plug('wincent/terminus')
call Plug('w0rp/ale')

call Plug('vim-airline/vim-airline')
call Plug('vim-airline/vim-airline-themes')
call Plug('lambdalisue/battery.vim')

call Plug('alvan/vim-closetag')
call Plug('LaTeX-Box-Team/LaTeX-Box')
call Plug('vhda/verilog_systemverilog.vim')
call Plug('sheerun/vim-polyglot')

call Plug('eipipuz/factor.vim')

call Plug('ehamberg/vim-cute-python')
call Plug('Glench/Vim-Jinja2-Syntax')
call Plug('tweekmonster/braceless.vim')

call Plug('ternjs/tern_for_vim', {'do': {-> async#job#start(['npm', 'install'], {})}})
call Plug('vito-c/jq.vim')

call Plug('fpob/nette.vim')

if executable('task')
  call Plug('farseer90718/vim-taskwarrior')
endif

call Plug('alx741/yesod.vim')
call Plug('pbrisbin/vim-syntax-shakespeare')

if has('macunix')
  call Plug('rizzatti/dash.vim')
  " We rename this plugin to make sure it loads AFTER vim-polyglot,
  " since it won't work properly if it's loaded first.
  call Plug('itspriddle/vim-marked', {'name': 'zzvim-marked'})
endif

call PlugEnd()
