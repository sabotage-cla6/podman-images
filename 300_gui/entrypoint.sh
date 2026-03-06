#!/bin/bash -e

# export XAUTHORITY=$HOME/.Xauthority
if [ -f /tmp/.Xauthority ];then
    sudo cp /tmp/.Xauthority $XAUTHORITY
    sudo chown $(id -u):$(id -g) $XAUTHORITY
fi

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi


$@