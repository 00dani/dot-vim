for [var, value] in items({'XDG_CONFIG_HOME': '~/.config', 'XDG_CACHE_HOME': '~/.cache', 'XDG_DATA_HOME': '~/.local/share'})
  if (empty(eval('$' . var)))
    exec 'let $' . var . ' = expand(value)'
  endif
endfor

set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$XDG_CONFIG_HOME/vim/after,$XDG_CACHE_HOME/vim/after
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
let g:netrw_home = $XDG_CACHE_HOME . '/netrw'

source $XDG_CONFIG_HOME/vim/vimrc
let $MYVIMRC = $XDG_CONFIG_HOME . '/vim/vimrc'
