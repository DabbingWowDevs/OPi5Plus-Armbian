#!/bin/bash
#image=${{ matrix.device }}-${{ matrix.kernel }}-${{ matrix.os }}-${{ matrix.type }}
            
device=$1
kernel=$2
os=$3
type=$4

configfile="userpatches/config-${device}-${kernel}-${os}-${type}.conf"
mkdir userpatches
cat << EOF > $configfile
KERNEL_CONFIGURE=no
#INSTALL_HEADERS=yes
SHARE_LOGS=no
KERNEL_GIT=shallow
BOARD=${device}

BRANCH=${kernel}

RELEASE=${os}
EOF


if [ "$type" == "minimal" ]; then
cat << EOF >> $configfile
BUILD_MINIMAL=yes
BUILD_DESKTOP=no
EOF
else
cat << EOF >> $configfile
BUILD_MINIMAL=no
BUILD_DESKTOP=yes
DESKTOP_APPGROUPS_SELECTED='browsers desktop_tools editors multimedia'
DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base

DESKTOP_ENVIRONMENT=${type}
EOF
fi


echo "Created userpatch file: $configfile"
echo "Contents:"
cat $configfile
echo "-----"