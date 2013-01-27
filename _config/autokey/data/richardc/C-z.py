terminals = [ 'terminator.Terminator', 'gnome-terminal.Gnome-terminal' ]
winClass = window.get_active_class()
if winClass in terminals:
    # no undo in terminals, so pass
    pass
else:
    keyboard.send_keys('<ctrl>+z')
