#!/bin/bash
#---------------------------------------------------------------
#-Скрипт разработан специально для 4PDA от Foreman (Freize.org)-
#-Распространение без ведома автора запрещено!                 -
#---------------------------------------------------------------
#Цвета:
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'
NONE='\033[0m'
# Подключаем локализацию
. ./scripts/localization.sh
#---------------------------------------------------------------
# Конец технического раздела
#---------------------------------------------------------------
set_round=1
while true; do
   #проверяем зависимости и выходим если все установлено
   if [ "$set_round" -ge "3" ]
   then
     message software_installation_error
     message press_to_proceed
     read -n1 -s ; read -s -t 0.1
     exit
   fi
   dpkg -s autoconf autoconf-archive automake autopoint bison build-essential ca-certificates cmake cpio curl doxygen fakeroot flex gawk gettext git gperf help2man htop kmod libblkid-dev libc-ares-dev libcurl4-openssl-dev libdevmapper-dev libev-dev libevent-dev libexif-dev libflac-dev libgmp3-dev libid3tag0-dev libidn2-dev libjpeg-dev libkeyutils-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libogg-dev libsqlite3-dev libssl-dev libtool libtool-bin libudev-dev libunbound-dev libvorbis-dev libxml2-dev locales mc nano pkg-config ppp-dev python3 python3-docutils sshpass texinfo unzip uuid uuid-dev vim wget xxd zlib1g-dev >/dev/null 2>&1 && message dependencies_ok && sleep 0.3 && break
   set_round=$(($set_round + 1))
   message installing_software
   sudo apt update
   sudo apt -y install autoconf autoconf-archive automake autopoint bison build-essential ca-certificates cmake cpio curl doxygen fakeroot flex gawk gettext git gperf help2man htop kmod libblkid-dev libc-ares-dev libcurl4-openssl-dev libdevmapper-dev libev-dev libevent-dev libexif-dev libflac-dev libgmp3-dev libid3tag0-dev libidn2-dev libjpeg-dev libkeyutils-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libogg-dev libsqlite3-dev libssl-dev libtool libtool-bin libudev-dev libunbound-dev libvorbis-dev libxml2-dev locales mc nano pkg-config ppp-dev python3 python3-docutils sshpass texinfo unzip uuid uuid-dev vim wget xxd zlib1g-dev
done
