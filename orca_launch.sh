#!/bin/bash
# sudo systemctl start led_white.service
source /opt/ros/humble/setup.bash
source /home/rmfrescue/ORCA/install/local_setup.bash
source /home/rmfrescue/ORCA/install_rpi/local_setup.bash

ros2 launch orca_robot_control orca.launch.py
# sudo systemctl start led_red.service
