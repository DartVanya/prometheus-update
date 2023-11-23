#!/bin/bash
#---------------------------------------------------------------
#-Скрипт разработан специально для 4PDA от Foreman (Freize.org)-
#-Распространение без ведома автора запрещено!                 -
#---------------------------------------------------------------
# Скрипты (не менять)
DIRS=scripts
# Конфиги (не менять)
DIRC=configs
# Файлы (не менять)
DIRF=files
# Формат даты (не менять)
SNAPSHOT=$(date +%Y-%m-%d_%H-%M-%S)
# Параметры роутера
# Роутер
ROUTERY=""
# Репозиторий
gitrepo="https://bitbucket.org/padavan/rt-n56u.git"
# Папка исходного кода
ICP=rt-n56u
export ICP
# Supported languages: english (EN), russian (RU), chinese (ZH)
# PROMETHEUS_LANG has highest priority over LANG system variable
# PROMETHEUS_LANG=EN
#---------------------------------------------------------------
# Конец скрипта
#---------------------------------------------------------------
