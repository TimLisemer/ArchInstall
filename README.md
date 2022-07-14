# ArchInstall
Install and Setup Arch optimized for my Computer
## Install Arch
Copy Paste to Install Arch Linux
### Links
https://itsfoss.com/install-arch-linux/
https://itsfoss.com/install-kde-arch-linux/
### Commands
Partition disks:
```
fdisk /dev/nvme0n1
```
```
d
n
+1024M
t
1
```
```
n
```
```
w
```
Create filesystem 
```
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
```
Select an appropriate mirror
```
pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "DE" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
```
Install Arch Linux
```
mount /dev/nvme0n1p2 /mnt
pacstrap /mnt base linux linux-firmware vim nano
```
Configure the installed Arch system
```
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
timedatectl set-timezone Europe/Berlin
```
Setting up Locale
```
nano /etc/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
export LANG=en_GB.UTF-8
```
Network configuration
```
echo TimLinux > /etc/hostname
nano /etc/hosts

127.0.0.1	localhost
::1		localhost
127.0.1.1	TimLinux
```
Setting up root password
```
passwd
```
Install Grub bootloader
```
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
```
Create Additional user and enforce privileges
```
pacman -S sudo

useradd -m tim
passwd tim
usermod -aG wheel,audio,video,storage tim
```
Uncomment %wheel  line
```
EDITOR=nano visudo
```
Install Kde
```
pacman -S xorg plasma plasma-wayland-session kde-applications 
systemctl enable sddm.service
systemctl enable NetworkManager.service
```
Exit
```
exit
reboot
```

## Setup Arch
### Install nvidia Driver

Uncomment Multilib lines
```
sudo nano /etc/pacman.conf
```
```
sudo pacman -Syy
sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils
```
Reboot
### Setup fancontrol
```
sudo pacman -S git
cd /home/tim
git clone https://github.com/TimLisemer/ArchInstall.git
cd ArchInstall
cd fancontrol
sudo cp -R CommanderPro /etc
sudo cp CommanderPro.service /etc/systemd/system
sudo systemctl enable CommanderPro
sudo systemctl daemon-reload
sudo systemctl enable CommanderPro --now
```
### Install Basic tools and programs needed to properly use the operating system
```
sudo pacman -S firefox
xdg-settings set default-web-browser firefox.desktop
sudo pacman -S packagekit-qt5 flatpak fwupd
sudo pacman -S --needed base-devel

cd /tmp/
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv opus wavpack x264 xvidcore
sudo pacman -S vlc audacious
sudo pacman -S adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts noto-fonts-cjk
```

### Install Steam
https://wiki.archlinux.org/title/steam
```
sudo pacman -S ttf-liberation wqy-zenhei lib32-systemd
sudo pacman -S steam
steam
```

### Install Spotify & Discord
```
yay -S spotify
sudo pacman -S discord
```

### Install Development Environments
Visual Studio Code
```
sudo pacman -S code
yay -S code-marketplace
```
Jetbrains
```
yay -S jetbrains-toolbox
```
Java Python Gcc Maven
```
sudo pacman -S jdk-openjdk python python-pip gcc maven
```
