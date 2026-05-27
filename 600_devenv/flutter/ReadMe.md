# 使い方

このImageをベースに新しいImageを作成して
使うことを前提としています。

下記の通りのコンテナファイルを作成して使用します。

```Containerfile
FROM localhost/sabotagecla6/flutter-dev

WORKDIR /install

# ***********************************************
# setting for create user
# ***********************************************
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV USER=ubuntu
ENV ROOT_PASSWD=ubuntu
ENV NO_PASSWD=true

# ***********************************************
# setting environment for GUI
# ***********************************************
ENV PULSE_COOKIE=/tmp/pulse/cookie
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV XDG_RUNTIME_DIR=/run/user/${USER_ID}
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus
ENV XAUTHORITY=/home/${USER}/.Xauthority

RUN /usr/local/bin/create-user.sh
RUN /install/setup-extensions.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["code","-w"]
```