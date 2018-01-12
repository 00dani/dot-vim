for [s:var, s:value] in items({'XDG_CONFIG_HOME': '~/.config', 'XDG_CACHE_HOME': '~/.cache', 'XDG_DATA_HOME': '~/.local/share'})
  if (empty(eval('$' . s:var)))
    exec 'let $' . s:var . ' = expand(s:value)'
  endif
endfor

set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$XDG_CONFIG_HOME/vim/after,$XDG_CACHE_HOME/vim/after
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
if exists('+packpath')
  set packpath^=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim
endif
let g:netrw_home = $XDG_CACHE_HOME . '/vim/netrw'

let $MYVIMRC = $XDG_CONFIG_HOME . '/vim/vimrc'
source $MYVIMRC
