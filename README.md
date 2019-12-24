# My dotfiles, managed by stow

New installation installing all configs:

    git submodule update --init
    stow -v -R $(ls | grep -v README.md)
    vim +PlugUpgrade +PlugUpdate +PlugClean +qall

To install specific config "packages":

    stow -v vim git [...]

We have some git submodules in here, to keep them up to date:

    git submodule update --remote
