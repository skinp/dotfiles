# My dotfiles, managed by stow

New installation installing all configs:

    git submodule update --init
    stow -v -R $(ls | grep -v -e README.md -e herdr)
    stow -v -R --no-folding herdr   # see "Tree folding" below

To install specific config "packages":

    stow -v vim git [...]

We have some git submodules in here, to keep them up to date:

    git submodule update --remote

## Tree folding (`--no-folding`)

By default stow is lazy: if a target directory doesn't exist yet, it links the
whole package directory with a single symlink ("tree folding"). If the target
dir already exists, it descends and symlinks individual files instead.

Use `--no-folding` when an app **writes into** the directory we manage, so stow
creates a real directory and symlinks only our files. Without it, stow may fold
the whole dir into one symlink pointing back here, and the app's generated
state lands inside this repo.

- **herdr** — use `--no-folding`. herdr treats `~/.config/herdr/` as a working
  directory (agent-detection overrides, runtime state), so we only want
  `config.toml` symlinked, not the whole folder aliased into the repo.

  ```
  rm -f ~/.config/herdr/config.toml   # remove any pre-existing real file first
  stow -v -R --no-folding herdr
  ```

- **hammerspoon, vim, and other submodule packages** — keep folding (the
  default; do *not* pass `--no-folding`). These bundle git submodules, and
  folding means the target is just a pointer to the whole dir: after
  `git submodule update` any new/removed files appear automatically. With
  `--no-folding` each file is symlinked individually, so a submodule update that
  adds files requires a re-stow to pick them up.
