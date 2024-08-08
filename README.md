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
ef
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
pacstrap /mnt base linux linux-firmware vim nano git
```
Configure the installed Arch system
```
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```
Setting up Locale
```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
```
Network configuration
```
echo Tim-Linux > /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	Tim-Linux" >> /etc/hosts
```
Setting up root password
```
passwd
```
Install Grub bootloader
```
pacman -S grub efibootmgr os-prober
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi

nano /etc/default/grub
GRUB_DISABLE_OS_PROBER=false
GRUB_CMDLINE_LINUX="nvidia_drm.modeset=1 rd.driver.blacklist=nouveau modprob.blacklist=nouveau"

cd /tmp
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -b -t whitesur -i whitesur -s 2k

grub-mkconfig -o /boot/grub/grub.cfg
```
Create Additional user and enforce privileges
```
pacman -S sudo

useradd -m tim
passwd tim
usermod -aG wheel,audio,video,storage docker tim
```

```
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
```

### Kde / Gnome Desktop Enviroment
Install Kde
```
pacman -S plasma plasma-wayland-session egl-wayland kde-applications networkmanager sddm firefox git

systemctl enable sddm.service NetworkManager.service avahi-daemon

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
```

Install Gnome
```
pacman -S networkmanager gdm gnome firefox git

systemctl enable gdm.service NetworkManager.service avahi-daemon

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

sudo pacman -S archlinux-appstream-data
pacman -Syy

sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules

Add to /etc/enviroment
MUTTER_DEBUG_KMS_THREAD_TYPE=user
```
## Setup Arch
### Setup fancontrol
__Only works in combination with an Amd Cpu and a Corsair Commander Pro__
```
cd /tmp
git clone https://github.com/TimLisemer/ArchInstall.git
cd ArchInstall/fancontrol
sudo cp -R CommanderPro /etc
sudo cp CommanderProStart.service /etc/systemd/system
sudo systemctl enable CommanderProStart
sudo systemctl daemon-reload
sudo systemctl enable CommanderProStart --now
```
### Install Basic tools and programs needed to properly use the operating system
```
sudo os-prober
grub-mkconfig -o /boot/grub/grub.cfg
xdg-settings set default-web-browser firefox.desktop
sudo pacman -S packagekit-qt5 flatpak fwupd curl base-devel
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

cd /tmp/
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

yay -S gnome-browser-connector adw-gtk3-git mkinitcpio-firmware minecraft-launcher

sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv opus wavpack x264 x265 xvidcore
sudo pacman -S adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji

sudo pacman -S vlc audacious

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Install nvidia Driver
```
sudo pacman -Syy
sudo pacman -S --needed nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

sudo nano /etc/mkinitcpio.conf
change MODULES=() to MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

sudo mkinitcpio -P
```
#### Add Pacman Hook for nvidia driver
```
sudo mkdir /etc/pacman.d/hooks
sudo nano /etc/pacman.d/hooks/nvidia.hook
```
```
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```
#### Nvidia Hardware Acceleration
```
yay -S  libva-nvidia-driver
sudo pacman -S ffmpeg libva-utils vdpauinfo
vainfo
vdapuinfo 
```
#### Nvidia Tearing fix - Somehow autostart the following:
```
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
```


# Reboot
```
exit
reboot
```

### Install Gnome-Terminal
```
yay -S gnome-terminal-transparency
sudo pacman -R gnome-console
```

### Install Steam
https://wiki.archlinux.org/title/steam
```
sudo pacman -S ttf-liberation wqy-zenhei lib32-systemd
sudo pacman -S steam
steam
```

### Install Development Environments
Visual Studio Code
```
sudo pacman -S code
yay -S code-marketplace
```
Rust
```
sudo pacman -S rustup
rustup default stable
```

Java Python Gcc Maven
```
sudo pacman -S jdk-openjdk python python-pip gcc maven
```

Jetbrains
```
yay -S jetbrains-toolbox
```
Arduino
```
sudo pacman -S arduino

echo 'SUBSYSTEMS=="usb-serial", TAG+="uaccess"' | sudo tee -a /etc/udev/rules.d/01-ttyusb.rules >/dev/null
sudo udevadm control --reload-rules
```

Docker
```
pacman -S docker docker-compose
```

Install Fish Shell
```
sudo pacman -S fish

set -U fish_greeting ""

chsh -s /bin/fish
fish_config
```

### Setup RGB

CKB-NEXT -> Corsair Keyboards:
```
yay -S ckb-next
sudo systemctl enable ckb-next-daemon --now
```

OpenRGB Installation:
```
sudo pacman -S --needed git base-devel qt5-base qt5-tools libusb mbedtls2 qt5-tools mbedtls

https://gitlab.com/CalcProgrammer1/OpenRGB#arch

flatpak install flathub org.openrgb.OpenRGB
yay -S python-openrgb openrgb

sudo wget https://gitlab.com/CalcProgrammer1/OpenRGB/-/jobs/4477053324/artifacts/raw/60-openrgb.rules -O /usr/lib/udev/rules.d/60-openrgb.rules

sudo udevadm control --reload-rules && sudo udevadm trigger

sudo pacman -S i2c-tools
sudo modprobe i2c-dev
sudo groupadd --system i2c
sudo usermod $USER -aG i2c
sudo touch /etc/modules-load.d/i2c.conf && sudo sh -c 'echo "i2c-dev" >> /etc/modules-load.d/i2c.conf'
sudo modprobe i2c-piix4
```

OpenRGB Documentation for my PC:
```
Lightning Node Core:
	Corsair Channel 1: Radiator Fan + Fan Back
		-> 3 Fan * 8 Leds = 24 Leds
	Corsair Channel 2: unused
	
Corsair Commander Pro:
	Corsair Channel 1: Fan Front
		-> 3 Fan * Led led = 3 Leds
	Corsair Channel 2: RGB Strip
		-> 3 * 40 Leds in parallel = 40 leds

Asus ROG Strix X470-F GAMING:
	Back I/O: Onboard Leds
	RGB Header: unused
	RGB Header 2: unused
```

### Setup Gnome

Setup Gnome Settings, Extension-Settings, Tweaks using Dconf:
```
sudo curl -sSL https://raw.githubusercontent.com/TimLisemer/ArchInstall/main/dconf.txt | dconf load -f /
```

Store using Dconf:
```
dconf dump / >> dconf.txt
```

### Setup KDE
https://www.youtube.com/watch?v=kcOZ4wPZdxY&t
https://www.youtube.com/watch?v=A0LiFu1eaMs&t

KDE Settings:

Download Layan Global Theme & set it

Download Layan GDK Theme & set it

Setup Layan as Sddm Theme


Download Kwantum
```
sudo pacman -S kwantum
```
Download Layan Kwantum theme from Website & install it using Kwantum application
```
https://store.kde.org/p/1325246/
```
Setup Latte Dock
```
yay -S latte-dock
cd /tmp
git clone https://github.com/TimLisemer/ArchInstall.git
```
Import /tmp/ArchInstall/LatteLayout.latte into latte Dock

Open KRunner with the Meta key
```
sudo kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
sudo qdbus org.kde.KWin /KWin reconfigure
```

Recommended Widgets:
Better Inline Clock; Application title; Latte Spacer; 
