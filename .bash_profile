# ~/.bash_profile: executed by bash(1) for login shells.
# 	$Id: .bash_profile,v 1.2 2000/04/24 20:08:20 richardc Exp $	

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -d ~/bin ] ; then
    PATH="~/bin:${PATH}"
fi
