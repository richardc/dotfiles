SublimeText2 puts all its user confuguration into the User package, which you
just edit as JSON files.

To make use of this symlink the Users module into ~/Library/Application
Support/Sublime Text 2/Packages/User on OSX then install Package Control which
will make sure you have the Plugins listed in the state file.

This approach is based on http://mwunsch.tumblr.com/post/15742953582/sublime-
text-2-user-settings-and-version-control rather than the other guides that
suggest punting most of  ~/Library/Application Support/Sublime Text 2 into
Dropbox.  That's way too much to VCS.
