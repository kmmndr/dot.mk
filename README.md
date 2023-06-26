# dot.mk

Simple tool to handle dot files

## Requirements

- make (tested using gnu-make)
- a git repository containing your dotfiles

## Installation

Clone repository, then install using make

```
# installation
env PREFIX=~/.local make install

# uninstallation
env PREFIX=~/.local make uninstall
```

## Usage

Get help by starting without arguments (or `dot.mk help`)

```
$ dot.mk
Usage: make <target> (see target list below)

help: Show this help (default)
init: Initialize dotfiles
pull: Pull changes from repository
push: Push changes from repository
shell: Start dotfiles shell
tig: Start tig
hide-untracked: Hide untracked files
show-untracked: Show untracked files
```
