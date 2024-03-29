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

    ProcursusMigration(){
        echo "Migrating..."
        rm /etc/apt/sources.list.d/cydia.list
        echo "deb https://apt.procurs.us/pool/main/iphoneos-arm64/1700/ main" >> /etc/apt/sources.list.d/cydia.list
        mkdir /tmp/procursus-migration
        mkdir /tmp/zstd-support/
        cd /tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/keyring/procursus-keyring_2020.05.09-3_all.deb --no-check-certificate  --directory-prefix=/tmp/procursus-migration
        dpkg -i /tmp/procursus-migration/procursus-keyring_2020.05.09-3_all.deb
        apt update 
        cd /tmp/zstd-support/
        apt download libintl8 liblzma5 lz4 xz liblz4-1 xz-utils
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libintl8_0.21-4_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/liblzma5_5.2.5-3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/lz4_1.9.3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/xz-utils_5.2.5-3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/liblz4-1_1.9.3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.bingner.com/debs/1443.00/xz_5.2.4-4_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libzstd1_1.5.2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/zstd_1.5.2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/zstd-support/
        dpkg -i --force-all *.deb
        cd /tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libzstd1_1.5.2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/apt/apt_2.5.2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migratio
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/apt/libapt-pkg6.0_2.5.2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migratio
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/xz-utils_5.2.5-3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/liblzma5_5.2.5-3_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libncursesw6_6.3-2_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/ncurses-term_6.2-1_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libxxhash0_0.8.1_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libxxhash-dev_0.8.1_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libgcrypt20_1.9.4_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/libgpg-error0_1.45_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
        wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/dpkg/dpkg_1.21.9_iphoneos-arm.deb --no-check-certificate        --directory-prefix=/tmp/procursus-migration
        apt download libzstd1 apt libapt-pkg6.0 xz-utils liblzma5 libncursesw6 ncurses-term libxxhash0 libxxhash-dev libgcrypt20 libgpg-error0 dpkg
        dpkg -i --force-all /tmp/procursus-migration/*.deb
        if [ ! -f "/usr/lib/libncurses.6.dylib" ]; then
            echo "Fixing ..."
            ln -s /usr/lib/libncursesw.6.dylib /usr/lib/libncurses.6.dylib
        else
            echo "Nothing To Do!"
        fi
        dpkg -i --force-all dpkg*.deb
        dpkg -i --force-all *.deb
        apt download coreutils
         wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/1700/coreutils_9.1_iphoneos-arm.deb --no-check-certificate       

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
