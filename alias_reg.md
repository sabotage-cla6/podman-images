# alias の登録

GUIアプリを起動するimageを多く作成していますが、
コンテナを立ち上げるコマンドが長くなるため、alias を設定しておきます。

# alias 設定内容

~/.bash_aliases に下記追加（ない場合ば新規作成）

``` bash
alias podman-sound='podman run --net=bridge -u $(id -u):$(id -g) --device /dev/snd -v ~/.config/pulse/cookie:/tmp/pulse/cookie -e PULSE_COOKIE=/tmp/pulse/cookie:ro -v /run/user/1000/pulse/native:/tmp/pulse/native -e PULSE_SERVER=unix:/tmp/pulse/native'
alias podman-gui='podman run --net=host -u $(id -u):$(id -g) --device /dev/snd -v ~/.config/pulse/cookie:/home/ubuntu/pulse/cookie -e PULSE_COOKIE=/home/ubuntu/pulse/cookie:ro -v ${XDG_RUNTIME_DIR}/pulse/native:/tmp/pulse/native                   -e PULSE_SERVER=unix:/tmp/pulse/native               -e DISPLAY -v $HOME/.Xauthority:/tmp/.Xauthority:ro -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e XDG_RUNTIME_DIR -e XMODIFIERS -e GTK_IM_MODULE -e QT_IM_MODULE -e DefalutIMModule=fcitx --device /dev/dri -e DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus'
```
# guiアプリを使用するコンテナの立ち上げ

``` bash 
podman-gui [オプション] [コンテナ名] [実行コマンド]
```
