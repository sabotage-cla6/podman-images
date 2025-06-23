#!/bin/bash -e

export XAUTHORITY=$HOME/.Xauthority
sudo cp /tmp/.Xauthority $HOME/.Xauthority
sudo chown $(id -u):$(id -g) $HOME/.Xauthority

$@