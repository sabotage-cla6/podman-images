#!/bin/bash -e

cd `dirname $0`
podman build --no-cache ./100_base/ -t sabotagecla6/ubuntu
podman build --no-cache ./200_usr/  -t sabotagecla6/ubuntu-usr
podman build --no-cache ./300_gui/  -t sabotagecla6/ubuntu-gui
podman build --no-cache ./300_gui/  -t sabotagecla6/ubuntu-gui-jp -f ./300_gui/Containerfile_JP

# application
podman build --no-cache ./500_application/chrome  -t sabotagecla6/chrome
podman build --no-cache ./500_application/vscode  -t sabotagecla6/vscode

podman build --no-cache ./600_devenv/python -t sabotagecla6/python-dev

podman build --no-cache ./700_runtime/python -t sabotagecla6/vscode
