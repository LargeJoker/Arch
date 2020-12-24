#!/bin/bash

#backup
#1. mount all system and backup disk

#mount /dev/nvme0n1p2 /mnt
#mount /dev/nvme0n1p1 /mnt/boot/efi
#mount /dev/disk /backup

#2. execute command "chroot" into the system
#arch-chroot /mnt /bin/bash

#3. compress system through file "execlude"
#tar cvpjf name.tar.bz2 --exclude-from=/exclude /


#restore
#1. mount all system and restoring disk
#mount /dev/nvme0n1p2 /mnt
#mount /dev/nvme0n1p1 /mnt/boot/efi
#mount /dev/disk restore

#2. move to the mounting file and restore the system
#cd /mnt
#tar xcpjf /name.tar.bz2

#3. generate fstab
#genfstab -U -p /mnt >> /mnt/etc/fstab

#4. execute command "chroot" into the system
#arch-chroot /mnt /bin/bash

#5. configure the "grub"
#grub-mkconfig -o /boot/grub/grub.cfg



#!/bin/bash

# full system backup

# Backup destination
#backdest=/opt/backup
backdest=/opt/backup

# Labels for backup name
#PC=${HOSTNAME}
pc=pavilion
distro=arch
type=full
date=$(date "+%F")
backupfile="$backdest/$distro-$type-$date.tar.gz"

# Exclude file location
prog=${0##*/} # Program name from filename
excdir="/home/<user>/.bin/root/backup"
exclude_file="$excdir/$prog-exc.txt"

# Check if chrooted prompt.
echo -n "First chroot from a LiveCD.  Are you ready to backup? (y/n): "
read executeback

# Check if exclude file exists
if [ ! -f $exclude_file ]; then
  echo -n "No exclude file exists, continue? (y/n): "
  read continue
  if [ $continue == "n" ]; then exit; fi
fi

if [ $executeback = "y" ]; then
  # -p and --xattrs store all permissions and extended attributes. 
  # Without both of these, many programs will stop working!
  # It is safe to remove the verbose (-v) flag. If you are using a 
  # slow terminal, this can greatly speed up the backup process.
  tar --exclude-from=$exclude_file --xattrs -czpvf $backupfile /
fi

