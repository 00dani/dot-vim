set runtimepath+=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim,$XDG_CONFIG_HOME/vim/after,$XDG_CACHE_HOME/vim/after
if exists('+packpath')
  set packpath^=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim
endif
source $XDG_CONFIG_HOME/vim/vimrc
