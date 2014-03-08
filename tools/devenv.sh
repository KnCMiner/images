#!/bin/sh

cat >/etc/opkg/feeds.conf <<\EOF
src/gz noarch http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/all/
src/gz base http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/cortexa8hf-vfp-neon/base/
src/gz beaglebone http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/cortexa8hf-vfp-neon/machine/beaglebone/
EOF
opkg update
opkg install angstrom-feed-configs
rm /etc/opkg/feeds.conf
opkg update

opkg install update-alternatives
opkg install util-linux
opkg install e2fsprogs-mke2fs

cp -rp /config .
umount /config
cp config/* /config
fdisk /dev/mmcblk0 <<END
n
p



w
q
END

mount /config

mkfs.ext4 /dev/mmcblk0p4
mount /dev/mmcblk0p4 /mnt
mount /dev/mmcblk0p2 /boot
cd /mnt
dd if=/boot/initramfs.bin bs=64 skip=1 | zcat | cpio -idm --no-absolute-filenames
mount --bind /proc /mnt/proc
mount --bind /dev /mnt/dev
cp /etc/resolv.conf /mnt/etc/

chroot /mnt sh -c "
cat >/etc/opkg/feeds.conf <<\EOF
src/gz noarch http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/all/
src/gz base http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/cortexa8hf-vfp-neon/base/
src/gz beaglebone http://feeds.angstrom-distribution.org/feeds/v2013.06/ipk/eglibc/cortexa8hf-vfp-neon/machine/beaglebone/
EOF
opkg update
opkg install angstrom-feed-configs
rm /etc/opkg/feeds.conf
opkg update
opkg install update-alternatives
opkg install automake autoconf make gcc cpp binutils git less pkgconfig-dev ncurses-dev libtool nano bash i2c-tools-dev libcurl-dev
"

cd
umount -R /mnt

cat >/config/newroot <<END
#!/bin/sh
if [ ! -d /mnt/proc ]; then
    mount /dev/mmcblk0p4  /mnt
    mount --rbind /proc /mnt/proc
    mount --rbind /dev /mnt/dev
    mount --rbind /sys /mnt/sys
fi
cp /etc/resolv.conf /mnt/etc/
chroot /mnt
END
chmod +x /config/newroot
