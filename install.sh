#!/bin/bash

mkdir -p ~/.vim/bundle
test -d ~/.vim/bundle/vundle || git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
cp vimrc ~/.vimrc
vim +BundleInstall +qall

cp tmux.conf ~/.tmux.conf
cp gitconfig ~/.gitconfig
cp pythonrc.py ~/.pythonrc.py
