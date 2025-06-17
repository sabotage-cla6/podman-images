#!/bin/bash -e
USER_ID=${USER_ID:-${DEFAULT_USER_ID}}
GROUP_ID=${GROUP_ID:-${DEFAULT_GROUP_ID}}
PASSWD=${PASSWD:-${DEFAULT_PASSWD}}
USER=${USER:-${DEFAULT_USER}}
ROOT_PASSWD=${ROOT_PASSWD:-${DEFAULT_ROOT_PASSWD}}
NO_PASSWD=${NO_PASSWD:-$false}

ROOT_PASSWD=${ROOT_PASSWD:-${PASSWD}}

if [ ${USER_ID} -ne 0 ]; then
    
    groupadd -g $GROUP_ID $USER
    useradd -d /home/$USER -m -s /bin/bash -u $USER_ID -g $GROUP_ID -G sudo $USER
    echo root:${ROOT_PASSWD} | chpasswd
    if ${NO_PASSWD}; then
        passwd -d ${USER}
        echo "${USER}    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/${USER}
    else
        echo ${USER}:${PASSWD} | chpasswd
    fi

    sudo mkdir -p /run/user/${USER_ID}
    sudo chown $USER_ID:$GROUP_ID /run/user/${USER_ID}
fi
