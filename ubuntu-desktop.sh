#!/usr/bin/env bash

# Basic keyboard, language and time configuration for a vanilla Ubuntu 18.04 LTS install on VMware Fusion (10.1.3)

# USAGE: 


if [ -f /home/steve/set-locale.run ]; then
	clear
	echo "ERROR: 'set-locale.sh' has already been run."
	exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `set-locale.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set timezone
timedatectl set-timezone Europe/London

# Enable network time synchronization
timedatectl set-ntp true

# Add `setxkbmap` to .bashrc so it runs at login and sets the keyboard correctly
tee -a ~/.bashrc <<EOF

# Set keyboard model and layout
setxkbmap -model apple -layout gb

# Message to display for each new Terminal window
printf "Use control [ctrl]+\ for # character\n\n"

EOF

# LANGUAGE: English (United Kingdom)
# REGIONAL FORMATS: United Kingdom
sudo tee /etc/default/locale <<EOF
LANG="en_GB.UTF-8"
LANGUAGE="en_GB:en"
LC_NUMERIC="en_GB.UTF-8"
LC_TIME="en_GB.UTF-8"
LC_MONETARY="en_GB.UTF-8"
LC_PAPER="en_GB.UTF-8"
LC_IDENTIFICATION="en_GB.UTF-8"
LC_NAME="en_GB.UTF-8"
LC_ADDRESS="en_GB.UTF-8"
LC_TELEPHONE="en_GB.UTF-8"
LC_MEASUREMENT="en_GB.UTF-8"
EOF


# LANGUAGE: English (United Kingdom)
# REGIONAL FORMATS: United Kingdom
sudo tee ~/.pam_environment <<EOF
LANGUAGE DEFAULT=en_GB:en
LANG DEFAULT=en_GB.UTF-8
LC_NUMERIC DEFAULT=en_GB.UTF-8
LC_TIME DEFAULT=en_GB.UTF-8
LC_MONETARY DEFAULT=en_GB.UTF-8
LC_PAPER DEFAULT=en_GB.UTF-8
LC_NAME DEFAULT=en_GB.UTF-8
LC_ADDRESS DEFAULT=en_GB.UTF-8
LC_TELEPHONE DEFAULT=en_GB.UTF-8
LC_MEASUREMENT DEFAULT=en_GB.UTF-8
LC_IDENTIFICATION DEFAULT=en_GB.UTF-8
PAPERSIZE DEFAULT=a4
EOF

# Set volume (survives reboot)
amixer cset iface=MIXER,name="Master Playback Volume" 25 >/dev/null




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SHOW HIDDEN FILES
#
# 

gsettings set org.gtk.Settings.FileChooser show-hidden  true




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# FORCE DISPLAY OF GRUB MENU AT BOOT
#
# SOURCE: https://askubuntu.com/a/1078723

sudo sed -i 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu\nGRUB_HIDDEN_TIMEOUT=/g' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub

sudo update-grub




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SET DISPLAY SCALE (200%)
#
# SOURCE: https://ubuntuforums.org/showthread.php?t=2384128

gsettings set org.gnome.desktop.interface scaling-factor 2




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SET LOGIN SCREEN SCALE (200%)
#
# SOURCE: https://askubuntu.com/a/1126769

sudo tee /usr/share/glib-2.0/schemas/93_hidpi.gschema.override <<EOF
[org.gnome.desktop.interface]
scaling-factor=2
text-scaling-factor=0.87
EOF

sudo glib-compile-schemas /usr/share/glib-2.0/schemas




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SET LOGIN SCREEN SIZE (1152x864)
#
# SOURCE: https://askubuntu.com/a/1041697 and https://askubuntu.com/a/54068

#sudo tee -a /etc/default/grub <<EOF

#GRUB_GFXMODE=1152x864x32
#GRUB_GFXPAYLOAD_LINUX=keep
#EOF

sudo sed -i 's/#GRUB_GFXMODE=640x480/#GRUB_GFXMODE=640x480\nGRUB_GFXMODE=1152x864x32\nGRUB_GFXPAYLOAD_LINUX=keep\nGRUB_CMDLINE_LINUX_DEFAULT="nomodeset"/g' /etc/default/grub

sudo update-grub



touch /home/steve/set-locale.run




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# RESTART
#
# 

clear

#read -p "Press enter to logout"
#gnome-session-quit

read -p "Press enter to restart"
shutdown -r now