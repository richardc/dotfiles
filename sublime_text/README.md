SublimeText2 puts all its user configuration into the User package, which you
just edit as JSON files.  This directory contains the Users package, to make
use of it install Package Control and link into:

	~/Library/Application Support/Sublime Text 2/Packages # OSX
	~/.config/sublime-text-2/Packages # Linux

This approach is based on http://mwunsch.tumblr.com/post/15742953582/sublime-
text-2-user-settings-and-version-control rather than the other guides that
suggest punting most of  ~/Library/Application Support/Sublime Text 2 into
Dropbox.  That's way too much to VCS.
