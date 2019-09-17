#!/bin/bash -x

vboxmanager () { VBoxManage.exe "$@"; }
VM_NAME="VM_ACIT4640"
NAT_NETWORK="net_4640"

vboxmanager natnetwork add --netname $NAT_NETWORK --network 192.168.250.0/24 --enable --dhcp off --ipv6 off --port-forward-4 "ssh:tcp:[]:50022:[192.168.250.10]:22" --port-forward-4 "http:tcp:[]:50080:[192.168.250.10]:80" --port-forward-4 "https:tcp:[]:50443:[192.168.250.10]:443"

vboxmanager createvm --name $VM_NAME --ostype "RedHat_64" --register
vboxmanager modifyvm $VM_NAME --memory 1024 --cpus 1 --nic1 natnetwork --nat-network1 $NAT_NETWORK

SED_PROGRAM="/^Config file:/ { s/^.*:\s\+\(\S\+\)/\1/; s|\\\\|/|gp }"
VBOX_FILE=$(vboxmanager showvminfo "$VM_NAME" | sed -ne "$SED_PROGRAM")
VM_DIR=$(dirname "$VBOX_FILE")

vboxmanager createmedium disk --filename "$VM_DIR.vdi" --size 10000 --format VDI
vboxmanager storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAhci
vboxmanager storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DIR".vdi

vboxmanager storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4
vboxmanager storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "F:\Programing\BCIT\Term4\4640_Networking\CentOS-7-x86_64-Minimal-1810.iso"

