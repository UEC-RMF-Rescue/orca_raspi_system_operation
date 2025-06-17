#!/bin/bash

TARGET_VENDOR="0411"
TARGET_PRODUCT="029b"

if lsusb | grep -i "ID ${TARGET_VENDOR}:${TARGET_PRODUCT}" > /dev/null; then
	logger "dongle detected"
	/home/rmfrescue/sys_op/wifi_switcher.sh external
else
	logger "dongle not detected"
	/home/rmfrescue/sys_op/wifi_switcher.sh internal
fi
