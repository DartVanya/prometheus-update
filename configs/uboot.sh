#!/bin/bash
#---------------------------------------------------------------
#-Скрипт разработан специально для 4PDA от Foreman (Freize.org)-
#-Распространение без ведома автора запрещено!                 -
#---------------------------------------------------------------
. ./scripts/localization.sh
function uboot_patch {
if [[ "$ROUTERY" == *"ac51u"* ]]
then
ROUTERU="asus_rt-ac51u_ac54u"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"ac54u"* ]]
then
ROUTERU="asus_rt-ac51u_ac54u"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"ac1200hp"* ]]
then
ROUTERU="asus_rt-ac1200hp"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"mi-mini"* ]]
then
ROUTERU="xiaomi_mi-mini"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"mi-nano"* ]]
then
ROUTERU="xiaomi_mi-nano"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"mi-3"* && "$ROUTERY" != *"mi-3c"* && "$ROUTERY" != *"mi-3_spi"* ]]
then
ROUTERU="xiaomi_mi-3"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"mi-3c"* ]]
then
ROUTERU="xiaomi_mi-3c"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"n11p"* ]]
then
ROUTERU="asus_rt-n11p"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"n14u"* ]]
then
ROUTERU="asus_rt-n14u"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"n56u_"* ]]
then
ROUTERU="asus_rt-n56u"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"n56ub1"* ]]
then
ROUTERU="asus_rt-n56u_b1"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"wt3020"* && "$ROUTERY" != *"wt3020a"* ]]
then
ROUTERU="nexx_wt3020h"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"wt3020a"* ]]
then
ROUTERU="nexx_wt3020a"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"n750db"* ]]
then
ROUTERU="belkin_n750db"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"swr1100"* ]]
then
ROUTERU="samsung_cy-swr-1100"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"zbt-wg3526"* ]]
then
ROUTERU="zbt-wg3526"
UBOOTMIPS=2
elif [[ "$ROUTERY" == *"mqwiti-256"* ]]
then
ROUTERU="mqmaker-witi-256"
UBOOTMIPS=2
elif [[ "$ROUTERY" == *"mqwiti-512"* ]]
then
ROUTERU="mqmaker-witi-512"
UBOOTMIPS=2
elif [[ "$ROUTERY" == *"unielec-U7621-06"* ]]
then
ROUTERU="unielec_U7621-06"
UBOOTMIPS=2
elif [[ "$ROUTERY" == *"gl-mt300n"* ]]
then
ROUTERU="gl-mt300n"
UBOOTMIPS=1
elif [[ "$ROUTERY" == *"gl-mt300a"* ]]
then
ROUTERU="gl-mt300a"
UBOOTMIPS=1
else
message unsupported_router
read_n1
erorubootconfig=1
export erorubootconfig
return
fi }
erorubootconfig=0
export erorubootconfig
#---------------------------------------------------------------
# Конец скрипта
#---------------------------------------------------------------
