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
podman build --no-cache ./600_devenv/flutter -t sabotagecla6/flutter-dev

# タグ付け
date=$(date +%Y%m%d)
image="sabotagecla6/ubuntu"
podman tag "${image}:latest" "${image}:${date}"
image="sabotagecla6/ubuntu-usr"
podman tag "${image}:latest" "${image}:${date}"
image="sabotagecla6/ubuntu-gui"
podman tag "${image}:latest" "${image}:${date}"
image="sabotagecla6/ubuntu-gui-jp"
podman tag "${image}:latest" "${image}:${date}"

image="sabotagecla6/chrome"
podman tag "${image}:latest" "${image}:${date}"
image="sabotagecla6/vscode"
podman tag "${image}:latest" "${image}:${date}"

image="sabotagecla6/python-dev"
podman tag "${image}:latest" "${image}:${date}"
image="sabotagecla6/flutter-dev"
podman tag "${image}:latest" "${image}:${date}"
