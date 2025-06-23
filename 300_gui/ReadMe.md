# sabotagecla6/ubuntu-gui, sabotagecla6/ubuntu-gui-jp

GUIを持つアプリケーションを動かすコンテナのベースとするイメージ
chromeやvscodeなどのアプリケーションをコンテナ内で実行します。

## GUIをコンテナと共有するためのコマンド

下記コマンドを実行することでコンテナ内のアプリケーションのGUIをホスト側に表示させることが可能です。
音声出力のために、ユーザーをホスト側と一致させる必要があるため、ユーザーIDを指定しています。

```
sudo docker run -u $(id -u):$(id -g) --shm-size=4096m -v /run/user/$(id -u)/pulse/native:/tmp/pulse/native  -v ~/.config/pulse/cookie:/tmp/pulse/cookie:ro -e PULSE_COOKIE=/tmp/pulse/cookie -e PULSE_SERVER=unix:/tmp/pulse/native  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY [コンテナイメージ名] [実行コマンド]
```

下記をaliasしておくと便利です

```
alias docker-sound='sudo docker run -u $(id -u):$(id -g) --shm-size=4096m -v /run/user/$(id -u)/pulse/native:/tmp/pulse/native  -v ~/.config/pulse/cookie:/tmp/pulse/cookie:ro -e PULSE_COOKIE=/tmp/pulse/cookie -e PULSE_SERVER=unix:/tmp/pulse/native'

alias docker-display='docker-sound -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY'
```

## 現状の課題

- 日本語入力できない
    - ubuntu:20.04をベースにすれば可能だが、22.04では機能しない。
- firefoxをインストールできない。
    - firefoxを立ち上げるとsnap インストールするように言われる
    - chromeを --no-sandbox オプションつけて起動している