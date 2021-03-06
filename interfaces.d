
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto enp0s25
allow-hotplug enp0s25
iface enp0s25 inet dhcp

auto wlp3s0
allow-hotplug wlp3s0
iface wlp3s0 inet dhcp
    wpa-ssid {SSID}
    wpa-psk  <WIFI PASSWPORD}
 pre-up ip link add name vmbr0 address 00:1e:65:22:00:94 type bridge stp_state 0 forward_delay 0 mcast_snooping 0 mcast_router 0
 pre-up ip link add name vmbr0p1 address 00:1e:65:22:00:94 master vmbr0 type veth peer name wlp3s0mirred
 pre-up ip link add name vmbr0 address 00:1e:65:22:00:94 type bridge stp_state 0 forward_delay 0 mcast_snooping 0 mcast_router 0
 pre-up sysctl -w net.ipv6.conf.vmbr0p1.disable_ipv6=1
 pre-up sysctl -w net.ipv6.conf.wlp3s0mirred.disable_ipv6=1
 pre-up sysctl -w net.ipv6.conf. wlp3s0.disable_ipv6=1 #1st bullet should already have done this one
 pre-up ip link set dev wlp3s0 arp off
 pre-up ip link set dev wlp3s0mirred arp off
 pre-up ip link set dev vmbr0p1 arp off


auto vmbr0
iface vmbr0 inet static
        address 10.110.100.7/24
        gateway 10.110.100.1
        bridge-ports vmbr0p1
        stp_state 0
        forward_delay 0
        mcast_snooping 0
        mcast_router 0

up tc qdisc add dev wlp3s0 ingress
up tc filter add dev wlp3s0 ingress pref 1 protocol 0x888e matchall action pass
up tc filter add dev wlp3s0 ingress pref 2 matchall action mirred egress redirect dev wlp4s0mirred
up ip link set dev vmbr0p1 up
up ip link set dev wlp3s0mirred up
up ip link set dev vmbr0 up
