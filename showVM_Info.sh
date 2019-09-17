#!/bin/bash -x
vboxmanager () { VBoxManage.exe "$@"; }
VM_NAME="VM_ACIT4640"
SED_PROGRAM="/^Config file:/ { s/^.*:\s\+\(\S\+\)/\1/; s|\\\\|/|gp }"
VBOX_FILE=$(vboxmanager showvminfo "$VM_NAME" | sed -ne "$SED_PROGRAM")
VM_DIR=$(dirname "$VBOX_FILE")
echo $VM_DIR

