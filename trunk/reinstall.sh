#!/bin/sh

if [ ! -d ~/elisp ] ; then
  echo "Put those things into ~/elisp !"
  exit 1
fi

echo "This will delete your ~/.emacs and your ~/.viper!"
echo "Ctrl-C abbort, RETURN continue."
read i

# well, he has been warned.
cd ~
rm .emacs .viper
ln -s elisp/emacs.el .emacs
ln -s elisp/viper.el .viper

echo "Symlinks done."

