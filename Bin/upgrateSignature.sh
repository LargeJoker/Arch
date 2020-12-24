#!/bin/bash

updatePacmanKey(){
	pacman-key --init
	pacman-key --populate archlinux
	pacman-key --refresh-keys
}
pacman -Syu
updatePacmanKey
