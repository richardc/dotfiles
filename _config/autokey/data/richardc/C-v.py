terminals = [ 'terminator.Terminator', 'gnome-terminal.Gnome-terminal' ]
winClass = window.get_active_class()
if winClass in terminals:
    keyboard.send_keys('<ctrl>+<shift>+v')
else:
    keyboard.send_keys('<ctrl>+v')
