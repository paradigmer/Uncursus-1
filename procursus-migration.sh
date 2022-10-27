#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo You need to run this script as root.
else
    clear
    echo "Copyright (c) 2020, Yaya4 All rights reserved."
    echo -e "\e[31mUncursus Migration Part\e[0m"
    ErrorHandler(){
        echo -e "\e[31mSomething went wrong.\e[0m"
        echo -e "\e[31mPlease report the issues with a pastebin.\e[0m"
        exit 1
    }
    checkDependencies(){
        echo "Checking Dependencies ..."
        need2=""
        command -v wget >/dev/null 2>&1 || need2+="wget "
        command -v plutil >/dev/null 2>&1 || need2+="com.bingner.plutil "
        if [[ $need2 != "" ]]; then
            echo "Installing Dependencies..."
            apt update
            apt install $need2 -y
        fi
    }
    checkiOSVersion(){
        echo "Checking iOS Version ..."
        echo "1 for *OS 14"
        echo "2 for *OS 13"
        echo "3 for *OS 12"
        read version
        if [ "1" = $version ]; then
            CFVER=1700
        elif [ "2" = $version ]; then
            CFVER=1600
        elif [ "3" = $version ]; then
            CFVER=1500
        fi
    }
    ProcursusMigration(){
        echo "Migrating..."
        rm /etc/apt/sources.list.d/cydia.list
        echo "deb https://apt.procurs.us/pool/main/iphoneos-arm64/1700/ main" >> /etc/apt/sources.list.d/cydia.list

        cd /tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/keyring/procursus-keyring_2020.05.09-3_all.deb --no-check-certificate
        dpkg -i procursus-keyring_2020.05.09-3_all.deb
        apt update

        cd /tmp/zstd-support/
        apt download libintl8 liblzma5 lz4 xz liblz4-1 xz-utils
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libzstd1_1.5.2_iphoneos-arm.deb --no-check-certificate
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/zstd_1.5.2_iphoneos-arm.deb --no-check-certificate
        dpkg -i --force-all *.deb
        cd /tmp/procursus-migration
        apt download libzstd1 apt libapt-pkg6.0 xz-utils liblzma5 libncursesw6 ncurses-term libxxhash0 libxxhash-dev libgcrypt20 libgpg-error0 dpkg
        dpkg -i --force-all /tmp/procursus-migration/libncursesw6*.deb
        if [ ! -f "/usr/lib/libncurses.6.dylib" ]; then
            echo "Fixing ..."
            ln -s /usr/lib/libncursesw.6.dylib /usr/lib/libncurses.6.dylib
        else
            echo "Nothing To Do!"
        fi
        dpkg -i --force-all dpkg*.deb
        dpkg -i --force-all *.deb
        apt download coreutils
        dpkg -r --force-all libidn2
        apt --fix-broken install -y -u -o APT::Force-LoopBreak=1
        apt install diskdev-cmds -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
        apt dist-upgrade -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
        dpkg -i --force-all /tmp/procursus-migration/coreutils*.deb
    }
    ProcursusSourcesSetup(){
        echo "Settings Up Procursus Source ..."
        echo "Types: deb" > /etc/apt/sources.list.d/procursus.sources
        echo "URIs: https://apt.procurs.us/" >> /etc/apt/sources.list.d/procursus.sources
        echo "Suites: iphoneos-arm64/1700" >> /etc/apt/sources.list.d/procursus.sources
        echo "Components: main" >> /etc/apt/sources.list.d/procursus.sources
    }
    MigrationCleanUp(){
        echo "Cleaning Up ..."
        dpkg -r apt1.4
        apt update
        apt purge libplist-utils -y libplist3 -y
        apt autoremove -y
        apt install libplist-utils -y libplist++-dev -y libplist++-dev -y libplist++3v5 -y libplist-dev -y libplist3 -y ldid -y
        apt reinstall libintl8 -y
    }
    checkDependencies || ErrorHandler
    checkiOSVersion || ErrorHandler
    echo -e "\e[32mStarting Migration On $CFVER ....\e[0m"
    ProcursusMigration || ErrorHandler
    ProcursusSourcesSetup || ErrorHandler
    MigrationCleanUp || ErrorHandler
    echo -e "\e[32mMigration Finished!\e[0m"
fi
