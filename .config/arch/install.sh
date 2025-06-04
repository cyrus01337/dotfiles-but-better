#!/usr/bin/env bash
timedatectl set-timezone Europe/London

pacman -Sy archlinux-keyring

# TODO: Setup partitions


mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
swapon /dev/sda2
mount --mkdir /dev/sda1 /mnt/boot

pacstrap -K /mnt amd-ucode base dolphin efibootmgr fastfetch gtkmm3 limine linux-firmware linux-zen man-db man-pages networkmanager open-vm-tools sddm sddm-kcm sudo texinfo vim

genfstab -U /mnt >> /mnt/etc/fstab

# the following must be done in an arch-chroot environment
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

echo -n "en_GB.UTF-8 UTF-8" > /etc/locale.gen
echo -n "LANG=en_GB.UTF-8" > /etc/locale.conf
locale-gen

echo -n "KEYMAP=uk" > /etc/vconsole.conf

echo -n "arch" > /etc/hostname

useradd -mG wheel cyrus
passwd cyrus

echo "cyrus ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

systemctl enable NetworkManager sddm vmtoolsd

mkdir -p /boot/EFI/limine
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine
efibootmgr --create --disk /dev/sda --part 1 --label "Arch" --loader "\EFI\limine\BOOTX64.EFI" --unicode

curl -o /boot/limine.conf https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main/.config/arch/limine.conf

umount -R /mnt
reboot
