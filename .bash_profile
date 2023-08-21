#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
MOZ_ENABLE_WAYLAND=1
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
