#!/bin/bash

if [ ! -d $HOME/config ] ; then
  echo "Put those things into ~/config !"
  exit 1
fi

function symlink {
  [ ! -L $2 ] && ln -v -s $1 $2
}

#set -x
cd $HOME
symlink config/elisp/emacs.el .emacs
symlink config/elisp/viper.el .viper

for i in vimrc gvimrc vim cvsrc Xdefaults inputrc fluxbox gitconfig gitignore; do
  symlink config/$i .$i
done

if [ -d scripts/.svn ] ; then
    echo 'Move ~/scripts out of the way!'
fi
symlink config/scripts scripts

# xmodmap fvwm2rc

echo "Symlinks done."

xrdb -merge .Xdefaults


