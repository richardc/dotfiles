# 	$Id: .xsession,v 1.5 2001/08/12 01:55:14 richardc Exp $	

xrdb $HOME/.Xdefaults &
xscreensaver &
xmodmap ~/.xmodmap-`uname -n`
exec wmaker
