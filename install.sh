#!/bin/bash

mkdir -p ~/.vim/bundle
test -d ~/.vim/bundle/Vundle.vim || git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
cp vimrc ~/.vimrc
vim +PluginInstall +qall

cp tmux.conf ~/.tmux.conf
cp gitconfig ~/.gitconfig
cp pythonrc.py ~/.pythonrc.py
