#!/bin/bash

# Цвета:
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'
NONE='\033[0m'
MOD_NAME=TOR.mod
. ./configs/script.config.sh
. ./modules/$MOD_NAME/common.sh
# including localization routines
. ./scripts/localization.sh
################################################################
clear
message tor_privoxy_module_header

MOD_CONFIG1="\n### Include TOR proxy ~2.3MB\nCONFIG_FIRMWARE_INCLUDE_TOR=y"
MOD_CONFIG2="\n### Include GeoIP database info for TOR proxy ~1.1MB\nCONFIG_FIRMWARE_INCLUDE_TOR_GEOIP=y"
MOD_CONFIG3="\n### Include IPv6 GeoIP database info for TOR proxy ~1.1MB\nCONFIG_FIRMWARE_INCLUDE_TOR_GEOIPV6=y"
MOD_CONFIG4="\n### Include Privoxy proxy ~0.3MB\nCONFIG_FIRMWARE_INCLUDE_PRIVOXY=y"
MOD_CONFIG5="\n### Include DNSCrypt proxy ~0.5MB\nCONFIG_FIRMWARE_INCLUDE_DNSCRYPT=y"
ORIG_FILE=$DIRP/$ICP/trunk/user/www/n56u_ribbon_fixed/jquery.js
BAK_FILE=$DIRP/$ICP/trunk/user/www/n56u_ribbon_fixed/jquery.js.bak

function backup-files {
    # TODO: maybe we can process without backup/restore
    cp -f $ORIG_FILE $BAK_FILE
}

function restore-files {
    # restore
    cp -f $BAK_FILE $ORIG_FILE
    rm -f $BAK_FILE
}

function after-add-mod {
    add-config-mod "$MOD_CONFIG1"
    add-config-mod "$MOD_CONFIG2"
    add-config-mod "$MOD_CONFIG3"
    add-config-mod "$MOD_CONFIG4"
    add-config-mod "$MOD_CONFIG5"
}

function after-remove-mod {
    remove-config-mod "$MOD_CONFIG1"
    remove-config-mod "$MOD_CONFIG2"
    remove-config-mod "$MOD_CONFIG3"
    remove-config-mod "$MOD_CONFIG4"
    remove-config-mod "$MOD_CONFIG5"
}

function test_mod_installed {
    # egrep "tor" -o $DIRP/$ICP/trunk/user/Makefile
    egrep "CONFIG_FIRMWARE_INCLUDE_TOR" -o "$DIRP/$DIRC/routers/$ROUTERS.sh"
}

##################### COMMON ROUTINES FOR ALL MODULES ################

MARKER_PATH=$DIRP/modules/$MOD_NAME/first-run-marker6

MOD_DEL=". ./modules/$MOD_NAME/common.sh && remove-patch"
MOD_ADD=". ./modules/$MOD_NAME/common.sh && apply-patch"

INSTALL=1
UNINSTALL=0

function remove-mod {
    # patch already applied?
    if ! remove-patch; then
        message please_before_module_deletion_update_sources
        add-mod
        remove-mod-hooks "$MOD_DEL" "$MOD_ADD"
        add-mod-hooks "$MOD_DEL" "$MOD_ADD"
        # return 1
    fi

    message module_has_been_deactivated

    if [ ! -f $MARKER_PATH ]; then
        touch $MARKER_PATH
        init-mod-hooks
        return 1
    fi

    remove-mod-hooks "$MOD_DEL" "$MOD_ADD"

    after-remove-mod
}

function add-mod {
    message preparing_module_patch
    if [ ! -f $DIRP/$ICP/trunk/.config ]; then
        cp $DIRP/$DIRC/routers/$ROUTERS.sh $DIRP/$ICP/trunk/.config
    fi

    # patch already applied?
    remove-patch
    apply-patch || { message tor_patch_not_applied; return 1; }

    if [ ! -f $MARKER_PATH ] || [ ! -f $DIRP/modules/a-update-s.sh ] || [ ! -f $DIRP/modules/a-update-a.sh ]; then
        touch $MARKER_PATH
        init-mod-hooks
    fi

    add-mod-hooks "$MOD_DEL" "$MOD_ADD"

    after-add-mod
}

while true; do
    if [ -z "$(test_mod_installed)" ] || [ ! -f $MARKER_PATH ]; then
        ACTION=$INSTALL
        MESSAGE=`message_n do_you_want_to_install_module`
    else
        ACTION=$UNINSTALL
        MESSAGE=`message_n module_already_installed_do_you_want_to_remove`
    fi

    echo -en $MESSAGE

    read yn
    case $yn in
        [Yy]* )
            backup-files

            [ $ACTION -eq $INSTALL ] && add-mod
            [ $ACTION -eq $UNINSTALL ] && remove-mod

            restore-files

            break;;
        [Nn]* )
            message module_operation_canceled

            break;;
        * )
            message enter_yes_no;;
    esac
done

sleep 3

################################################################
