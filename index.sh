function warning() {
    echo -e "\e[33m$1 \e[0m"
}

function success() {
    echo -e "\e[32m$1 \e[0m"
}

function error() {
    echo -e "\e[31m$1 \e[0m"
}


apt-get update >/dev/null
success "Success! apt-get update done."

apt-get upgrade -y >/dev/null
success "Success! apt-get upgrade done."

apt-get install -y git curl wget unzip python3-pip python3 >/dev/null
success "Success! apt-get install done."

apt-get install -y figlet lolcat >/dev/null
figlet -w 150 "$(sed 's/.*/\u&/' </etc/hostname)" | /usr/games/lolcat -f >/etc/motd
chmod -x /etc/update-motd.d/* >/dev/null
success "Success! MOTD set up."


if [ -x "$(command -v docker)" ]; then
    warning "Docker already installed."
else
    curl -fsSL https://get.docker.com | sh >/dev/null 2>&1
    success "Success! Docker installed."
fi

if [ -x "$(command -v docker-compose)" ]; then
    warning "Docker Compose already installed."
else
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null 2>&1
    chmod +x /usr/local/bin/docker-compose >/dev/null
    success "Success! Docker Compose installed."
fi

success "Success! All done."
