terminals = [ 'terminator.Terminator', 'gnome-terminal.Gnome-terminal' ]
winClass = window.get_active_class()
if winClass in terminals:
    # no cut in terminals, so copy
    keyboard.send_keys('<ctrl>+<shift>+c')
else:
    keyboard.send_keys('<ctrl>+x')
