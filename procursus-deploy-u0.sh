#!/bin/bash
if [ $(uname) = "Darwin" ]; then
	if [ $(uname -p) = "arm" ] || [ $(uname -p) = "arm64" ]; then
		echo "It's recommended this script be ran on macOS/Linux with a clean iOS device running checkra1n attached unless migrating from older bootstrap."
		read -p "Press enter to continue"
		ARM=yes
	fi
fi

echo "odysseyra1n deployment script"
echo "(C) 2020, CoolStar. All Rights Reserved"

echo ""
echo "Before you begin: This script includes experimental migration from older bootstraps to Procursus/Odyssey."
echo "If you're already jailbroken, you can run this script on the checkra1n device."
echo "If you'd rather start clean, please Reset System via the Loader app first."
read -p "Press enter to continue"

echo "Downloading Resources..."
curl -L -O https://github.com/coolstar/odyssey-bootstrap/raw/master/bootstrap_1500-ssh.tar.gz -O https://github.com/coolstar/odyssey-bootstrap/raw/master/bootstrap_1600-ssh.tar.gz -O https://github.com/coolstar/odyssey-bootstrap/raw/master/migration -O https://github.com/coolstar/odyssey-bootstrap/raw/master/org.coolstar.sileo_1.8.1_iphoneos-arm.deb

if [[ -f "/.bootstrapped" ]]; then
mkdir -p /odyssey && mv migration /odyssey
chmod 0755 /odyssey/migration
/odyssey/migration
rm -rf /odyssey
else
VER=$(/usr/bin/plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist)
if [[ "${VER%.*}" -ge 12 ]] && [[ "${VER%.*}" -lt 13 ]]; then
CFVER=1500
elif [[ "${VER%.*}" -ge 13 ]]; then
CFVER=1600 
else
echo "${VER} not compatible."
exit 1
fi
gzip -d bootstrap_${CFVER}-ssh.tar.gz
mount -uw -o union /dev/disk0s1s1
rm -rf /etc/profile
rm -rf /etc/profile.d
rm -rf /etc/alternatives
rm -rf /etc/apt
rm -rf /etc/ssl
rm -rf /etc/ssh
rm -rf /etc/dpkg
rm -rf /Library/dpkg 
rm -rf /var/cache 
rm -rf /var/lib 
tar --preserve-permissions -xkf bootstrap_${CFVER}-ssh.tar -C /
/Library/dpkg/info/openssh.postinst || true 
launchctl load -w /Library/LaunchDaemons/com.openssh.sshd.plist || true
fi 
/usr/libexec/firmware 
mkdir -p /etc/apt/sources.list.d/ 
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
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games dpkg -i org.coolstar.sileo_1.8.1_iphoneos-arm.deb 
uicache -p /Applications/Sileo.app 
echo -n "" > /var/lib/dpkg/available 
/Library/dpkg/info/profile.d.postinst 
touch /.mount_rw 
touch /.installed_odyssey 
rm bootstrap*.tar* 
rm org.coolstar.sileo_1.8.1_iphoneos-arm.deb 
rm odyssey-device-deploy.sh 
