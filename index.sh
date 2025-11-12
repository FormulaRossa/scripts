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
 apt-get install -y git curl wget unzip python3-pip python3 screen >/dev/null
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
    target_version="2.40.3"
    if command -v docker-compose >/dev/null 2>&1; then
        current_version=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        
        if [ "$(printf '%s\n' "$current_version" "$target_version" | sort -V | head -n1)" = "$current_version" ] && [ "$current_version" != "$target_version" ]; then
            warning "Older Docker Compose version ($current_version) detected, updating to $target_version..."
        else
            warning "Docker Compose already installed and up to date (version $current_version)."
            return 0
        fi
    else
        warning "Docker Compose not installed, installing version $target_version..."
    fi

    sudo curl -L "https://github.com/docker/compose/releases/download/v${target_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null 2>&1
    sudo chmod +x /usr/local/bin/docker-compose >/dev/null

    installed_version=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if [ "$installed_version" = "$target_version" ]; then
        success "Success! Docker Compose version $installed_version installed."
    else
        failure "Failed to install Docker Compose version $target_version."
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
