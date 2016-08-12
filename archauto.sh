#!/bin/sh

TARGET_UUID="0d9f9a68-b3e4-477e-aa3e-712fb7b01e52"
BOOT_UUID="D16E-99D1"

START_DIR=`pwd`

die() {
  echo "Last command failed"
  exit
}


wifi-menu

########################################################
### Starting arch install from mount partitions step ###
########################################################

echo "Assuming main and boot partitions formatted as ext3/4 and FAT, respectively"

cd /dev/disk/by-uuid

echo "Disabling journaling on target partition"
# in case ext4 was created with journaling
tune2fs -O "^has_journal" $TARGET_UUID || die
e2fsck -f $TARGET_UUID || die

echo "Mounting partitions"
# mount with correct option before generating fstab
mount -c -o noatime $TARGET_UUID /mnt || die
mkdir /mnt/boot
mount -c -o noatime $BOOT_UUID /mnt/boot || die

echo "Modifying mirrorlist"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig || die
grep -A 1 "United States" /etc/pacman.d/mirrorlist.orig | grep -v "\-\-" > /etc/pacman.d/mirrorlist || die

echo "Pacstrapping"
pacstrap /mnt base base-devel syslinux efibootmgr dosfstools mtools zsh grml-zsh-config tamsyn-font vim git wireless_tools wpa_supplicant rfkill net-tools dialog netctl xorg-server xorg-xinit awesome firefox || die


# Configure

echo "Generating fstab"
# noatime in fstab based on how the partition was mounted
cp /mnt/etc/fstab /mnt/etc/fstab.orig || die
genfstab -Up /mnt > /mnt/etc/fstab || die

echo "Executing script in chroot"
cd $START_DIR || die


cp archauto-chroot.sh /mnt/root/arch-chroot.sh
chmod 500 /mnt/root/archauto-chroot.sh || die

# commands passed as: arch-chroot /mnt command
arch-chroot /mnt /root/archauto-chroot.sh || die

