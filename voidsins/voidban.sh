#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
VAR=$1
if [ -z "${VAR}" ]; then 
	echo "Use the package name you want to ban as a parameter"
	exit 1
fi
mkdir -p /etc/voidsins
requires=`xbps-query -Rp shlib-provides $VAR`
allpkg=`xbps-query -Rs \ | awk '{print $2}'`
#echo $allpkg
#requireds=`echo $allpkg | awk '{xbps-query -Rp shlib-requires $1}
isrequired=''
for pkg in $allpkg ; do
	required=`xbps-query -Rp shlib-requires $pkg`
	#echo $pkg
	#echo $required
	for provides in $requires ; do
		#echo $required
		#echo $provides
		if echo "$required" | grep $provides > /dev/null; then
			echo "$pkg" > /dev/null
			if [[ $? -eq 0 ]] ; then
				echo "banning $pkg"
				isrequired=`xbps-query -Rp pkgname $pkg`
				echo "ignorepkg=$isrequired" >> /tmp/69-banned-script.conf
				echo "$isrequired" >> /etc/voidsins/banned.pkg
			fi
		fi
	done
done
echo "Banned em all"
#echo $isrequired
cp /tmp/69-banned-script.conf /etc/voidsins/69-banned-script.conf
cp /etc/voidsins/69-banned-script.conf /etc/xbps.d/
#need recursion


