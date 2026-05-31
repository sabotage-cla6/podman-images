#!/bin/bash -e

if [ -f /tmp/.Xauthority ];then
    sudo cp /tmp/.Xauthority $XAUTHORITY
    sudo chown $(id -u):$(id -g) $XAUTHORITY
    COOKIE=$(xauth -f $XAUTHORITY list | head -n 1 | awk '{print $3}')
    xauth add ${HOSTNAME}/unix:0 MIT-MAGIC-COOKIE-1 $COOKIE
fi

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

$@