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

#symlink config/elisp/emacs.el .emacs
test -h .emacs && rm .emacs # switched to spacemacs
test -h .viper && rm .viper

mkdir -p .config/matplotlib
symlink ../../config/matplotlibrc .config/matplotlib/matplotlibrc

for i in vimrc gvimrc vim cvsrc Xdefaults fluxbox gitconfig gitignore ignore wmii-3.5 pylintrc wcalc_preload spacemacs.d tmux.conf; do
  test -r config/$i || echo config/$i does not exist
  symlink config/$i .$i
done

mkdir -p ~/.config/nvim
symlink ~/config/vimrc ~/.config/nvim/init.vim

symlink ~/config/flake8 ~/.config/flake8

mkdir -p ~/.ipython/profile_default/startup
symlink ~/config/ipython-startup/60-import-stuff.py ~/.ipython/profile_default/startup/60-import-stuff.py

if [ -d scripts/.svn ] ; then
    echo 'Move ~/scripts out of the way!'
fi
symlink config/scripts scripts

# xmodmap fvwm2rc

echo "Symlinks done."

xrdb -merge .Xresources >/dev/null 2>&1
#xrdb .Xresources >/dev/null 2>&1

if ! grep bashrc.common ~/.bashrc >/dev/null; then
    echo "source ~/config/bashrc.common" >> ~/.bashrc
fi
perl -p -i -e 's/bash_completion /bash_completion_disabled /g' ~/.bashrc

# test -h .Xdefaults && rm .Xdefaults # replaced by Xdefaults
test -h .Xresources && rm .Xresources # nope
test -h .inputrc && rm .inputrc # use system-wide file

mkdir -p .config/git
symlink ../../config/gitignore .config/git/ignore

if ! grep -q -s spacemacs .emacs.d/.git/config ; then
    echo
    echo "Spacemacs:"
    [ -r .emacs.d ] && echo "  move ~/.emacs.d out ouf the way"
    echo "  git clone --branch develop https://github.com/syl20bnr/spacemacs ~/.emacs.d"
fi

if ! dpkg -l dconf-editor > /dev/null ; then
  echo "TODO:"
  echo "sudo apt-get install dconf-editor"
fi

# make gnome3 visual bell less annoying
gsettings set org.gnome.desktop.wm.preferences audible-bell false  || true
gsettings set org.gnome.desktop.wm.preferences visual-bell true  || true
gsettings set org.gnome.desktop.wm.preferences visual-bell-type frame-flash  || true

gsettings set org.pantheon.desktop.gala.behavior dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

gsettings set org.gnome.desktop.background show-desktop-icons false

dconf write /org/gnome/mutter/workspaces-only-on-primary false
dconf write /org/gnome/shell/overrides/workspaces-only-on-primary false

echo 
echo "Done."

echo -n ".gitconfig email: "
grep email\ = ~/.gitconfig | sed -e 's/.*=.//'

