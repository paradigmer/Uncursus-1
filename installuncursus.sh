#!/bin/bash
if [ "$EUID" -ne 0 ]; then
echo You need to run this script as root.
else
need=""
command -v unzip >/dev/null 2>&1 || need+="unzip "
command -v plutil >/dev/null 2>&1 || need+="com.bingner.plutil "
command -v curl >/dev/null 2>&1 || need+="curl "
command -v wget >/dev/null 2>&1 || need+="wget "
clear
echo "Copyright (c) 2020, Yaya4 All rights reserved."
echo -e "\e[31mWelcome to Uncursus Installation Script V2.0.4 (Stable) By @Yaya4_4 on Twitter.\e[0m"
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
echo "Checking if you're using a clean install of unc0ver..."
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
echo "If you've found any bugs, please create an issue in GitHub."
echo "Checking Dependencies..."
if [[ $need != "" ]]; then
echo "Installing Dependencies..."
apt update
apt install $need -y
fi
echo "Pulling and executing the Procursus Migration Script"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Yaya48/Uncursus/new/procursus-migration.sh)"
echo "Creating a custom directory for the required files. Path (/User/Documents/uncursus)."
rm -rf /User/Documents/uncursus
mkdir /User/Documents/uncursus
mkdir /User/Documents/uncursus/u0
echo "Done. Setuping Uncursus Repo...."
echo "Types: deb" > /etc/apt/sources.list.d/odyssey.sources
echo "URIs: https://yaya48.github.io/uncursusrepo" >> /etc/apt/sources.list.d/uncursus.sources
echo "Suites: ./" >> /etc/apt/sources.list.d/uncursus.sources
echo "Components: " >> /etc/apt/sources.list.d/uncursus.sources
echo "" >> /etc/apt/sources.list.d/uncursus.sources
mkdir -p /etc/apt/preferenced.d/
echo "Package: *" > /etc/apt/preferenced.d/uncursus
echo "Pin: release n=uncursus-ios" >> /etc/apt/preferenced.d/uncursus
echo "Pin-Priority: 1001" >> /etc/apt/preferenced.d/uncursus
echo "" >> /etc/apt/preferenced.d/uncursus
wget -q -O - https://github.com/Yaya48/uncursusrepo/raw/master/keyFile | sudo apt-key add -
apt update
echo "Done. Installing Sileo"
apt install org.coolstar.sileo -y
echo "Done. Downloading necessities"
rm -rf /usr/bin/cynject
wget -q https://apt.bingner.com/debs/1443.00/com.ex.substitute_0.1.14_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
wget -q https://apt.bingner.com/debs/1443.00/com.saurik.substrate.safemode_0.9.6003_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
echo "Done. Installing necessities..."
apt install essential-dummy -y lzma -y
dpkg -i --force-all /User/Documents/uncursus/u0/*.deb
echo "Done. Running Firmware Configuration (./firmware.sh)"
/usr/libexec/firmware
echo "Bootstrap installation complete. Cleaning up..."
rm -rf /User/Documents/uncursus/
echo "Uninstalling Cydia..."
apt purge cydia -y
uicache -a
echo "All Done."
touch /.installed_odyssey
touch /.procursus_strapped
sbreload
fi
fi
fi
