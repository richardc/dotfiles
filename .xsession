# 	$Id: .xsession,v 1.4 2001/08/12 01:48:06 richardc Exp $	

xrdb $HOME/.Xdefaults &
xscreensaver &
#xmodmap -e "remove Lock = Caps_Lock"
#xmodmap -e "remove Mod1 = Alt_R"
#xmodmap -e "keysym Caps_Lock = Control_L"
#xmodmap -e "keysym 0x73 = Alt_L"
#xmodmap -e "add Control = Control_L"
#xmodmap -e "add Mod1 = Alt_L"
xmodmap ~/.xmodmap-`uname -n`
exec wmaker
