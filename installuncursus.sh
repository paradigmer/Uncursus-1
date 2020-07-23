#!/bin/bash
if [ "$EUID" -ne 0 ]; then
echo You need to run this script as root.
else
clear
echo -e "\e[31mWelcome to Uncursus Installation Script V1.3.2 (Stable) By @Yaya4_4 on Twitter.\e[0m"
echo "WARNING: I'M NOT RESPONSIBLE IF ANYTHING GOES WRONG"
echo "If you've found any bugs, please create an issue in GitHub."
echo "Installing Dependencies..."
apt update
apt install unzip -y
apt install com.bingner.plutil -y
apt install zsh -y
apt install curl -y
echo "Pulling and executing the Procursus deployment script..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Yaya48/Uncursus/new/procursus-deploy-u0.sh)"
echo "Pulling and installing official Procursus debians..."
rm -rf /User/Documents/uncursus
mkdir /User/Documents/uncursus
apt update
apt install wget -y --allow-unauthenticated
VER=$(/usr/bin/plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist)
if [[ "${VER%.*}" -ge 12 ]] && [[ "${VER%.*}" -lt 13 ]]; then
echo "cock"
elif [[ "${VER%.*}" -ge 13 ]]; then
echo "iOS 13 Dectected Installing iOS 13 Procursus Deb"
wget https://github.com/Yaya48/Uncursus/blob/new/debprocursussystem-1600.zip?raw=true --directory-prefix=/User/Documents/uncursus/
unzip /User/Documents/uncursus/debprocursussystem-1600.zip?raw=true -d /User/Documents/uncursus/
dpkg -i /User/Documents/uncursus/debprocursussystem/*.deb
else
echo "iOS 12 Dectected Installing iOS 12 Procursus Deb"
wget https://github.com/Yaya48/Uncursus/blob/new/debprocursussystem-1500.zip?raw=true --directory-prefix=/User/Documents/uncursus/
unzip /User/Documents/uncursus/debprocursussystem-1500.zip?raw=true -d /User/Documents/uncursus/
dpkg -i /User/Documents/uncursus/debprocursussystem1500/*.deb
fi
echo "Done. Creating a custom directory for the required files. Path (/User/Documents/)."
mkdir /User/Documents/uncursus/u0
wget https://github.com/Yaya48/Uncursus/blob/new/debpatch.zip?raw=true --directory-prefix=/User/Documents/uncursus/
unzip /User/Documents/uncursus/debpatch.zip?raw\=true -d /User/Documents/uncursus/debpatch
rm -rf /usr/bin/cynject
wget https://apt.bingner.com/debs/1443.00/com.ex.substitute_0.1.14_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
wget https://apt.bingner.com/debs/1443.00/com.saurik.substrate.safemode_0.9.6003_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
echo "Done. Installing necessities..."
dpkg -i --force-all /User/Documents/uncursus/debpatch/us.diatr.sileorespring_1.1_iphoneos-arm.deb
dpkg -i --force-all /User/Documents/uncursus/debpatch/coreutils-bin.deb
dpkg -i --force-all /User/Documents/uncursus/debpatch/libssl.deb
dpkg -i --force-all /User/Documents/uncursus/debpatch/lzma.deb
dpkg -i --force-all /User/Documents/uncursus/debpatch/ncurses5-libs.deb
dpkg -i --force-all /User/Documents/uncursus/debpatch/xz.deb
dpkg -i --force-all /User/Documents/uncursus/u0/*.deb
echo "Done. Running Firmware Configuration (./firmware.sh)"
/usr/libexec/firmware
echo "Bootstrap installation complete. Cleaning up..."
rm -rf /User/Documents/uncursus/
echo "Uninstalling Cydia..."
apt update
apt install cydia -y --allow-unauthenticated
apt purge cydia -y
uicache -a
echo "All Done."
killall SpringBoard
fi
