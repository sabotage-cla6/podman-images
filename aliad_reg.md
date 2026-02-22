# alias の登録

GUIアプリを起動するimageを多く作成していますが、
コンテナを立ち上げるコマンドが長くなるため、alias を設定しておきます。

# alias 設定内容

~/.bash_aliases に下記追加（ない場合ば新規作成）

``` bash
alias podman-sound='podman run --net=host --shm-size=4096m -u $(id -u):$(id -g) --device /dev/snd -v ~/.config/pulse/cookie:/tmp/pulse/cookie -e PULSE_COOKIE=/tmp/pulse/cookie:ro -v /run/user/1000/pulse/native:/tmp/pulse/native -e PULSE_SERVER=unix:/tmp/pulse/native'
alias podman-gui='podman-sound -e DISPLAY -v $HOME/.Xauthority:/tmp/.Xauthority:Z -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e XDG_RUNTIME_DIR -e XMODIFIERS -e GTK_IM_MODULE -e QT_IM_MODULE -e DefalutIMModule=fcitx -e DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus'
```
# guiアプリを使用するコンテナの立ち上げ

``` bash 
podman-gui [オプション] [コンテナ名] [実行コマンド]
```
