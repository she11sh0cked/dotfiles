export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
        git
	sudo
	colored-man-pages
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
