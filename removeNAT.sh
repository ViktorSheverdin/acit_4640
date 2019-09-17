#!/bin/bash -x
vboxmanager () { VBoxManage.exe "$@"; }
for network in $(vboxmanager natnetwork list)
do
	echo $network
	#vboxmanager natnetworks remove --netname=$network
done

