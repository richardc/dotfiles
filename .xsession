# 	$Id: .xsession,v 1.3 2000/04/24 20:10:40 richardc Exp $	

xrdb $HOME/.Xdefaults &
xscreensaver &
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"
exec wmaker
