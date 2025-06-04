#!/bin/bash

case "$1" in
	red)
		sudo python3 /home/rmfrescue/sys_op/set_led.py 255 0 0
		;;
	green)
		sudo python3 /home/rmfrescue/sys_op/set_led.py 0 255 0
		;;
	blue)
		sudo python3 /home/rmfrescue/sys_op/set_led.py 0 0 255
		;;
	white)
		sudo python3 /home/rmfrescue/sys_op/set_led.py 255 255 255
		;;
	off)
		sudo python3 /home/rmfrescue/sys_op/set_led.py 0 0 0
		;;
	*)
	        sudo pkill -f led	
		echo "Usage: $0 {red|blue|green|white|off}"
		exit 1
		;;
esac
