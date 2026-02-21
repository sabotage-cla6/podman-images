# sabotagecla6/ubuntu-gui, sabotagecla6/ubuntu-gui-jp

GUIを持つアプリケーションを動かすコンテナのベースとするイメージ
chromeやvscodeなどのアプリケーションをコンテナ内で実行します。

## GUIをコンテナと共有するためのコマンド

下記コマンドを実行することでコンテナ内のアプリケーションのGUIをホスト側に表示させることが可能です。
音声出力のために、ユーザーをホスト側と一致させる必要があるため、ユーザーIDを指定しています。

```
podman run -u 1000:1000 \
    --device /dev/snd -e XDG_RUNTIME_DIR -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:Z \
    -e DISPLAY --net=host \
    -v $HOME/.Xauthority:/tmp/.Xauthority:Z -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro
    [コンテナイメージ名] [実行コマンド]
```

下記をaliasしておくと便利です

```
alias podman-sound='podman run -u 1000:1000 --device /dev/snd -e XDG_RUNTIME_DIR -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:Z'

alias podman-display='podman-sound -e DISPLAY --net=host -v $HOME/.Xauthority:/tmp/.Xauthority:Z -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro'
```

## 現状の課題

- 日本語入力できない
    - ubuntu:20.04をベースにすれば可能だが、22.04では機能しない。
