# sabotagecla6/ubuntu-gui, sabotagecla6/ubuntu-gui-jp

GUIを持つアプリケーションを動かすコンテナのベースとするイメージ
chromeやvscodeなどのアプリケーションをコンテナ内で実行します。

このコンテナイメージを利用するには、下記の手順を踏む必要があります。
1. 本コンテナイメージをベースに、ユーザー作成済みのコンテナイメージを作成
2. 1で作成したイメージをGUIに必要な情報を連携して起動

## 実行用のコンテナの作成

ubuntu-guiは、このコンテナイメージをベースに
新しいコンテナイメージを作成して動かすことを前提としています。
下記のように、Containerfileと.envファルを作成し、
ユーザー作成済みのコンテナイメージを作成してください。

■ Containerfile
``` dockerfile
FROM docker.io/sabotagecla6/ubuntu-gui-jp

ARG USER_ID
ARG GROUP_ID
ARG USER
ARG ROOT_PASSWD
ARG NO_PASSWD

ARG INPUT_METHOD

ENV PULSE_COOKIE=/tmp/pulse/cookie
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV XDG_RUNTIME_DIR=/run/user/${USER_ID}
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus
ENV XAUTHORITY=/home/${USER}/.Xauthority

ENV GTK_IM_MODULE=${INPUT_METHOD} \
    QT_IM_MODULE=${INPUT_METHOD} \
    XMODIFIERS=@im=${INPUT_METHOD} \
    DefalutIMModule=${INPUT_METHOD}

# ***********************************************
# setting environment for GUI
# ***********************************************
RUN /install/create-user.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["code","-w"]
```

■.env
``` ini
USER_ID=1000
GROUP_ID=1000
USER=ubuntu
ROOT_PASSWD=ubuntu
NO_PASSWD=true

INPUT_METHOD=fcitx

PULSE_COOKIE=/tmp/pulse/cookie
PULSE_SERVER=unix:/tmp/pulse/native
XDG_RUNTIME_DIR=/run/user/${USER_ID}
DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus
XAUTHORITY=/home/${USER}/.Xauthority
```

■ ビルドコマンド
``` bash
podman build --build-arg-file .env ./ -t [イメージ名]
```

コンテナイメージのビルドは、作成してContainerfileのフォルダで下記コマンドを実行します。

```
podman build ./ -t [コンテナイメージ名]
```

## 作成したイメージからの実行

下記コマンドを実行することでコンテナ内のアプリケーションのGUIをホスト側に表示させることが可能です。
音声出力のために、ユーザーをホスト側と一致させる必要があるため、ユーザーIDを指定しています。
コンテナのユーザーIDマッピング処理が必要になるため、イメージ作成後の初回起動のみ開始までに時間がかかります。

```
podman run -u $(id -u):$(id -g) \
    --device /dev/snd \
    --device /dev/dri \
    --net=host --ipc=host \
    --security-opt label=disable \
    --userns=keep-id \
    -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro \
    -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:Z \
    -e DISPLAY \
    -e XDG_RUNTIME_DIR \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/bus:${XDG_RUNTIME_DIR}/bus \
    -v $HOME/.Xauthority:/tmp/.Xauthority:Z \
    --shm-size 4g \
    [コンテナイメージ名] [実行コマンド]```
```

下記をaliasしておくと便利です

■ ~/.bash_aliases
```
alias podman-sound='podman run -u $(id -u):$(id -g) --device /dev/snd --userns=keep-id -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:Z'
alias podman-gui='podman-sound --shm-size 4g --device /dev/dri --security-opt label=disable -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro -v ${XDG_RUNTIME_DIR}/bus:${XDG_RUNTIME_DIR}/bus -v $HOME/.Xauthority:/tmp/.Xauthority:Z -e DISPLAY'
```

