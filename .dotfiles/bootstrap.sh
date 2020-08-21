#!/bin/sh

os=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed -e 's/"\|GNU\|\/\|Linux//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
hasApt=$(which apt)

echo "> updating system\n"
if [ "$hasApt" ]; then
	sudo apt update
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
fi

echo "> installing dependencies\n"
if [ "$hasApt" ]; then
	sudo apt install curl git -y
fi

echo "> installing zsh\n"
if [ "$hasApt" ]; then
	sudo apt install zsh -y
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --keep-zshrc"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "> installing vim\n"
if [ "$hasApt" ]; then
	sudo apt install neovim -y
fi
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "> setting default shell\n"
chsh -s $(which zsh)

echo "> setting permissions\n"
sudo chmod -R 755 ~/.oh-my-zsh

echo "> launching zsh\n"
zsh -l
