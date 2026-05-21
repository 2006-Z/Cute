#!/bin/bash
printf "\n🌸 Installing Cute...\n\n"
read -p "Her nickname: " name1
read -p "Your nickname: " name2
sudo apt update
sudo apt install -y zsh curl git lolcat bat eza tldr
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    ~/.zsh/zsh-autosuggestions
cp cute.zsh ~/.zshrc
sed -i "s/__NAME1__/$name1/g" ~/.zshrc
sed -i "s/__NAME2__/$name2/g" ~/.zshrc
printf "\n✨ Cute installed successfully!\n\n"
printf "Restart terminal or run:\n"
printf "source ~/.zshrc\n\n"