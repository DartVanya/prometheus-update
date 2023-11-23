. ./configs/script.config.sh
# include localization routines
. ./scripts/localization.sh
# include Prometheus variables, like version, etc
. ./configs/vi.sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIRP="$( pwd )"

function apply-patch {
    pushd $DIRP/$ICP

    rm -f mi-mini-tor-patch.sh
    # Old path: https://www.dropbox.com/s/juhmjehhbhea612/mi-mini-tor+privoxy_16827_b621c91.sh
    # Old path: http://www.qwe-qwe.me/mi-mini/last_patch.sh
    wget --tries=1 -O mi-mini-tor-patch.sh http://www.qwe-qwe.me/patch/last_patch.sh || wget --tries=1 -O mi-mini-tor-patch.sh https://drive.google.com/uc?id=0ByORA7yiJiQXcjFreVJQdm5uMGc || return 1
    
    if [ "$stable" == "TEST" ]; then
        # TEST version: don't rollback sources 
        sed -i "s/git pull \$gitrepo \$revision//" mi-mini-tor-patch.sh
    else
        # STABLE version: do rollback and fix moving from newer to older revision
        sed -i "s/git pull \$gitrepo \$revision/git pull origin master; git reset --hard \$revision/" mi-mini-tor-patch.sh
    fi

    sed -i "s/patch -p0/patch -N -p0/" mi-mini-tor-patch.sh
    message applying_tor_privoxy_patch
    sh mi-mini-tor-patch.sh
    message adding_module_update_fix
    cd $DIRP/$ICP/trunk
    rm -f mi-mini-tor.patch
    PATCHNAME=$(find . -name "*tor*.patch" | sed 's/\.\///g')

    if [ -f "$PATCHNAME" ]; then
        message moving_module_patch
        cp -f $PATCHNAME mi-mini-tor.patch
        rm -f $PATCHNAME
    else
        popd # pay attention, add pair popd
        return 1
    fi

    popd # pay attention, add pair popd

    # trying to fix coflict between tor and entware modules
    . $DIRP/modules/ENTWARE.mod/common.sh && apply-patch
}

function remove-patch {
    pushd $DIRP/$ICP/trunk/

    # cleanup old files
    find . -name *.rej -o -name *.orig | xargs -r rm
    rm -rf user/tor user/privoxy libs/libpcre user/www/MI-MINI

    if [ ! -f mi-mini-tor.patch ]; then
        rm -f *tor*.patch
        popd # pay attention, add pair popd
        return 1
    fi
    patch -N -R -p0 < mi-mini-tor.patch
    rm -f *tor*.patch
    message tor_privoxy_patch_has_been_removed

    popd # pay attention, add pair popd
}


################# COMMON ROUTINES FOR ALL MODULES ############################################

function pushd () {
    command pushd "$@" > /dev/null
}

function popd () {
    command popd "$@" > /dev/null
}

function substract-files {
    # smaller file
    FIRST_FILE=$1
    # bigger file
    SECOND_FILE=$2
    SECOND_FILE_TMP=${SECOND_FILE}.tmp

    if [ ! -f $SECOND_FILE ]; then
        echo "substract-files: second param $2 is not file"
        sleep 3
        return 1
    fi

    if [ -f "$FIRST_FILE" ]; then
        FIRST_FILE=`cat $FIRST_FILE`
    fi

    # remove empty line from smaller file
    echo -e "$FIRST_FILE" | grep -ve '^$' | grep -vf - $SECOND_FILE > $SECOND_FILE_TMP

    cmp --silent $SECOND_FILE $SECOND_FILE_TMP && rm -f $SECOND_FILE_TMP && return 1

    # test file is not empty
    [ -s $SECOND_FILE_TMP ] && mv $SECOND_FILE_TMP $SECOND_FILE && chmod +x $SECOND_FILE

    # remove multiple blank lines
    cat -s $SECOND_FILE > $SECOND_FILE_TMP
    [ -s $SECOND_FILE_TMP ] && mv $SECOND_FILE_TMP $SECOND_FILE && chmod +x $SECOND_FILE

    rm -f $SECOND_FILE_TMP
}

# add-mod-hooks $DIRP/modules/TOR.mod/mod-del.sh $DIRP/modules/TOR.mod/mod-add.sh
function add-mod-hooks {
    MOD_DEL=$1
    MOD_ADD=$2

    if [ -f "$MOD_DEL" ]; then
        MOD_DEL=`cat $MOD_DEL`
    fi
    if [ -f "$MOD_ADD" ]; then
        MOD_ADD=`cat $MOD_ADD`
    fi

    remove-mod-hooks "$MOD_DEL" "$MOD_ADD"

    echo -e "$MOD_DEL" >> $DIRP/modules/a-update-s.sh
    echo -e "$MOD_ADD" >> $DIRP/modules/a-update-a.sh
}

# remove-mod-hooks $DIRP/modules/TOR.mod/mod-del.sh $DIRP/modules/TOR.mod/mod-add.sh
function remove-mod-hooks {
    MOD_DEL=$1
    MOD_ADD=$2

    if [ -f "$MOD_DEL" ]; then
        MOD_DEL=`cat $MOD_DEL`
    fi
    if [ -f "$MOD_ADD" ]; then
        MOD_ADD=`cat $MOD_ADD`
    fi

    MOD_BEFORE=$DIRP/modules/a-update-s.sh
    MOD_AFTER=$DIRP/modules/a-update-a.sh

    substract-files "$MOD_DEL" "$MOD_BEFORE"
    substract-files "$MOD_ADD" "$MOD_AFTER"
}

# remove-config-mod "$TOR_CONFIG"
function remove-config-mod {
    # message removing_module_from_config_ok

    MOD_CONFIG="$1"
    CONFIG=$DIRP/$DIRC/routers/$ROUTERS.sh

    substract-files "$MOD_CONFIG" "$CONFIG" && message removing_module_from_config_ok
}

# add-config-mod "$TOR_CONFIG"
function add-config-mod {
    MOD_CONFIG="$1"
    message adding_module_to_config_ok

    remove-config-mod "$MOD_CONFIG"
    echo -e "$MOD_CONFIG" >> $DIRP/$DIRC/routers/$ROUTERS.sh
}

function init-mod-hooks {
    message resetting_module_settings
    cp -f $DIRP/modules/a-update-s.sh.exemple $DIRP/modules/a-update-s.sh
    cp -f $DIRP/modules/a-update-a.sh.exemple $DIRP/modules/a-update-a.sh
    chmod +x $DIRP/modules/a-update-s.sh $DIRP/modules/a-update-a.sh
}

# test
# remove-mod-hooks ". ./modules/$MOD_NAME/common.sh && remove-patch" ". ./modules/$MOD_NAME/common.sh && apply-patch"
