#!/bin/sh

mkdir ~/Repositories
cd ~/Repositories

repositories=(
    https://git.suckless.org/dmenu
    https://github.com/borinskikh/dot-files
    https://github.com/borinskikh/book-creator
    https://github.com/borinskikh/new-tab-bookmarks
    https://github.com/borinskikh/notes
)

for repository in "${repositories[@]}"
doz
    git clone $repository
done