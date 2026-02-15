# Dotfiles

An opinionated set of configuration files. My personal focus is on minimalism. These dotfiles focus on the main tools I use:

- vim
- kitty
- zsh + prompt
- X + awesome

Everything in etc and bin is symlinked to $HOME. The directory structure is replicated as is. Thats it. No fancy dependencies, no npm install 432GB worth of JavaScript.

Tailored towards my NixOS configuration: https://github.com/seichelbaum/nixos

## Setup

```sh
cd ~
git clone git@github.com:seichelbaum/dotfiles.git .dotfiles
cd .dotfiles
./update
```

## Adding a config

```sh
# Go to the dotfile dir
cd .dotfiles/etc
# Create or copy the config somewhere
vim .someconfig
# Go to the dotfile root again and update all symlinks
cd ~/.dotfiles
./update
```

## Removing a config

```sh
# Go to the dotfile dir
cd .dotfiles/etc
# Remove the file/dir
rm .someconfig
# Go to the dotfile root again and update all symlinks
cd ~/.dotfiles
./update
# -> It will tell you which symlinks are now broken.
# You can remove them or leave them as they are.
```
