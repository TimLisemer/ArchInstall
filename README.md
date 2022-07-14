# ArchInstall

##Install Arch
###Links
https://itsfoss.com/install-arch-linux/
https://itsfoss.com/install-kde-arch-linux/
### Commands
Partition disks:
'''
fdisk /dev/nvme0n1
'''
'''
d
n
+1024M
t
1
'''
'''
n
'''
'''
w
'''
Create filesystem 
'''
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
'''
Select an appropriate mirror
'''
pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "DE" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
'''
Install Arch Linux
'''
mount /dev/nvme0n1p2 /mnt
pacstrap /mnt base linux linux-firmware vim nano
'''
Configure the installed Arch system
'''
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
timedatectl set-timezone Europe/Berlin
'''
Setting up Locale
'''
nano /etc/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
export LANG=en_GB.UTF-8
'''
Network configuration
'''
echo TimLinux > /etc/hostname
nano /etc/hosts

127.0.0.1	localhost
::1		localhost
127.0.1.1	TimLinux
'''
Setting up root password
'''
passwd
'''
Install Grub bootloader
'''
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
'''
Create Additional user and enforce privileges
'''
pacman -S sudo

useradd -m tim
passwd tim
usermod -aG wheel,audio,video,storage tim
'''
Uncomment %wheel  line
'''
EDITOR=nano visudo
'''
Install Kde
'''
pacman -S xorg plasma plasma-wayland-session kde-applications 
systemctl enable sddm.service
systemctl enable NetworkManager.service
'''
Exit
'''
exit
reboot
'''
