# VNC TUI
as i don't see any others currently existing

this is made to be a decent tui for remote clients when you have multiple desktop environments / window managers

# INSTALLATION
run
```sh
git clone https://github.com/loglot/VNC-TUI.git
./VNC-TUI/vnc.sh
```
this will prompt you to make the config folder, and will also prompt global installation if it isn't, if you do the global installation, you can run `vnctui` to open it

# Features
- Starting and Stopping VNC Servers
- creating multiple startup profiles (managers)
- easily switching between startup profiles

# Example
say you have i3wm and openbox installed on your system, and you want to start a vnc server with one of them
you would run 
```
vnctui
Select: m c i3          # put i3 in the nano window that opens
Select: m c openbox     # put openbox-session in the nano window that opens
Select: m ch i3         # to change to i3wm
Select: m ch openbox    # to change to openbox
Select: m del i3        # to delete the i3 manager
Select: v sta           # start after approval
Select: v sta y         # start without approval
```

# End
this is my first time making any form of public open source non game, so contributions are welcome!
