#!/bin/bash
if [ "$EUID" -ne 0 ]; then
echo You need to run this script as root.
else
clear
echo -e "\e[31mUncursus 2.0 Migration Part By Yaya4_4 1.0 (Sbtale)\e[0m"
echo "Checking iOS Version"
VER=$(/usr/bin/plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist)
if [[ "${VER%.*}" -ge 12 ]] && [[ "${VER%.*}" -lt 13 ]]; then
echo "iOS 12 Dectected Set The CFVER To 1500"
CFVER=1500
elif [[ "${VER%.*}" -ge 13 ]]; then
echo "iOS 13 Dectected Set The CFVER To 1600"
CFVER=1600
else
if [[ "${VER%.*.*}" -ge 13 ]]; then
echo "iOS 13 Dectected Set The CFVER To 1600"
CFVER=1600
else
if [[ "${VER%.*.*}" -ge 12 ]]; then
echo "iOS 12 Dectected Set The CFVER To 1500"
CFVER=1500
fi
fi
fi
echo -e "\e[32mStarting Migration....\e[0m"
apt update
apt install wget -y --allow-unauthenticated
rm /etc/apt/sources.list.d/cydia.list
echo "deb https://apt.procurs.us/ iphoneos-arm64/${CFVER} main" >> /etc/apt/sources.list.d/cydia.list
rm -rf /var/root/migration
mkdir /var/root/migration
wget -q http://apt.procurs.us/pool/main/iphoneos-arm64/${CFVER}/procursus-keyring_2020.05.09_iphoneos-arm.deb --no-check-certificate --directory-prefix=/var/root/migration
wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/${CFVER}/coreutils_8.32-1_iphoneos-arm.deb --no-check-certificate --directory-prefix=/var/root/migration
wget -q https://apt.procurs.us/pool/main/iphoneos-arm64/${CFVER}/firmware-sbin_0-1_iphoneos-arm.deb --no-check-certificate --directory-prefix=/var/root/migration
wget -q http://yaya48.gq/files/migration-files/elucubratustoprocursus/libncurses.6.dylib --no-check-certificate --directory-prefix=/var/root/migration
dpkg -i /var/root/migration/procursus-keyring_2020.05.09_iphoneos-arm.deb
apt update
apt install xz-utils -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
wget -q https://yaya48.gq/files/migration-files/shared/${CFVER}/liblzma.dylib --no-check-certificate --directory-prefix=/usr/local/lib
wget -q https://yaya48.gq/files/migration-files/shared/${CFVER}/liblzma.5.dylib --no-check-certificate --directory-prefix=/usr/local/lib
apt install xz-utils -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
apt full-upgrade -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1 
cp /var/root/migration/libncurses.6.dylib /usr/lib
dpkg -i --force-all /var/root/migration/firmware-sbin_0-1_iphoneos-arm.deb
apt full-upgrade -y --allow-unauthenticated -u -o APT::Force-LoopBreak=1
dpkg -i --force-all /var/root/migration/coreutils_8.32-1_iphoneos-arm.deb
dpkg -r apt1.4
echo "Types: deb" > /etc/apt/sources.list.d/procursus.sources
echo "URIs: https://apt.procurs.us/" >> /etc/apt/sources.list.d/procursus.sources
echo "Suites: iphoneos-arm64/${CFVER}" >> /etc/apt/sources.list.d/procursus.sources
echo "Components: main" >> /etc/apt/sources.list.d/procursus.sources
echo -e "\e[32mMigration Finished!\e[0m"
echo -e "\e[32mBack To Uncursus Script...\e[0m"
fi
