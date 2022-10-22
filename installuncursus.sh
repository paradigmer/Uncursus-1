#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo You need to run this script as root.
else
    need=""
    command -v curl >/dev/null 2>&1 || need+="curl "
    command -v wget >/dev/null 2>&1 || need+="wget "
    clear
    echo "Copyright (c) 2020, Yaya4 All rights reserved."
    echo -e "\e[31mWelcome to Uncursus Installation Script.\e[0m"
    echo "Checking if this script is running on ARM Darwin"
    if [ $(uname) = "Linux" ]; then
        if [ $(uname -p) = "x86_64" ]; then
            PC=yes
        fi
    fi
    if [[ "${PC}" = yes ]]; then
        echo "Use this script with SSH over an IP session on your iDevice. Thanks."
        exit  1
    else
        echo "ARM Darwin detected, running..."
        echo "Checking if you're using unc0ver..."
        if [[ -f "/.installed_unc0ver" ]]; then
            u0=yes
        else
            u0=no
        fi
        if [[ "${u0}" = no ]]; then
            echo "Use unc0ver, thanks"
            exit  1
        else
            echo "unc0ver detected"
            echo "WARNING: I'M NOT RESPONSIBLE IF ANYTHING GOES WRONG"
            echo "If you've found any bugs, please DM Me"
            echo "Checking Dependencies..."
            if [[ $need != "" ]]; then
                echo "Installing Dependencies..."
                apt update
                apt install $need -y
            fi
            echo "Pulling and executing the Procursus Migration Script..."
            /bin/bash /usr/bin/procursus-migration
            echo "Creating a custom directory for the required files. Path (/tmp/uncursus)."
            echo "Done. Setting Up Uncursus Repo...."
            echo "Types: deb" > /etc/apt/sources.list.d/uncursus.sources
            echo "URIs: https://github.com/Yaya48/uncursusrepo/tree/master/main" >> /etc/apt/sources.list.d/uncursus.sources
            echo "Suites: dists/iphoneos-arm64/uncursus/" >> /etc/apt/sources.list.d/uncursus.sources
            echo "Components: binary-iphoneos-arm" >> /etc/apt/sources.list.d/uncursus.sources
            echo "" >> /etc/apt/sources.list.d/uncursus.sources
            mkdir -p /etc/apt/preferences.d/
            echo "Package: *" > /etc/apt/preferences.d/uncursus
            echo "Pin: release l=Uncursus" >> /etc/apt/preferences.d/uncursus
            echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/uncursus
            echo "" >> /etc/apt/preferences.d/uncursus
            wget -q https://github.com/Yaya48/uncursusrepo/tree/master/pool/main/iphoneos-arm64/com.yaya4.repokeyring.deb --directory-prefix=/tmp/uncursus/
            dpkg -i /tmp/uncursus/com.yaya4.repokeyring.deb
            apt update
            echo "Done. Installing Procursus Cydia..."
            apt purge cydia -y --allow-remove-essential
            apt install cydia -y essential -y
            echo "Done. Installing necessities..."
            apt update
            apt install essential-dummy -y lzma -y ncurses -y libidn2 -y
            echo "Done. Running Firmware Configuration (./firmware.sh)"
            /usr/libexec/firmware
            echo "Bootstrap installation complete. Cleaning up..."
            rm -rf /tmp/uncursus/
            rm -rf /tmp/procursus-migration/
            rm -rf /tmp/zstd-support/
            echo "All Done."
            touch /.procursus_strapped
            uicache -p /Applications/Cydia.app
            sbreload
        fi
    fi
fi
