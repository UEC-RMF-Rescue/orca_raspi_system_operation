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
		ros2 launch $ROS_PACKAGE_NAME $LAUNCH_FILE &
		# /home/rmfrescue/sys_op/led_control.sh red
		echo "enable" | tee /tmp/orca_state
		;;
	stop)
		# /home/rmfrescue/sys_op/led_control.sh white
		echo "Stopping ORCA..." | tee -a $ROS_LOG
		while pgrep -f orca > /dev/null; do
			pkill -f orca
			sleep 1
		done
		echo "disable" | tee /tmp/orca_state
		;;
	restart)
		$0 stop
		$0 start
		;;
	flip)
		if [ -f /tmp/orca_state ]; then
			ORCA_STATE=$(cat /tmp/orca_state)
		else
			echo "disable" | tee /tmp/orca_state
		fi

		if [ "$ORCA_STATE" = "enable" ]; then
			$0 stop
		elif [ "$ORCA_STATE" = disable ]; then
			$0 start
		else
			$0 stop
		fi
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
		;;
esac
