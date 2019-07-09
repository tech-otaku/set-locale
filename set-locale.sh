#!/usr/bin/env bash

# Basic keyboard, language and time configuration for a vanilla Ubuntu 18.04 LTS install on VMware Fusion (10.1.3)

# USAGE: 
# wget -O /home/steve/Downloads/set-locale.zip https://codeload.github.com/tech-otaku/set-locale/zip/master
# cd /home/steve/Downloads
# unzip /home/steve/Downloads/set-locale.zip
# bash /home/steve/Downloads/set-locale-master/set-locale.sh


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `set-locale.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set timezone
timedatectl set-timezone Europe/London

# Enable network time synchronization
timedatectl set-ntp true

# Add `setxkbmap` to .profile so it runs at login and sets the keyboard correctly
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

clear

#source ~/.bashrc

read -p "Press enter to logout"
gnome-session-quit

#read -p "Press enter to restart"
#shutdown -r now