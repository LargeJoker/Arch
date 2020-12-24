#!/bin/bash


getParameter(){
	echo "$1:"
	read $2
}
getDiskAndFile(){
	getParameter "Please input the installing disk"  sysDisk
	getParameter "Please input the grub disk"  grubDisk
	getParameter "Please input the mounting file:"  mountFile
	echo "system disk is $sysDisk, GRUB disk is $grubDisk, mounting file is $mountFile"
}

getSysUser(){
	getParameter "Please input the root password"  rootPasswd
	getParameter "Please input the user name"  userName
	getParameter "Please input the user password"  userPasswd
	echo "device type is $devType, root's password is $rootPasswd, user's name is $userName, user's password is $userPasswd"
}

formatAndMountDisk(){
	echo "start format the disk"
	mkfs.ext4 $sysDisk
	mkfs.fat -F 32 /$grubDisk
}

mountAndGrubDisk(){
	echo "mount the system's disk and GRUB's disk"
	mount $sysDisk $mountFile
	mkdir -p $mountFile/boot/efi
	mount $grubDisk $mountFile/boot/efi
}

changeMirrorlist(){
	echo "change the mirrorlist"
	cd /etc/pacman.d
	cp mirrorlist mirrorlist.bk
	cat mirrorlist.bk | grep China -A 1| grep -v '-' > mirrorlist
	cd -
}

downloadLinux(){
	echo "download the linux"
	pacstrap -i /$mountFile base base-devel linux linux-firmware \
				dhcpcd networkmanager expect git grub
}

generateFstab(){
	echo "generate the fstab"
	genfstab -U -p /$mountFile >> /$mountFile/etc/fstab
}

ArchChroot(){
	echo "CHROOT into the file of mounting"
	cp Chroot.sh /$mountFile
	cp configSystem.sh /$mountFile
	arch-chroot /$mountFile /bin/bash -c "bash Chroot.sh $rootPasswd $userName $userPasswd "
}


getDiskAndFile
getSysUser
formatAndMountDisk
mountAndGrubDisk
#changeMirrorlist
downloadLinux
generateFstab
ArchChroot
