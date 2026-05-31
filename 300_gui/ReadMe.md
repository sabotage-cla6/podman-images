# sabotagecla6/ubuntu-gui, sabotagecla6/ubuntu-gui-jp

GUIを持つアプリケーションを動かすコンテナのベースとするイメージ
chromeやvscodeなどのアプリケーションをコンテナ内で実行します。

このコンテナイメージを利用するには、下記の手順を踏む必要があります。
1. 本コンテナイメージをベースに、ユーザー作成済みのコンテナイメージを作成
2. 1で作成したイメージをGUIに必要な情報を連携して起動

## 実行用のコンテナの作成

ubuntu-guiは、このコンテナイメージをベースに
新しいコンテナイメージを作成して動かすことを前提としています。
下記のように、Containerfileを作成し、
ユーザー作成済みのコンテナイメージを作成してください。

``` Containerfile
FROM docker.io/sabotagecla6/ubuntu-gui-jp

# ***********************************************
# setting for create user
# ***********************************************
ENV USER_ID=[]
ENV GROUP_ID=1000
ENV USER=[user]
ENV ROOT_PASSWD=[pass]
ENV NO_PASSWD=true

# ***********************************************
# setting environment for GUI
# ***********************************************
ENV PULSE_COOKIE=/tmp/pulse/cookie
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV XDG_RUNTIME_DIR=/run/user/${USER_ID}
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus
ENV XAUTHORITY=/home/${USER}/.Xauthority

RUN create-user.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]
```

コンテナイメージのビルドは、作成してContainerfileのフォルダで下記コマンドを実行します。

```
podman build ./ -t [コンテナイメージ名]
```

## GUIをコンテナと共有するためのコマンド

下記コマンドを実行することでコンテナ内のアプリケーションのGUIをホスト側に表示させることが可能です。
音声出力のために、ユーザーをホスト側と一致させる必要があるため、ユーザーIDを指定しています。

```
podman run -u $(id -u):$(id -g) \
    --device /dev/snd --device /dev/dri \
    -e XDG_RUNTIME_DIR -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:Z \
    -e DISPLAY --net=host \
    -v $HOME/.Xauthority:/tmp/.Xauthority:Z -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro \
    --shm-size 4g \
    [コンテナイメージ名] [実行コマンド]```
```

下記をaliasしておくと便利です

```
alias podman-sound='podman run -u 1000:1000 --device /dev/snd -e XDG_RUNTIME_DIR -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native:ro --security-opt label=disable'
alias podman-display='podman-sound -v $HOME/.Xauthority:/tmp/.Xauthority:Z -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro -e DISPLAY --shm-size 4g'
```

