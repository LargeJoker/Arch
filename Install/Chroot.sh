#!/bin/bash

# set the system of time, character, root's passwd, user's name, user's passwd, image,  upgrade and grub
rootPasswd=$1
userName=$2
userPasswd=$3

setTime(){
	echo "local setting"

	echo "setting local time"
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	hwclock --systohc
}
setCharacter(){
	echo "setting local character"
	echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
	echo zh_CN.UTF-8 UTF-8 >> /etc/locale.gen
	echo zh_TW.UTF-8 UTF-8 >> /etc/locale.gen
	locale-gen
	echo LANG=en_US.UTF-8 >> /etc/locale.conf
}
setRootPasswd(){	
	echo "setting root and passwd"
	echo root >> /etc/hostname
	
	/usr/bin/expect <<-EOF
	spawn passwd root
	expect "New password:\r"
	send "${rootPasswd}\r"
	expect "Retype new password:\r"
	send "${rootPasswd}\r"
	expect eof
	EOF
}
setUserNameAndPasswd(){
	echo "setting user name and passwd"
	useradd -m -G root -s /bin/bash $userName
	
	/usr/bin/expect <<-EOF
	spawn passwd $userName
	expect "New password:\r"
	send "${userPasswd}\r"
	expect "Retype new password:"
	send "${userPasswd}\r"
	expect eof
	EOF

	echo "joker ALL=(ALL) ALL" >> /etc/sudoers
}

generateImage(){
	echo "generate image"
	mkinitcpio -P
}
upgradeSystem(){
	echo "upgrade system"
	pacman -Syu
}


launchManage(){
#	grub-install --target=i386-pc /dev/sda
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
	grub-mkconfig -o /boot/grub/grub.cfg
	
}

setConfigFileAccessRight(){
    chown joker configSystem.sh
    chgrp joker configSystem.sh
    mv configSystem.sh /home/${userName}
}

setTime
setCharacter
setRootPasswd	
setUserNameAndPasswd
generateImage
upgradeSystem
launchManage
setConfigFileAccessRight
