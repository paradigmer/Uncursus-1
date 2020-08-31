#!/bin/bash
if [ "$EUID" -ne 0 ]; then
echo You need to run this script as root.
else
clear
echo "Copyright (c) 2020, Yaya4 All rights reserved."
echo -e "\e[31mUncursus 2.0 Migration Part By Yaya4_4 1.1.1 (Stable)\e[0m"
echo "Checking iOS Version"
VER=$(/usr/bin/plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist)
if [[ "${VER%.*}" -ge 12 ]] && [[ "${VER%.*}" -lt 13 ]]; then
echo "iOS 12 detected, setting the CFVER to 1500"
CFVER=1500
elif [[ "${VER%.*}" -ge 13 ]]; then
echo "iOS 13 detected, setting the CFVER to 1600"
CFVER=1600
elif [[ "${VER%.*.*}" -ge 13 ]]; then
echo "iOS 13 detected, setting the CFVER to 1600"
CFVER=1600
elif [[ "${VER%.*.*}" -ge 12 ]]; then
echo "iOS 12 detected, setting the CFVER to 1500"
CFVER=1500
else
echo "Your iOS Version Is Under iOS 12 Or Either Than 13"
exit 1
fi
echo -e "\e[32mStarting Migration On iOS $VER ....\e[0m"
COREUTILSVER=8.32-4
apt update
apt install wget -y --allow-unauthenticated
rm /etc/apt/sources.list.d/cydia.list
echo "deb https://apt.procurs.us/ iphoneos-arm64/${CFVER} main" >> /etc/apt/sources.list.d/cydia.list
rm -rf /tmp/procursus-migration
mkdir /tmp/procursus-migration
wget -q http://apt.procurs.us/pool/main/iphoneos-arm64/${CFVER}/procursus-keyring_2020.05.09_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/${CFVER}/coreutils_${COREUTILSVER}_iphoneos-arm.deb --no-check-certificate --directory-prefix=/tmp/procursus-migration
dpkg -i /tmp/procursus-migration/procursus-keyring_2020.05.09_iphoneos-arm.deb
apt update
apt install libncursesw6 -y
if [ ! -f "/usr/lib/libncurses.6.dylib" ]; then
echo "Fixing.."
ln -s /usr/lib/libncursesw.6.dylib /usr/lib/libncurses.6.dylib
else
echo "Nothing To Do!"
fi
apt install ncurses-bin -y
apt install xz-utils -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
apt dist-upgrade -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
dpkg -i --force-all /tmp/procursus-migration/coreutils_${COREUTILSVER}_iphoneos-arm.deb
dpkg -r apt1.4
apt update
apt purge libplist-utils -y libplist3 -y
apt autoremove -y
apt install libplist-utils -y libplist++-dev -y libplist++-dev -y libplist++3v5 -y libplist-dev -y libplist3 -y ldid -y
echo "Types: deb" > /etc/apt/sources.list.d/procursus.sources
echo "URIs: https://apt.procurs.us/" >> /etc/apt/sources.list.d/procursus.sources
echo "Suites: iphoneos-arm64/${CFVER}" >> /etc/apt/sources.list.d/procursus.sources
echo "Components: main" >> /etc/apt/sources.list.d/procursus.sources
echo -e "\e[32mMigration Finished!\e[0m"
echo -e "\e[32mBack to Uncursus Script...\e[0m"
fi