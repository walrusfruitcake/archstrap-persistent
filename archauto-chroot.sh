#!/bin/sh

# inside chroot

HOSTNAME=barnacle
ESP="/boot"


die() {
  echo "Last command failed"
  exit
}

echo "Setting hostname"
echo $HOSTNAME > /etc/hostname || die

echo "Setting timezone"
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime || die

echo "Setting up locale"
sed --in-place=.orig "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen || die
# additional locale for preferred time format
sed -i "s/#en_DK.UTF-8/en_DK.UTF-8/" /etc/locale.gen || die

locale-gen || die

echo "LANG=en_US.UTF-8" > /etc/locale.conf || die
echo "LC_TIME=en_DK.UTF-8" >> /etc/locale.conf || die

echo "FONT=Tamsyn7x14r" > /etc/vconsole.conf || die

echo "Setting up initramfs"
# increasing block hook priority for booting from flash
sed --in-place=.orig "s/^HOOKS=\(.*\)block/HOOKS=\1/" /etc/mkinitcpio.conf || die
sed -i "s/^HOOKS=\(.*\)udev/HOOKS=\1udev block/" /etc/mkinitcpio.conf || die
mkinitcpio -p linux || die

echo "Setting up bootloader"
mkdir -p $ESP/EFI/syslinux || die
cp -r /usr/lib/syslinux/efi64/* $ESP/EFI/syslinux/ || die
efibootmgr -c -d /dev/sdb -p 2 -l /EFI/syslinux/syslinux.efi -L "Syslinux" || die
sed --in-place=.orig "s/APPEND root=.*/APPEND root=UUID=0d9f9a68-b3e4-477e-aa3e-712fb7b01e52 ro/" /boot/syslinux/syslinux.cfg || die

echo "Skipping MBR install since targeting UEFI"

echo "Set root password"
passwd || die

