#!/bin/bash

ROS_PACKAGE_NAME=orca_robot_control
LAUNCH_FILE=orca.launch.py
ROS_LOG=/home/rmfrescue/sys_op/ros_log.txt

case "$1" in
	start)
		echo "Starting ORCA..." | tee -a $ROS_LOG
		source /opt/ros/humble/setup.bash
		source /home/rmfrescue/ORCA/install/local_setup.bash
		source /home/rmfrescue/ORCA/install_rpi/local_setup.bash
		echo "255,0,0" | sudo tee /tmp/led_fifo
		ros2 launch $ROS_PACKAGE_NAME $LAUNCH_FILE &
		;;
	stop)
		echo "255,255,255" | sudo tee /tmp/led_fifo
		echo "Stopping ORCA..." | tee -a $ROS_LOG
		while pgrep -f orca > /dev/null; do
			pkill -f orca
			sleep 1
		done
		;;
	restart)
		$0 stop
		$0 start
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
		;;
esac
