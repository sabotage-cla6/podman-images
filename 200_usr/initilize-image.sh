#!/bin/bash -e

if [ -f /usr/bin/create-user.sh ]; then
    . /usr/bin/create-user.sh
    rm -f /usr/bin/create-user.sh
fi
