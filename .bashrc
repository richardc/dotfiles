# ~/.bashrc: executed by bash(1) for non-login shells.
# 	$Id: .bashrc,v 1.2 2000/04/24 20:07:28 richardc Exp $	

umask 002
export CVSUMASK=002
export PILOTRATE=38400

# are we interactive?
if [ "$PS1" ]; then
	export CVSROOT=':pserver:richardc@china.tw2.com:/home/cvs/repository'
	mesg n
	stty -ixon

	# fooking debian
	if [ "$TERM" = "xterm-debian" ]; then
        	export TERM="xterm"
	fi
	PS1='\u@\h:\w\$ '
	if [ "$TERM" = "xterm" ]; then
		export PS1='\[\033]0;\u@\h:\w\007\]\u@\h:\w\$ '
	fi
fi
