# My dotfiles, managed by stow

To install specific config "packages":

  git submodule update --init
  stow -v vim git [...]

We have some git submodules in here, to keep them up to date:

  git submodule update --remote
