#!/bin/bash -e
cd `dirname $0`

podman build --no-cache --build-arg-file ./vscode/.env ./vscode -t myimages/vscode
podman build --no-cache --build-arg-file ./flutter/.env ./vscode -t myimages/flutter-dev
