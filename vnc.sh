
function move(){
	rm ~/.vnc/xstartup
	cp ~/.config/vnctui/man/$one ~/.vnc/xstartup
	manager=$one
	echo "$manager" > ~/.config/vnctui/current
}
function prompt(){
	echo
	
	if [ -z $name ]; then
		read -p "Name Of Manager: " name
	fi
	one=$name
	move
}

function check(){
	clear
	header
	echo "XSTARTUP;"
	echo
	cat ~/.vnc/xstartup
	echo
	if [ -z "$by" ]; then
		read -p "correct? [y/N] : " test
	else
		test="$by"
	fi
	echo
	if [ "$test" = "y" ]; then
		echo "approved to start"
		vncserver
		echo "or connect to http://s.loglot.co.in:6082/vnc.html on a browser"
		echo
	elif [ "$test" = "n" ]; then
		echo "denied start"
	else
		echo "try again"
		check
	fi

}
function create(){
	echo
	if [ -z $name ]; then
		read -p "Name Of Manager: " name
	fi
	cp ~/.config/vnctui/default ~/.config/vnctui/man/$name
	nano ~/.config/vnctui/man/$name
	list=$(ls ~/.config/vnctui/man|tr -t '\n' ', ')
}
function clone(){
	echo
	if [ -z $name ]; then
		read -p "Name Of Manager: " name
	fi
	cp ~/.vnc/xstartup ~/.config/vnctui/man/$name
	list=$(ls ~/.config/vnctui/man|tr -t '\n' ', ')
	manager=$name
	echo "$manager" > ~/.config/vnctui/current
}
function remove(){
	echo
	if [ -z $name ]; then
		read -p "Name Of Manager: " name
	fi
	rm ~/.config/vnctui/man/$name
	list=$(ls ~/.config/vnctui/man|tr -t '\n' ', ')
}
function managers(){
	input=""
	input2=""
	if [ -n "$manin" ]; then
		IFS=" " read -r input input2 <<< "$manin"
	fi
	if [ -z "$manin" ]; then

		clear
		header
		echo "Manager Handler;"
		echo
		echo "[CH] Change VNC Manager"
		echo "[R] Read VNC Manager"
		echo "[DEL] Delete VNC Manager"
		echo "[C] Create VNC Manager"
		echo "[MOD] Modify Current VNC Manager"
		echo "[MODDEF] Modify Default VNC Manager"
		echo "[CL] Clone Current VNC Manager"
		echo "[X] Return To Main Window"
		if [ -z "$list" ]; then
			echo 
			echo "Warning: No Manager Found"
			echo "   Please Create A VNC Manager With [C]" 
		elif [ -z "$manager" ]; then
			echo 
			echo "Warning: No Manager Selected"
			echo "   Please Change To A VNC Manager With [CH]" 
		fi
		if [ -n "$diffy" ]; then
			echo 
			echo "Info: ~/.vnc/xstartup doesn't match current manager"
			echo "   you can resolve by changing the manager [CH]"
			echo "   or by cloning the current setup [CL]" 
		fi
		echo
		IFS=" " read -p "Select: " input input2
	fi

	if [ "$input" = "CH" -o "$input" = "ch" ]; then
		name="$input2"
		prompt
		name=""
	elif [ "$input" = "r" -o "$input" = "R" ]; then
		echo
		cat ~/.vnc/xstartup
		echo
		read -p ":"
	elif [ "$input" = "MODDEF" -o "$input" = "moddef" ]; then
		nano ~/.config/vnctui/default
	elif [ "$input" = "MOD" -o "$input" = "mod" ]; then
		nano ~/.config/vnctui/man/$manager
		rm ~/.vnc/xstartup
		cp ~/.config/vnctui/man/$manager ~/.vnc/xstartup
	elif [ "$input" = "C" -o "$input" = "c" ]; then
		name="$input2"
		create
		name=""
	elif [ "$input" = "CL" -o "$input" = "cl" ]; then
		name="$input2"
		clone
		name=""
	elif [ "$input" = "DEL" -o "$input" = "del" ]; then
		name="$input2"
		remove
		name=""
	elif [ "$input" = "X" -o "$input" = "x" ]; then
		echo "freedom"
		return
	fi
	if [ -z "$manin" ]; then
		managers
	fi

}
function download(){
	echo
	echo
	echo "git clone https://github.com/loglot/VNC-TUI.git"
	echo
	git clone https://github.com/loglot/VNC-TUI.git
	echo
	if [ "$0" = "/usr/bin/vnctui" ]; then
		echo "sudo rm $0"
		sudo rm $0
		echo
		echo "sudo cp ./VNC-TUI/vnc.sh $0"
		sudo cp ./VNC-TUI/vnc.sh $0
		echo
	else
		echo "rm $0"
		rm $0
		echo
		echo "cp ./VNC-TUI/vnc.sh $0"
		cp ./VNC-TUI/vnc.sh $0
		echo
		if [ -e /usr/bin/vnctui ]; then
			echo "sudo rm /usr/bin/vnctui"
			sudo rm /usr/bin/vnctui
			echo
			echo "sudo cp ./VNC-TUI/vnc.sh /usr/bin/vnctui"
			sudo cp ./VNC-TUI/vnc.sh /usr/bin/vnctui
			echo
		else
			echo "not installing globaly, as it isn't currently installed globally"
			echo
		fi
	fi
	echo "yes | rm -r VNC-TUI"
	yes | rm -r VNC-TUI
	echo
	echo "done"
	echo "restart $0 for changes to take effect"
	echo
	read -p ": "
}
function misc(){
	input=""
	input2=""
	if [ -n "$manin" ]; then
		IFS=" " read -r input input2 <<< "$manin"
	fi
	if [ -z "$manin" ]; then

		header
		echo "All The Other Stuff;"
		echo
		echo "[INSTALL] Reinstall vnctui"
		echo "[UPDATE] Update vnctui"
		echo "[CONFIG] ReMake Config Skelaton"
		echo "[X] Return To Main Window"
		echo
		IFS=" " read -p "Select: " input input2
	fi

	if [ "$input" = "INSTALL" -o "$input" = "install" ]; then
		install
	elif [ "$input" = "CONFIG" -o "$input" = "config" ]; then
		makeConf
	elif [ "$input" = "UPDATE" -o "$input" = "update" ]; then
		download
	elif [ "$input" = "X" -o "$input" = "x" ]; then
		echo "freedom"
		return
	fi
	if [ -z "$manin" ]; then
		misc
	fi

}
function header(){
	diffy=$(diff ~/.vnc/xstartup ~/.config/vnctui/man/$manager)
	clear
	echo "---------------------------------------------"
	echo
	if [ -z "$diffy" ]; then
		echo "Current Manager: $manager"
	else
		echo "Current Manager: $manager ???"
	fi
	echo "Existing Managers: $list"
	echo
	echo "---------------------------------------------"
	echo
}

