# 	$Id$	
xrdb $HOME/.Xdefaults &
#xscreensaver &
#xmodmap ~/.xmodmap-`uname -n`
#exec wmaker
gkrellm2 &
#exec gnome-session
xterm &
treewm
while
	xmessage 'Restart TreeWM?' -buttons Yes:0,No:1 -nearmouse;
do
        treewm;
done
