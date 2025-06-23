#!/bin/bash -e

cd `dirname $0`
podman build ./100_base/ -t sabotagecla6/ubuntu
podman build ./200_usr/  -t sabotagecla6/ubuntu-usr
podman build ./300_gui/  -t sabotagecla6/ubuntu-gui
podman build ./300_gui/  -t sabotagecla6/ubuntu-gui-jp -f ./300_gui/Containerfile_JP

# application
podman build ./500_application/chrome  -t sabotagecla6/chrome
