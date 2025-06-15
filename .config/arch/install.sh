#!/usr/bin/env bash
# TODO: Prefer chroot over arch-chroot
set -e

DOTFILES_URL="https://raw.githubusercontent.com/cyrus01337/dotfiles-but-better/refs/heads/main"
LABEL="${LABEL-Arch}"
UNMOUNT=${UNMOUNT-true}
REBOOT=${REBOOT-true}
DISK="${DISK-/dev/sda}"
MANUALLY_ASSIGN_PASSWORD=${MANUALLY_ASSIGN_PASSWORD-false}
# PASSWORD="..."

get_partition() {
    number="$1"

    if test $DISK = *"nvme"*; then
        echo "${DISK}p${number}"
    else
        echo "${DISK}${number}"
    fi
}

log() {
    message="$1"

    echo ""
    echo "$message"
    echo ""
}

log "Confirming user creation details..."

if test ! $PASSWORD && test $MANUALLY_ASSIGN_PASSWORD = true; then
    echo "Set and export the variable PASSWORD so that user account creation can be automated"
    echo ""
    echo "If you'd rather do this yourself, set and export the variable MANUALLY_ASSIGN_PASSWORD"

    exit 1
fi

log "Performing prep work..."

timedatectl set-timezone Europe/London && \
    dd if=/dev/zero of=$DISK bs=512 count=1

sed -i -E "s/^#(Color|ParallelDownloads.+)/\1/g" /etc/pacman.conf && \
    sed -i "s/!ccache/ccache/" /etc/makepkg.conf && \
    sed -i -E "s/#MAKEFLAGS=.*/MAKEFLAGS='--jobs=\$(nproc)'/" /etc/makepkg.conf && \
    sed -i -E 's/RUSTFLAGS="(.*)"/RUSTFLAGS="\1 -C link-arg=-fuse-ld=mold/"' /etc/makepkg.conf.d/rust.conf && \
    echo "LDFLAGS+=' -fuse-ld=mold'" >> /etc/makepkg.conf && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -S --needed --noconfirm ccache mold

log "Setting up partitions..."

umount -R /mnt 2> /dev/null || true
parted $DISK --script mklabel gpt && \
    parted $DISK --script mkpart primary ext4 1MiB 1025MiB && \
    parted $DISK --script set 1 boot on && \
    parted $DISK --script mkpart primary linux-swap 1025MiB 9217MiB && \
    parted $DISK --script mkpart primary ext4 9217MiB 100%

log "Configuring filesystems..."

mkfs.fat -F 32 $(get_partition 1) && \
    mkswap $(get_partition 2) && \
    mkfs.ext4 -F $(get_partition 3)

mount $(get_partition 3) /mnt && \
    swapon $(get_partition 2) && \
    mount --mkdir $(get_partition 1) /mnt/boot

log "Bootstrapping..."

# TODO: Span packages across multiple lines
pacstrap -K /mnt alacritty amd-ucode base base-devel dolphin efibootmgr fastfetch git gtkmm3 limine linux-firmware linux-firmware-qlogic linux-zen man-db man-pages networkmanager open-vm-tools plasma-desktop sddm sddm-kcm sudo texinfo vim && \
    arch-chroot /mnt pacman -Rns --noconfirm mkinitcpio && \
    rm /mnt/boot/initramfs-* && \
    sed -i -E "s/^#(Color|ParallelDownloads.+)/\1/g" /mnt/etc/pacman.conf

genfstab -U /mnt >> /mnt/etc/fstab

log "Configuring initramfs (Booster)..."

curl -Lo /mnt/etc/booster.yaml "$DOTFILES_URL/.config/arch/booster.yaml" && \
    arch-chroot /mnt pacman -S --noconfirm booster

log "Configuring locale..."

ln -sf /usr/share/zoneinfo/Europe/London /mnt/etc/localtime && \
    arch-chroot /mnt hwclock --systohc

echo -n "en_GB.UTF-8 UTF-8" > /mnt/etc/locale.gen && \
    echo -n "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf && \
    echo -n "KEYMAP=uk" > /mnt/etc/vconsole.conf && \
    echo -n "arch" > /mnt/etc/hostname && \
    arch-chroot /mnt locale-gen

log "Creating user..."

arch-chroot /mnt useradd -m cyrus

# this script is to automate guest installations where snapshots fail,
# never do this for public-facing/online systems where security matters
if test $MANUALLY_ASSIGN_PASSWORD = false && test $PASSWORD; then
    echo "$PASSWORD" | arch-chroot /mnt passwd cyrus --stdin
elif test $MANUALLY_ASSIGN_PASSWORD = true; then
    arch-chroot /mnt passwd cyrus
fi

echo "cyrus ALL=(ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers

log "Installing Yay..."

arch-chroot /mnt su cyrus -c "git clone https://aur.archlinux.org/yay.git /home/cyrus/bin/yay" && \
    arch-chroot /mnt su cyrus -c "env GOFLAGS=-buildvcs=false makepkg -cirs --needed --noconfirm --dir /home/cyrus/bin/yay" && \
    arch-chroot /mnt su cyrus -c "yay --cleanafter --removemake --save --answerclean all --answerdiff none --answeredit none --answerupgrade all" && \
    arch-chroot /mnt su cyrus -c "yay -Syu --noconfirm"

log "Installing additional firmware..."

arch-chroot /mnt su cyrus -c "yay -S --noconfirm aic94xx-firmware ast-firmware wd719x-firmware upd72020x-fw"

log "Enabling services..."

arch-chroot /mnt systemctl enable NetworkManager sddm vmtoolsd

log "Setting up bootloader..."

mkdir -p /mnt/boot/EFI/limine && \
    cp /mnt/usr/share/limine/BOOTX64.EFI /mnt/boot/EFI/limine && \
    arch-chroot /mnt efibootmgr --create --disk $DISK --part 1 --label $LABEL --loader "\EFI\limine\BOOTX64.EFI" --unicode && \
    curl -Lo /mnt/boot/limine.conf "$DOTFILES_URL/.config/arch/limine.conf"

if test $LABEL != "Arch"; then
    sed -i "s/^\/Arch$/\/$LABEL/" /mnt/boot/limine.conf
fi

if test $UNMOUNT; then
    echo "Unmounting..."

    umount -R /mnt
fi

if test $REBOOT; then
    # avoid drive corruption via naive check for mounted filesystems
    if test -d /mnt/boot; then
        echo "Found mounted filesystem, unmounting..."

        umount -R /mnt 2> /dev/null || true
    fi

    echo "Rebooting..."

    reboot
fi
