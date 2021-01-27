#!/bin/bash

srcDir=~/git
configFileDir=${srcDir}/Arch/Configure
vimrcDir=${srcDir}/Vim
binDir=${srcDir}/Arch/Bin
#-----------------Folder----------------#
createFolder(){
	cd ~
	mkdir .config git  .vim Downloads
}
#-----------------git----------------#
repositories=(Ubuntu Makefile Phytec Arch Vim)

gitDownloadOne(){
	git clone https://github.com/LargeJoker/$1
}

gitDownloadAll(){
	cd ${srcDir}
	reNum=${#repositories[*]}
	let "reNum--"

	while(( $reNum >= 0 ))
	do
		echo "$reNum"
		rep=${repositories[$reNum]}
		echo "$rep"
		gitDownloadOne $rep
		let "reNum--"
	done
}

#-----------------download----------------#
#............software list...........#
#
#bash-completion :auto-complete the commands and name of file including user and sudo
#virtualbox-guest-utils 
#amlue is used as downloading the "ed2k"
#uget is used as downloading BT and so on
#
#....................................#
downloadSoftware(){
	echo "starting to download the software"

	sudo pacman -S \
		vim python cmake nodejs npm ctags \
		ranger aria2 unzip unrar ntfs-3g man \
		xorg xorg-xinit \
		xf86-video-intel xf86-video-vmware qtcreator qt5 \
		linux-lts linux-lts-headers \
		i3 alacritty dmenu ttf-dejavu wqy-zenhei \
		chromium \
		fcitx fcitx-configtool \
		virtualbox virtualbox-host-modules-arch wget\
		feh mplayer libreoffice goldendict python-pip \
		cronie rsync amule uget ntp\
		alsa-utils bash-completion
}

#-----------------configuration----------------#


configRanger(){
	ranger --copy-config=all
	cp -r ${configFileDir}/ranger ~/.config/
}
configI3(){
	cp -r ${configFileDir}/i3 ~/.config/
	cp ${configFileDir}/xinitrc ~/.xinitrc
	cp ${configFileDir}/bash_profile ~/.bash_profile
}
configVIM(){
	cp ${vimrcDir}/* ~/.vim/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}
configVirtual(){
	version=$(vboxmanage -v)
	echo $version
	var1=$(echo $version | cut -d 'r' -f 1)
	echo $var1
	var2=$(echo $version | cut -d 'r' -f 2)
	echo $var2
	#file="Oracle_VM_VirtualBox_Extension_Pack-$var1-$var2.vbox-extpack"
	file="Oracle_VM_VirtualBox_Extension_Pack-$var1.vbox-extpack"
	echo $file
	wget https://download.virtualbox.org/virtualbox/$var1/$file -O ~/Downloads/$file --no-check-certificate
	
	##sudo VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
	sudo VBoxManage extpack install ~/Downloads/$file --replace
}

#configure the HOSTS for github
configHosts(){
	sudo echo "#Github" >> /etc/hosts
	sudo echo "140.82.113.3 https://github.com" >> /etc/hosts
	sudo echo "199.232.69.194 https://github.global.ssl.fastly.net" >> /etc/hosts
}

configSystemTime(){
     timedatectl list-timezones
     timedatectl set-timezone Asia/Shanghai
     sudo timedatectl set-ntp true
}

configureFcitx(){
	echo "you must run the "fcitx-configtool" for adding the "Pinyin""
	echo "you must run the "fcitx-configtool" for adding the "Pinyin""
	echo "you must run the "fcitx-configtool" for adding the "Pinyin""
}

configureMountDisk(){
	sudo fdisk -l
	read -p "need to mount the second disk? [Y/n]"  option
	if [ $option} == "Y" -o ${option} == "y"]
	then
		clear
		sudo blkid
		read -p "Please input the disk's UUID"  diskUUID
		sudo echo "UUID=${diskUUID}		~/Disk ntfs		rw,relatime		0,0" >> /etc/fstab
	fi
}

configureMyBin(){
	cp -r ${binDir} ~/
	chmod +x ~/Bin/*
}
#coonfigureUserLocale(){
#	touch .config/loacale.conf
#	echo "LANG=en_US.UTF-8"
#	echo "LANG=en_CN.UTF-8"
#	echo "LANG=en_TW.UTF-8"
#	echo "LANG=en_CN.GB2312"
#
#}

configureSoftware(){
	createFolder

	configHosts
	gitDownloadAll

	configVIM
	configI3
	configRanger
	configVirtual

	cp ${configFileDir}/inputrc ~/.inputrc
	cp ${configFileDir}/xinitrc ~/.xinitrc
	cp ${configFileDir}/bash_profile ~/.bash_profile
	configSystemTime
	configureMountDisk
	configureFcitx
	configureFcitx
	configureFcitx
}

#-----------------execute----------------#
downloadSoftware
configureSoftware


