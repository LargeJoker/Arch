#!/bin/bash
#cleanSystem.sh
#running the script must being root.

pacman -Scc
pacman -Rns $(pacman -Qtdq)
journalctl --vacuum-size=10M
