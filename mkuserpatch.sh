#!/bin/bash
#image=${{ matrix.device }}-${{ matrix.kernel }}-${{ matrix.os }}-${{ matrix.type }}
            
device=$(echo "$1" | cut -d'-' -f1)
kernel=$(echo "$1" | cut -d'-' -f2)
os=$(echo "$1" | cut -d'-' -f3)
release=$(echo "$1" | cut -d'-' -f4)
type=$(echo "$1" | cut -d'-' -f2)

configfile="userpatches/config-${device}-${kernel}-${os}-${release}-${type}.conf"
mkdir userpatches
cat << EOF > $configfile
KERNEL_CONFIGURE=no
#INSTALL_HEADERS=yes
SHARE_LOGS=no
KERNEL_GIT=shallow
BOARD=${device}

BRANCH=${kernel}

RELEASE=${release}
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