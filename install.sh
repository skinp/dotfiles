#!/bin/bash

declare -A FILEMAP

FILEMAP["tmux.conf"]="$HOME/.tmux.conf"
FILEMAP["gitconfig"]="$HOME/.gitconfig"
FILEMAP["pythonrc.py"]="$HOME/.pythonrc.py"
FILEMAP["editorconfig"]="$HOME/.editorconfig"
FILEMAP["vimrc"]="$HOME/.vimrc"

function diff_and_copy {
    local src="$1"
    local dst="$2"

    if [[ ! -f "$dst" ]]; then
        cp -f "$src" "$dst"
        return
    fi

    diff "$src" "$dst" > /dev/null 2>&1
    local rc=$?
    if (( $rc != 0 )); then
        diff "$src" "$dst"
        echo -n "Looks good? "; read line
        if [[ "$line" == "yes" || "$line" == "Y" || "$line" == "y" ]]; then
            cp -f "$src" "$dst"
        fi
    fi
}

for file in "${!FILEMAP[@]}"; do
    diff_and_copy "$file" "${FILEMAP[$file]}"
done

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    curl -sfLo $HOME/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugUpgrade +PlugUpdate +PlugClean +qall

# Disable login message from SSH
touch ~/.hushlogin