function vnch(){
	input=""
	input2=""
	if [ -n "$manin" ]; then
		IFS=" " read -r input input2 <<< "$manin"
	fi
	clear
	header
	echo "VNC Handler;"
	echo
	echo "[STA] Start VNC"
	echo "[STO] Stop VNC"
	echo "[RE] Restart VNC"
	echo "[X] Return To Main Window"
	echo
	if [ -z "$manin" ]; then
		IFS=" " read -p "Select: " input input2
	fi

	if [ "$input" = "STA" -o "$input" = "sta" ]; then
		by="$input2"
		check
	elif [ "$input" = "STO" -o "$input" = "sto" ]; then
		vncserver -kill :1
		echo
		by=""
	elif [ "$input" = "RE" -o "$input" = "re" ]; then
		by="$input2"
		vncserver -kill :1
		check
		echo
		by=""
	elif [ "$input" = "X" -o "$input" = "x" ]; then
		echo "freedom"
		return
	fi
	if [ -z "$manin" ]; then
		vnch
	fi

}

function default(){
	clear
	header
	input=""
	input2=""
	input3=""
	echo "Welcome To The VNC TUI;"
	echo 
	echo "[V] VNC Handler"
	echo "[M] Manager Handler"
	echo "[MISC] Miscalanious"
	echo "[X] Exit"

	if [ -z "$manager" ]; then
		echo 
		echo "Warning: No Manager Selected"
		echo "   Go To The Manager Handler To Resolve" 
	fi
	echo
	IFS=" " read -p "Select: " input input2 input3
	if [ "$input" = "V" -o "$input" = "v" ]; then
		if [ -n "$input2" ]; then
			manin="$input2 $input3"
		fi
		vnch
		manin=""
	elif [ "$input" = "M" -o "$input" = "m" ]; then
		if [ -n "$input2" ]; then
			manin="$input2 $input3"
		fi
		managers
		manin=""
	elif [ "$input" = "MISC" -o "$input" = "misc" ]; then
		if [ -n "$input2" ]; then
			manin="$input2 $input3"
		fi
		misc
		manin=""
	elif [ "$input" = "X" -o "$input" = "x" ]; then
		echo
		return
	fi
	default

}
function makeConf(){
	read -p "Make Skeleton? [Y/n] : " skelmake
	if [ "$skelmake" = "y" -o "$skelmake" = "Y" ]; then
		rm -r ~/.config/vnctui/
		echo
		echo "Making Base ['.config/vnctui'] Folder"
		mkdir ~/.config/vnctui/
		echo "Making ['current'] file"
		touch ~/.config/vnctui/current
		echo "Making ['default'] file"
		printf "#!/bin/bash\n# Start Command For Manager\n" > ~/.config/vnctui/default
		echo "Making Manager ['man'] folder"
		mkdir ~/.config/vnctui/man
		echo
		echo "FileTree;"
		echo ".config/"
		echo "    vnctui/"
		echo "        current"
		echo "        default"
		echo "        man/"
		echo
		
		echo Done

	else
		echo "Warning, Continuing in Broken State"
	fi
	echo
	read -p ": "
list=$(ls ~/.config/vnctui/man|tr -t '\n' ', ') 
manager=$(cat ~/.config/vnctui/current)
}
function install(){
	echo
	echo Command To Be Run:
	echo sudo cp $0 /usr/bin/vnctui
	echo
	echo You Could Also Just Run The Above Command Yourself
	echo "[I] Stops This From Showing On Startup"
	echo
	read -p "[Y/n/i] : " install
	echo
	if [ "$install" = "y" -o "$install" = "Y" ]; then
		echo "Removing If Already Installed;"
		echo "sudo rm /usr/bin/vnctui"
		sudo rm /usr/bin/vnctui
		echo "Installing;"
		echo "sudo cp $0 /usr/bin/vnctui"
		sudo cp $0 /usr/bin/vnctui
		echo "Installed!"
		echo "Can Now Be Run With 'vnctui' anywhere"
	else
		echo
	fi
	echo
	read -p ": "
}


clear
if [ -d ~/.config/vnctui/ ]; then	
	echo 
else
	echo "Warning; Config Folder Was Not Found!"
	makeConf
fi
if [ -e /usr/bin/vnctui ]; then
	echo 
else
	echo 
	echo Not Installed Globally, Do You Want To Install It?
	install

fi

list=$(ls ~/.config/vnctui/man|tr -t '\n' ', ') 
manager=$(cat ~/.config/vnctui/current)
clear
if [ "$1" = "start" ]; then
	if [ -n "$2" ]; then
		one=$2
		move
	else
		prompt
	fi

	check
else
	default
fi

