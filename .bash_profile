# ~/.bash_profile: executed by bash(1) for login shells.
# 	$Id$	

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -d ~/bin ] ; then
    PATH="~/bin:${PATH}"
fi
