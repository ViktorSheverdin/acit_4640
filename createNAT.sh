#!bin/bash -x

vboxmanager natnetwork add --netname net_4640 --network 192.168.250.0/24 --enable --dhcp off --ipv6 off --port-forward-4 "ssh:tcp:[]:50022:[192.168.250.10]:22" --port-forward-4 "http:tcp:[]:50080:[192.168.250.10]:80" --port-forward-4 "https:tcp:[]:50443:[192.168.250.10]:443"
