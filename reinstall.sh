#!/bin/sh

if [ ! -d $HOME/config ] ; then
  echo "Put those things into ~/config !"
  exit 1
fi

set -x
cd $HOME
ln -s config/elisp/emacs.el .emacs
ln -s config/elisp/viper.el .viper

#ln -s config/xmodmap .xmodmap
#ln -s config/fvwm2rc .fvwm2rc
ln -s config/vimrc .vimrc
ln -s config/vim .vim
ln -s config/cvsrc .cvsrc
ln -s config/Xdefaults .Xdefaults
echo "Symlinks done."

xrdb -merge .Xdefaults


