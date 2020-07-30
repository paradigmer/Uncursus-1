#!/bin/bash
if [ "$EUID" -ne 0 ]; then
echo You need to run this script as root.
else
clear
echo -e "\e[31mWelcome to Uncursus Installation Script V2.0.0 (Beta2) By @Yaya4_4 on Twitter.\e[0m"
echo "Checking If Is A Clean Install Of Unc0ver..."
if [[ -f "/.procursus_strapped" ]]; then
echo "Please do not use this on odyssey or on an already uncursus installation.."
exit 1
fi
if [[ -f "/.bootstrapped" ]]; then
echo "Please do not use this on checkra1n"
exit 1
fi
echo "WARNING: I'M NOT RESPONSIBLE IF ANYTHING GOES WRONG"
echo "If you've found any bugs, please create an issue in GitHub."
echo "Installing Dependencies..."
apt update
apt install unzip -y
apt install com.bingner.plutil -y
apt install curl -y
echo "Pulling and executing the Procursus Migration Script"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Yaya48/Uncursus/beta/procursus-migration.sh)"
echo "Done. Creating a custom directory for the required files. Path (/User/Documents/uncursus)."
rm -rf /User/Documents/uncursus
mkdir /User/Documents/uncursus
mkdir /User/Documents/uncursus/u0
echo "Done. Setuping Uncursus Repo...."
echo "Types: deb" > /etc/apt/sources.list.d/odyssey.sources
echo "URIs: https://yaya48.github.io/uncursusrepo" >> /etc/apt/sources.list.d/odyssey.sources
echo "Suites: ./" >> /etc/apt/sources.list.d/odyssey.sources
echo "Components: " >> /etc/apt/sources.list.d/odyssey.sources
echo "" >> /etc/apt/sources.list.d/odyssey.sources
mkdir -p /etc/apt/preferenced.d/
echo "Package: *" > /etc/apt/preferenced.d/odyssey
echo "Pin: release n=uncursus-ios" >> /etc/apt/preferenced.d/odyssey
echo "Pin-Priority: 1001" >> /etc/apt/preferenced.d/odyssey
echo "" >> /etc/apt/preferenced.d/odyssey
echo "Done. Installing Sileo"
wget -q https://github.com/coolstar/Odyssey-bootstrap/raw/master/org.coolstar.sileo_1.8.1_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus
dpkg -i /User/Documents/uncursus/org.coolstar.sileo_1.8.1_iphoneos-arm.deb
apt update
apt install wget -y --allow-unauthenticated
echo "Done. Downloading necessities"
wget https://yaya48.gq/files/uncursus/debpatch.zip --directory-prefix=/User/Documents/uncursus/
unzip /User/Documents/uncursus/debpatch.zip -d /User/Documents/uncursus/debpatch
rm -rf /usr/bin/cynject
wget -q https://apt.bingner.com/debs/1443.00/com.ex.substitute_0.1.14_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
wget -q https://apt.bingner.com/debs/1443.00/com.saurik.substrate.safemode_0.9.6003_iphoneos-arm.deb --directory-prefix=/User/Documents/uncursus/u0
echo "Done. Installing necessities..."
dpkg -i --force-all /User/Documents/uncursus/debpatch/*.deb
dpkg -i --force-all /User/Documents/uncursus/u0/*.deb
echo "Done. Running Firmware Configuration (./firmware.sh)"
/usr/libexec/firmware
echo "Bootstrap installation complete. Cleaning up..."
rm -rf /User/Documents/uncursus/
echo "Uninstalling Cydia..."
apt purge cydia -y
uicache -a
echo "All Done."
ldrestart
fi
