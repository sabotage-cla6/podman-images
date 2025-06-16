#!/bin/bash -e

cd `dirname $0`
podman build ./100_base/ -t sabotagecla6/ubuntu
