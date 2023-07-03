#!/bin/bash
# Author:       Lean Schuler
# Description:  This script bootstraps new servers with the following:
#               - Updates and upgrades packages
#               - Installs important packages
#               - Generates a MOTD
#               - Installs Docker
#               - Installs Docker Compose


function warning() {
    echo -e "\e[33m$1 \e[0m"
}

function success() {
    echo -e "\e[32m$1 \e[0m"
}

function error() {
    echo -e "\e[31m$1 \e[0m"
}


function check_supported(){
 if [ ! -f /etc/debian_version ]; then
     error "Error! This script is only tested on Debian."
     read -p -r "Press Ctrl+C to exit or Enter to continue."
 fi
}

function update_packages(){
 apt-get update >/dev/null
 success "Success! apt-get update done."
}

function upgrade_packages(){
 apt-get upgrade -y >/dev/null
 success "Success! apt-get upgrade done."
}

function install_packages(){
 apt-get install -y git curl wget unzip python3-pip python3 >/dev/null
 success "Success! important packages installed."
}

function generate_motd(){
 apt-get install -y figlet lolcat >/dev/null
 figlet -w 150 "$(sed 's/.*/\u&/' </etc/hostname)" | /usr/games/lolcat -f >/etc/motd
 chmod -x /etc/update-motd.d/* >/dev/null
 success "Success! MOTD set up."
}

function install_docker() {
  if [ -x "$(command -v docker)" ]; then
      warning "Docker already installed."
  else
      curl -fsSL https://get.docker.com | sh >/dev/null 2>&1
      success "Success! Docker installed."
  fi
}

function install_compose() {
 if [ -x "$(command -v docker-compose)" ]; then
     warning "Docker Compose already installed."
 else
     sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null 2>&1
     chmod +x /usr/local/bin/docker-compose >/dev/null
     success "Success! Docker Compose installed."
 fi
}

check_supported
update_packages
upgrade_packages
install_packages
generate_motd
install_docker
install_compose

success "Success! All done."
