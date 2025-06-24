#!/bin/bash

INTERNAL_IF="wlan0"
ROUTER_SSID="hibiki"
ROUTER_PASS="Maruh1b1k1"
WIFI_SSID="hibiki"
WIFI_PASS="Maruh1b1k1"

connect_wifi () {
	wlx_iface=$(/usr/sbin/ip -o link show | grep "wlx" | awk -F': ' '{print $2}')
        /usr/sbin/ip link set "$INTERNAL_IF" down
	/usr/sbin/ip link set "$wlx_iface" up
	/usr/bin/nmcli connection add type wifi con-name orca_wifi ifname $wlx_iface ssid $ROUTER_SSID
	/usr/bin/nmcli connection modify orca_wifi wifi-sec.key-mgmt wpa-psk wifi-sec.psk $ROUTER_PASS
	/usr/bin/nmcli connection modify orca_wifi ipv4.method manual\
		ipv4.address 192.168.1.114/24\
		ipv4.gateway 192.168.1.255\
		ipv4.dns 8.8.8.8
	/usr/bin/nmcli connection up orca_wifi
}

test_func () {
    echo "hello world"
}

if [ "$1" = "add" ]; then
        logger "[udev] wifi dongle detected (0411:029b)"
	connect_wifi
	logger "[udev] wifi dongle enabled"
	sudo systemctl start led_pink.service

elif [ "$1" = "remove" ]; then
	logger "[udev] wifi dongle remove detected. enable internal Wifi ($INTERNAL_IF)"
	/usr/sbin/ip link set "$INTERNAL_IF" up
        /usr/bin/nmcli device wifi connect $WIFI_SSID password $WIFI_PASS
	sudo systemctl start led_yellow.service

elif [ "$1" = "external" ]; then
        logger "[udev] wifi dongle detected (0411:029b)"
        connect_wifi
	logger "[udev] wifi dongle enabled"
	
elif [ "$1" = "internal" ]; then
	logger "[udev] wifi dongle not detected. enable internal Wifi ($INTERNAL_IF)"
	/usr/sbin/ip link set "$INTERNAL_IF" up
        /usr/bin/nmcli device wifi connect $WIFI_SSID password $WIFI_PASS

fi
