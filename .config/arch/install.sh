#!/usr/bin/env bash
set -e

LABEL="${LABEL-Arch}"
DOTFILES_URL="https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main"

timedatectl set-timezone Europe/London

sed -i -E "s/^#(Color|ParallelDownloads.+)/\1/g" /etc/pacman.conf && \
    pacman -Sy --noconfirm archlinux-keyring

umount -R && \
    curl -LO "$DOTFILES_URL/.config/arch/partitions.layout" && \
    sfdisk --wipe always --wipe-partitions always /dev/sda < partitions.layout

mkfs.fat -F 32 /dev/sda1 && \
    mkswap -F /dev/sda2 && \
    mkfs.ext4 -F /dev/sda3

mount /dev/sda3 /mnt && \
    swapon /dev/sda2 && \
    mount --mkdir /dev/sda1 /mnt/boot

pacstrap -K /mnt amd-ucode base dolphin efibootmgr fastfetch gtkmm3 limine linux-firmware linux-zen man-db man-pages networkmanager open-vm-tools plasma-desktop sddm sddm-kcm sudo texinfo vim

genfstab -U /mnt >> /mnt/etc/fstab

ln -sf /usr/share/zoneinfo/Europe/London /mnt/etc/localtime && \
    arch-chroot /mnt hwclock --systohc

echo -n "en_GB.UTF-8 UTF-8" > /mnt/etc/locale.gen && \
    echo -n "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf && \
    echo -n "KEYMAP=uk" > /mnt/etc/vconsole.conf && \
    echo -n "arch" > /mnt/etc/hostname && \
    arch-chroot /mnt locale-gen

arch-chroot /mnt useradd -m cyrus && \
    passwd cyrus && \
    echo "cyrus ALL=(ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers

arch-chroot /mnt systemctl enable NetworkManager sddm vmtoolsd

mkdir -p /mnt/boot/EFI/limine && \
    cp /mnt/usr/share/limine/BOOTX64.EFI /mnt/boot/EFI/limine && \
    arch-chroot /mnt efibootmgr --create --disk /dev/sda --part 1 --label $LABEL --loader "\EFI\limine\BOOTX64.EFI" --unicode && \
    curl -Lo /mnt/boot/limine.conf "$DOTFILES_URL/.config/arch/limine.conf"

if test $LABEL != "Arch"; then
    sed -i "s/^\/Arch$/\/$LABEL/" /mnt/boot/limine.conf
fi

umount -R /mnt && \
    reboot
