#!/bin/bash -x
vboxmanager () { VBoxManage.exe "$@"; }
vboxmanager natnetwork list
