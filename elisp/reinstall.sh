#!/bin/sh

if [ ! -d $HOME/elisp ] ; then
  echo "Put those things into ~/elisp !"
  exit 1
fi

echo "This will delete your ~/.emacs and your ~/.viper!"
echo "Ctrl-C abbort, RETURN continue."
read

# well, he has been warned.
cd $HOME
rm .emacs .viper
ln -s config/elisp/emacs.el .emacs
ln -s config/elisp/viper.el .viper

echo "Symlinks done."

