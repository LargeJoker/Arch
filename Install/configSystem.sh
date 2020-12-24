#!/bin/bash

#-----------------git----------------#
repositories=(Vim Linux Makefile Phytec)
gitDownloadOne(){
	git clone https://github.com/LargeJoker/$1
}

gitDownloadAll(){
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
downloadSoftware(){
	echo "starting to download the software"

	sudo pacman -S \
		vim python cmake nodejs npm ctags \
		ranger aria2 unzip unrar ntfs-3g man \
		xorg xorg-xinit \
		xf86-video-intel xf86-video-vmware virtualbox-guest-utils qtcreator qt5 \
		linux-lts linux-lts-headers \
		i3 alacritty dmenu ttf-dejavu wqy-zenhei \
		firefox firefox-i18n-zh-cn chromium \
		fcitx fcitx-configtool \
		feh mplayer libreoffice virtualbox goldendict python-pip \
		cronie rsync
}

#-----------------configuration----------------#
configRanger(){
	ranger --copy-config=all
	cp -r ${srcDir}/ArchConfig/ranger ~/.config/
}
configI3(){
	cp -r ${srcDir}/ArchConfig/i3 ~/.config/
}
configVIM(){
	cp ${srcDir}/Vim/* ~/.vim/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}
configureSoftware(){
	cd ~
	mkdir .config git  .vim
	cd git
	gitDownloadAll

    srcDir=~/git
	cp ${srcDir}/ArchConfig/xinitrc .xinitrc
	cp ${srcDir}/ArchConfig/inputrc .inputrc
}

downloadSoftware
configureSoftware
configVim

