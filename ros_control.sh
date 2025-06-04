#!/bin/bash
case "$1" in
	start)
		sudo systemctl start orca_launch.service
		sudo systemctl start led_red.service
		;;
	stop)
		sudo systemctl start led_white.service
                sudo systemctl stop orca_launch.service	
		;;
esac
