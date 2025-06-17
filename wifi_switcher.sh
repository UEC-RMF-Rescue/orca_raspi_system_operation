#!/bin/bash

INTERNAL_IF="wlan0"
ROUTER_SSID="hibiki"
ROUTER_PASS="Maruh1b1k1"
WIFI_SSID="hibiki"
WIFI_PASS="Maruh1b1k1"

if [ "$1" = "add" ]; then
        logger "[udev] wifi dongle detected (0411:029b)"
	wlx_iface=$(/usr/sbin/ip -o link show | grep "wlx" | awk -F': ' '{print $2}')
	/usr/sbin/ip link set "$INTERNAL_IF" down
	/usr/sbin/ip link set "$wlx_iface" up
        /usr/bin/nmcli device wifi connect $ROUTER_SSID password $ROUTER_PASS
	logger "[udev] wifi dongle enabled ($wlx_iface)"
	sudo systemctl start led_pink.service

elif [ "$1" = "remove" ]; then
	logger "[udev] wifi dongle remove detected. enable internal Wifi ($INTERNAL_IF)"
	/usr/sbin/ip link set "$INTERNAL_IF" up
        /usr/bin/nmcli device wifi connect $WIFI_SSID password $WIFI_PASS
	sudo systemctl start led_yellow.service

elif [ "$1" = "external" ]; then
        logger "[udev] wifi dongle detected (0411:029b)"
	wlx_iface=$(/usr/sbin/ip -o link show | grep "wlx" | awk -F': ' '{print $2}')
	/usr/sbin/ip link set "$INTERNAL_IF" down
	/usr/sbin/ip link set "$wlx_iface" up
        /usr/bin/nmcli device wifi connect $ROUTER_SSID password $ROUTER_PASS
	logger "[udev] wifi dongle enabled ($wlx_iface)"
	
elif [ "$1" = "internal" ]; then
	logger "[udev] wifi dongle not detected. enable internal Wifi ($INTERNAL_IF)"
	/usr/sbin/ip link set "$INTERNAL_IF" up
        /usr/bin/nmcli device wifi connect $WIFI_SSID password $WIFI_PASS

fi
