#!/bin/bash -e

export XAUTHORITY=$HOME/.Xauthority
if [ -f /tmp/.Xauthority ];then
    sudo cp /tmp/.Xauthority $XAUTHORITY
fi
sudo chown $(id -u):$(id -g) $XAUTHORITY

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi


$@